_inputs: _final: prev: {
  tracy = prev.tracy.overrideAttrs (old: {
    env =
      (old.env or {})
      // {
        CXXFLAGS = toString (old.env.CXXFLAGS or "") + " -include cstdint";
      };
  });
}
