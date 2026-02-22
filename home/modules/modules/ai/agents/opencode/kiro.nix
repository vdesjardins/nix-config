{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.agents.opencode.kiro;
in {
  options.modules.ai.agents.opencode.kiro = {
    enable = mkEnableOption "kiro integration";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      settings = {
        plugin = ["@zhafron/opencode-kiro-auth"];

        provider = {
          kiro = {
            models = {
              claude-sonnet-4-5 = {
                name = "Claude Sonnet 4.5";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
              };
              claude-sonnet-4-5-thinking = {
                name = "Claude Sonnet 4.5 Thinking";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
                variants = {
                  low = {thinkingConfig = {thinkingBudget = 8192;};};
                  medium = {thinkingConfig = {thinkingBudget = 16384;};};
                  max = {thinkingConfig = {thinkingBudget = 32768;};};
                };
              };
              claude-haiku-4-5 = {
                name = "Claude Haiku 4.5";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image"];
                  output = ["text"];
                };
              };
              claude-opus-4-5 = {
                name = "Claude Opus 4.5";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
              };
              claude-opus-4-5-thinking = {
                name = "Claude Opus 4.5 Thinking";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
                variants = {
                  low = {thinkingConfig = {thinkingBudget = 8192;};};
                  medium = {thinkingConfig = {thinkingBudget = 16384;};};
                  max = {thinkingConfig = {thinkingBudget = 32768;};};
                };
              };
              claude-opus-4-6 = {
                name = "Claude Opus 4.6";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
              };
              claude-opus-4-6-thinking = {
                name = "Claude Opus 4.6 Thinking";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
                variants = {
                  low = {thinkingConfig = {thinkingBudget = 8192;};};
                  medium = {thinkingConfig = {thinkingBudget = 16384;};};
                  max = {thinkingConfig = {thinkingBudget = 32768;};};
                };
              };
              claude-opus-4-6-1m = {
                name = "Claude Opus 4.6 (1M Context)";
                limit = {
                  context = 1000000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
              };
              claude-opus-4-6-1m-thinking = {
                name = "Claude Opus 4.6 (1M Context) Thinking";
                limit = {
                  context = 1000000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
                variants = {
                  low = {thinkingConfig = {thinkingBudget = 8192;};};
                  medium = {thinkingConfig = {thinkingBudget = 16384;};};
                  max = {thinkingConfig = {thinkingBudget = 32768;};};
                };
              };
              claude-sonnet-4-5-1m = {
                name = "Claude Sonnet 4.5 1M";
                limit = {
                  context = 1000000;
                  output = 64000;
                };
                modalities = {
                  input = ["text" "image" "pdf"];
                  output = ["text"];
                };
              };
              qwen3-coder-480b = {
                name = "Qwen3 Coder 480B";
                limit = {
                  context = 200000;
                  output = 64000;
                };
                modalities = {
                  input = ["text"];
                  output = ["text"];
                };
              };
            };
          };
        };
      };
    };
  };
}
