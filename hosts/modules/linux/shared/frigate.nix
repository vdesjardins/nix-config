{pkgs, ...}: let
  frigateConfig = {
    mqtt = {
      enabled = true;
      user = "root";
      password = "{FRIGATE_MQTT_PASSWORD}";
      host = "frigate.kube-stack.org";
      port = 1883;
    };

    record = {
      enabled = true;
      retain = {
        days = 7;
        mode = "motion";
      };
      alerts = {
        retain = {
          days = 30;
        };
      };
      detections = {
        retain = {
          days = 30;
        };
      };
    };

    detectors = {
      onnx_0 = {
        type = "onnx";
      };
    };

    model = {
      model_type = "yolox";
      width = 416;
      height = 416;
      input_dtype = "float_denorm";
      input_tensor = "nchw";
      path = "/config/model_cache/yolo_tiny.onnx";
      labelmap_path = "/labelmap/coco-80.txt";
    };

    go2rtc = {
      streams = {
        doorbell = [
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD}@10.0.0.101:554/Preview_01_main#backchannel=0"
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD}@10.0.0.101:554/Preview_01_sub"
        ];
        doorbell-sub = [
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD}@10.0.0.101:554/Preview_01_sub"
        ];
        backyard = [
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD}@10.0.0.238:554/Preview_01_main#backchannel=0"
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD}@10.0.0.238:554/Preview_01_sub"
        ];
        backyard-sub = [
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD}@10.0.0.238:554/Preview_01_sub"
        ];
      };
    };

    cameras = {
      doorbell = {
        detect = {
          enabled = true;
        };
        record = {
          enabled = true;
        };
        ffmpeg = {
          output_args = {
            record = "preset-record-generic-audio-aac";
          };
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/doorbell";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/doorbell-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
                "audio"
              ];
            }
          ];
        };
        zones = {
          Doorstep = {
            coordinates = "0.201,1,0.194,0.08,1,0.08,1,1";
            inertia = 3;
            loitering_time = 0;
            objects = "person";
            filters = {
              person = {
                min_area = 5000;
              };
            };
          };
        };
        audio = {
          enabled = true;
          max_not_heard = 10;
          min_volume = 500;
          listen = [
            "bark"
            "fire_alarm"
            "scream"
            "yell"
            "emergency_vehicule"
          ];
        };
        motion = {
          threshold = 40;
          contour_area = 15;
          mask = [
            "0.002,0.004,0.001,0.495,0.152,0.487,0.162,0.004"
            "0.342,0.006,0.283,0.415,0.783,0.463,0.859,0"
          ];
        };
        review = {
          alerts = {
            required_zones = "Doorstep";
          };
        };
      };
      backyard = {
        detect = {
          enabled = true;
        };
        record = {
          enabled = true;
        };
        ffmpeg = {
          output_args = {
            record = "preset-record-generic-audio-aac";
          };
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/backyard";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/backyard-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
                "audio"
              ];
            }
          ];
        };
        zones = {
          main = {
            coordinates = "0.293,0.649,0.278,0.67,0.318,0.993,0.98,1,0.751,0.495,0.397,0.382,0.395,0.439,0.369,0.467,0.375,0.522,0.356,0.578,0.334,0.606,0.312,0.642,0.303,0.64";
            inertia = 3;
            loitering_time = 0;
          };
          shed = {
            coordinates = "0.353,0.348,0.362,0.46,0.392,0.436,0.387,0.325";
            inertia = 3;
            loitering_time = 0;
            objects = "person";
            filters = {
              person = {
                min_area = 5000;
              };
            };
          };
          pool = {
            coordinates = "0.255,0.638,0.3,0.612,0.331,0.574,0.349,0.542,0.36,0.517,0.365,0.481,0.354,0.458,0.33,0.452,0.297,0.452,0.261,0.472,0.223,0.503,0.193,0.538,0.169,0.574,0.168,0.618,0.179,0.638,0.2,0.649";
            inertia = 3;
            loitering_time = 0;
            objects = "person";
            filters = {
              person = {
                min_area = 5000;
              };
            };
          };
        };
        audio = {
          enabled = true;
          max_not_heard = 10;
          min_volume = 500;
          listen = [
            "bark"
            "fire_alarm"
            "scream"
            "yell"
            "emergency_vehicule"
          ];
        };
      };
    };
  };

  yoloModelTiny = builtins.fetchurl {
    url = "https://github.com/Megvii-BaseDetection/YOLOX/releases/download/0.1.1rc0/yolox_tiny.onnx";
    sha256 = "sha256:1xxhf36c2awlpf41yad25qk5qhki6rg9p2g20dxgy9sfsdkc6z22";
  };

  configFile = (pkgs.formats.yaml {}).generate "frigate.yml" frigateConfig;
in {
  services.nginx = {
    enable = true;

    virtualHosts."frigate.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "https://localhost:8971";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };

      locations."/ws" = {
        proxyPass = "https://localhost:8971/ws";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";
        '';
      };

      locations."/live" = {
        proxyPass = "https://localhost:8971/live";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";
        '';
      };
    };
  };

  virtualisation.oci-containers = {
    containers = {
      frigate = {
        image = "ghcr.io/blakeblackshear/frigate:0.16.1-rocm";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/var/lib/frigate:/config"
          "${configFile}:/config/config.yaml:ro"
          "/data/frigate/data:/media/frigate"
          "${yoloModelTiny}:/config/model_cache/yolo_tiny.onnx:ro"
        ];

        devices = [
          "/dev/kfd:/dev/kfd"
          "/dev/dri:/dev/dri"
        ];

        ports = [
          "8971:8971"
          # RTSP
          "8554:8554"
          # Internal unauth
          # "5000:5000"
          # WebRTC over TCP
          "8555:8555/tcp"
          # WebRTC over UDP
          "8555:8555/udp"
          # go2rtc interface
          "1984:1984"
        ];

        extraOptions = [
          "--device=/dev/bus/usb"
          "--device=/dev/dri"
          "--device=/dev/kfd"
          "--tmpfs=/tmp/cache:rw,size=1g,mode=1777"
          "--shm-size=256mb"
          # "--network=mqtt-bridge"
          "--cap-add=PERFMON"
          "--cap-add=SYS_ADMIN"
          # "--group-add=keep-groups"
        ];

        environment = {
          HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        };

        environmentFiles = ["/var/services/frigate/env"];
      };
    };
  };

  system.activationScripts.service-frigate.text =
    # bash
    ''
      mkdir -p /var/services/frigate
      chmod 700 /var/services/frigate

      cat << EOF > /var/services/frigate/env
      FRIGATE_MQTT_PASSWORD=$(${pkgs.passage}/bin/passage hosts/home-server/mosquitto/password)
      FRIGATE_REOLINK_PASSWORD=$(${pkgs.passage}/bin/passage devices/cameras/doorbell/password)
      EOF
    '';
}
