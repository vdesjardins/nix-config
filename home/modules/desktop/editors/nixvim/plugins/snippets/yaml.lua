return {
  s(
    {
      trig = "schema",
      name = "Yaml Schema",
      desc = { "Adds a yaml-language-server schema to current buffer." },
    },
    fmt(
      [[
      # yaml-language-server: $schema={}
      ]],
      {
        i(1),
      }
    )
  ),
  s(
    { trig = "kustomize", name = "Kustomize", desc = { "Adds the kustomize boilerplate." } },
    fmt(
      [[
      # yaml-language-server: $schema=https://json.schemastore.org/kustomization.json
      apiVersion: kustomize.config.k8s.io/v1beta1
      kind: Kustomization

      resources: []
      ]],
      {}
    )
  ),
  s(
    {
      trig = "m",
      name = "directive end marker",
      desc = { "Adds directive end parker." },
    },
    fmt(
      [[
      ---

      ]],
      {}
    )
  ),
}
