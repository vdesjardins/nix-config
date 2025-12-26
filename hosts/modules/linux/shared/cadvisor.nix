{...}: {
  services.cadvisor = {
    enable = true;

    port = 5000;
  };
}
