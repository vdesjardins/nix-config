{config, ...}: {
  environment.systemPackages = [config.boot.kernelPackages.perf];

  boot.kernel.sysctl = {
    "kernel.ftrace_enabled" = true;
    "kernel.perf_event_paranoid" = 1;
    "kernel.kernel.kptr_restrict" = 0;
  };
}
