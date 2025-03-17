{pkgs, ...}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    wireplumber = {
      enable = true;

      extraConfig = {
        "90-disable-suspension" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  # Matches all sources
                  "node.name" = "~alsa_input.*";
                }
                {
                  # Matches all sinks
                  "node.name" = "~alsa_output.*";
                }
              ];
              actions = {
                update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];

          "monitor.bluez.rules" = [
            {
              matches = [
                {
                  # Matches all sources
                  "node.name" = "~bluez_input.*";
                }
                {
                  # Matches all sinks
                  "node.name" = "~bluez_output.*";
                }
              ];
              actions = {
                update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
    };
  };
}
