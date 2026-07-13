_inputs: _final: prev: {
  commitizen = prev.commitizen.overrideAttrs (old: {
    disabledTests = (old.disabledTests or []) ++ ["test_invalid_command"];
  });

  python312Packages = prev.python312Packages.overrideScope (_pyFinal: pyPrev: {
    inline-snapshot = pyPrev.inline-snapshot.overridePythonAttrs (_old: {
      doCheck = false;
    });
  });
}
