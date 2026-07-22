{...}: {
  services.alloy = {
    enable = true;

    configPath = ./config;

    extraFlags = [
      "--server.http.listen-addr=127.0.0.1:12346"
      "--disable-reporting"
    ];
  };
}
