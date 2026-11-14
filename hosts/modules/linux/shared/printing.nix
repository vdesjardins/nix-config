{...}: {
  services.printing = {
    enable = true;
    # This host is a print client, not a LAN print server.
    listenAddresses = ["localhost:631"];
    openFirewall = false;
    defaultShared = false;
    browsing = false;
  };

  hardware.printers = {
    ensureDefaultPrinter = "Brother-HL-3170CDW";
    ensurePrinters = [
      {
        name = "Brother-HL-3170CDW";
        description = "Brother HL-3170CDW";
        deviceUri = "ipp://10.0.0.6/ipp/print";
        model = "everywhere";
      }
    ];
  };
}
