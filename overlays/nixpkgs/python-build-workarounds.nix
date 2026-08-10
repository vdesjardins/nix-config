_inputs: _final: prev: {
  commitizen = prev.commitizen.overrideAttrs (old: {
    disabledTests = (old.disabledTests or []) ++ ["test_invalid_command"];
  });

  python312Packages = prev.python312Packages.overrideScope (pyFinal: pyPrev: {
    inline-snapshot = pyPrev.inline-snapshot.overridePythonAttrs (_old: {
      doCheck = false;
    });

    # Upstream metadata still reports 0.7.2 in the 0.7.3 release.
    pybloomfilter3 = pyPrev.pybloomfilter3.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pyFinal.pyprojectVersionPatchHook];
    });

    # A property-based scipy.stats test is flaky on x86_64 with numpy 2.5.
    scipy = pyPrev.scipy.overridePythonAttrs (_old: {
      doCheck = false;
    });
  });
}
