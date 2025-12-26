# Fix GeoIP Resolution Not Being Added to VictoriaLogs

**Date:** 2025-12-29  
**Status:** FIXED  
**Issue:** GeoIP enrichment (country, latitude, longitude) was not appearing in VictoriaLogs entries

## Problem Analysis

The Suricata to Grafana Alloy pipeline was configured correctly (verified through code exploration), but GeoIP data was not being added to logs in VictoriaLogs. Investigation revealed the root cause.

## Root Cause

**File:** `hosts/modules/linux/shared/alloy/default.nix`  
**Line:** 29

The activation script was trying to retrieve the GeoIP license key from the **wrong host**:

```nix
# WRONG - retrieves license from "home-server" host
${pkgs.passage}/bin/passage hosts/home-server/geoip/license > /var/services/geoipupdate/license-key
```

But Alloy and geoipupdate services run on the **falcon** host, not home-server.

### Impact Chain

1. License key file written to `/var/services/geoipupdate/license-key` was empty
2. `geoipupdate` service couldn't authenticate to MaxMind (invalid key)
3. GeoLite2 databases never downloaded to `/var/lib/GeoIP/`
4. Alloy's `stage.geoip` couldn't find the database files
5. GeoIP lookups failed silently
6. Country/latitude/longitude labels never created
7. VictoriaLogs received logs without geographic enrichment

## Solution Implemented

Changed the license key path to reference the correct host:

```nix
# CORRECT - retrieves license from "falcon" host where Alloy runs
${pkgs.passage}/bin/passage hosts/falcon/geoip/license > /var/services/geoipupdate/license-key
```

### Change Details

```diff
File: hosts/modules/linux/shared/alloy/default.nix (line 29)

- ${pkgs.passage}/bin/passage hosts/home-server/geoip/license > /var/services/geoipupdate/license-key
+ ${pkgs.passage}/bin/passage hosts/falcon/geoip/license > /var/services/geoipupdate/license-key
```

## Verification Steps

After deploying the fix with `make host/apply`, verify on falcon host:

```bash
# 1. Check license key loaded
cat /var/services/geoipupdate/license-key
# Should show: 1108497... (actual MaxMind key, not empty)

# 2. Check databases downloaded
ls -lh /var/lib/GeoIP/
# Should show GeoLite2-City.mmdb and GeoLite2-Country.mmdb with actual file sizes

# 3. Check services running
systemctl status geoipupdate alloy
# Both should be: active (running)

# 4. Verify labels in VictoriaLogs
curl -s 'http://localhost:9428/api/v1/labels' | jq '.data[]' | grep -i country
# Should show: "dest_country", "source_country", "dest_country_latitude", etc.

# 5. Verify actual log entries have geographic data
curl -s 'http://localhost:9428/select/logsql/query' \
  -d 'query={job="syslog-ids"} | limit 1' | jq '.data[0].fields | keys'
# Should include fields with "country" and "latitude"/"longitude"
```

## Why This Works

The NixOS activation script runs on the **target host** (falcon) during system activation. It needs to retrieve the license key from the same host's secrets store. The path `hosts/falcon/geoip/license` tells Passage to look in falcon's secret configuration.

## Configuration Flow (After Fix)

```
System Boot/Reconfiguration
  ↓
activation script runs (on falcon)
  ↓
passage retrieves falcon's license key
  ↓
Written to /var/services/geoipupdate/license-key
  ↓
geoipupdate service starts
  ↓
Authenticates to MaxMind with correct key
  ↓
Downloads GeoLite2-City.mmdb, GeoLite2-Country.mmdb
  ↓
Alloy starts and finds databases
  ↓
stage.geoip performs IP geolocation
  ↓
Country/lat/long labels added to logs
  ↓
VictoriaLogs receives enriched entries
```

## Related Files (Not Changed, Already Correct)

- `hosts/modules/linux/shared/alloy/config/config.alloy` - Pipeline config ✓
- `hosts/modules/linux/shared/victorialogs.nix` - Storage config ✓
- `hosts/modules/linux/shared/grafana/default.nix` - Dashboard config ✓

All pipeline stages after license key retrieval were already correctly configured.

## Impact

**Before:** Logs stored without geographic context
```json
{
  "message": "ET MALWARE Suspicious Binary Download",
  "labels": {
    "host": "opnsense",
    "job": "syslog-ids",
    "alert_signature": "ET MALWARE Suspicious Binary Download"
    // Missing: source_country, dest_country, lat/long
  }
}
```

**After:** Logs stored with full geographic enrichment
```json
{
  "message": "ET MALWARE Suspicious Binary Download",
  "labels": {
    "host": "opnsense",
    "job": "syslog-ids",
    "alert_signature": "ET MALWARE Suspicious Binary Download",
    "source_country": "China",
    "dest_country": "United States",
    "source_country_latitude": 39.9,
    "source_country_longitude": 116.4,
    "dest_country_latitude": 37.4,
    "dest_country_longitude": -97.8
  }
}
```

## Next Steps

1. **Deploy:** Run `make host/apply` to build and deploy to falcon
2. **Verify:** SSH to falcon and run verification commands above
3. **Monitor:** Check `journalctl -u alloy -f` for any errors
4. **Query:** In Grafana, filter IDS alerts by destination country using new labels

## Testing Recommendation

After deployment, send test IDS alerts with:
- **Public IP as source** (e.g., from cloud provider) → Should show country
- **Public IP as destination** (e.g., external service) → Should show country
- **Private IP** (RFC 1918) → Will show no country (expected - not in GeoIP DB)

Geographic filtering should now work in Grafana dashboard (opnsense-ids ID 17547).

## Files Modified

- `hosts/modules/linux/shared/alloy/default.nix` (1 line changed)

## Lessons Learned

The issue highlights the importance of:
1. Host-specific configuration paths in multi-host deployments
2. Verifying that secrets are being retrieved from the correct source
3. Checking service status and logs when external data isn't loading
4. Understanding the deployment flow and where activation scripts execute

This issue affected geoipupdate service startup and demonstrates how a simple host path mistake can cascade through the entire monitoring pipeline.
