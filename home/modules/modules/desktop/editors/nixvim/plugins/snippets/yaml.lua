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
        { trig = "k-kustomize", name = "Kustomize", desc = { "Adds the kustomize boilerplate." } },
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
            trig = "k-serviceaccount",
            name = "k8s ServiceAccount",
            desc = { "Adds the ServiceAccount boilerplate." },
        },
        fmt(
            [[
      # https://kubernetes.io/docs/concepts/configuration/serviceaccount/
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: {}
        namespace: {}
      {}
      ]],
            {
                i(1),
                i(2),
                i(3),
            }
        )
    ),
    s(
        {
            trig = "k-namespace",
            name = "k8s Namespace",
            desc = { "Adds the Namespace boilerplate." },
        },
        fmt(
            [[
      # https://kubernetes.io/docs/concepts/configuration/namespace/
      apiVersion: v1
      kind: Namespace
      metadata:
        name: {}
        namespace: {}
      {}
      ]],
            {
                i(1),
                i(2),
                i(3),
            }
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
