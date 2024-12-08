{
  programs.nixvim = {
    plugins = {
      lsp.servers.yamlls.enable = true;

      schemastore = {
        enable = true;
        yaml = {
          enable = true;
          settings = {
            ignore = ["Deployer Recipe"];
            extra = [
              {
                description = "Kyverno Chainsaw Test Manifest";
                fileMatch = ["chainsaw-test.yaml" "chainsaw-test.yml"];
                name = "chainsaw-test.yaml";
                url = "https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/test-chainsaw-v1alpha1.json";
              }
              {
                description = "Kyverno Chainsaw Step Template Manifest";
                fileMatch = ["*step*.yaml" "*step*.yml"];
                name = "step.yaml";
                url = "https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/steptemplate-chainsaw-v1alpha1.json";
              }
              {
                description = "Kyverno Chainsaw Configuration Manifest";
                fileMatch = [".chainsaw.yaml" ".chainsaw.yml"];
                name = ".chainsaw.yaml";
                url = "https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/configuration-chainsaw-v1alpha2.json";
              }
            ];
          };
        };
      };
    };
  };
}
