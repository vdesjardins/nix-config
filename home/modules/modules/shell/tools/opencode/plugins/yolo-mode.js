/**
 * YOLO Mode Plugin for OpenCode
 *
 * When OPENCODE_YOLO environment variable is set to "1", automatically
 * allows all bash/shell commands without confirmation prompts.
 *
 * This plugin listens for permission.asked events on the Bus and calls the
 * permission reply endpoint to auto-allow bash/shell commands.
 *
 * Uses structured logging via client.app.log() for debug visibility.
 */

// Default configuration
const DEFAULT_CONFIG = {
  debug: true,
};

let CONFIG = { ...DEFAULT_CONFIG };

/**
 * Log helper using client.app.log() for structured logging
 */
function log(client, message, extra = {}) {
  if (!CONFIG.debug) return;

  try {
    client.app.log({
      service: "YoloMode",
      level: "debug",
      message: message,
      timestamp: new Date().toISOString(),
      ...(Object.keys(extra).length > 0 && { extra }),
    });
  } catch (_err) {
    // Silently fail if logging error
  }
}

export const YoloModePlugin = async ({ client, _serverUrl, _$ }) => {
  const isYoloMode = process.env.OPENCODE_YOLO === "1";

  log(client, "Plugin initialized", {
    yoloMode: isYoloMode,
    envValue: process.env.OPENCODE_YOLO,
  });

  return {
    /**
     * Event handler - listens to all Bus events from OpenCode
     * The permission.asked event is emitted when a permission request needs decision
     * Event structure: { type: 'permission.asked', properties: { id, sessionID, permission, patterns, ... } }
     */
    event: async ({ event }) => {
      try {
        // Check if this is a permission.asked event
        if (event.type !== "permission.asked") {
          return;
        }

        const { id, permission, patterns, _metadata, sessionID } = event.properties;

        log(client, "Permission request event received", {
          permissionId: id,
          type: permission,
          patterns: patterns,
        });

        if (!isYoloMode) {
          log(client, "YOLO mode disabled, request will use default behavior");
          return;
        }

        // Auto-allow bash/shell commands
        if (permission === "bash" || permission === "shell") {
          log(client, "Auto-allowing permission", {
            type: permission,
            patterns: patterns,
          });

          // Call OpenCode API to reply with 'always' to auto-allow this command
          try {
            const _response = await client.postSessionIdPermissionsPermissionId({
              path: {
                id: sessionID,
                permissionID: id,
              },
              body: {
                response: "always",
              },
            });

            log(client, "Permission reply sent", {
              permissionId: id,
              response: "always",
            });
          } catch (err) {
            log(client, "Permission reply error", {
              permissionId: id,
              errorMessage: err.message,
            });
          }
        } else {
          log(client, "Not auto-allowing non-bash/shell permission", { type: permission });
        }
      } catch (err) {
        log(client, "Event handler error", { error: err.message });
      }
    },
  };
};

export default YoloModePlugin;
