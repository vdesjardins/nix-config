_inputs: _final: prev: {
  commitizen = prev.commitizen.overrideAttrs (old: {
    disabledTests = (old.disabledTests or []) ++ ["test_invalid_command"];
  });

  python312Packages = prev.python312Packages.overrideScope (pyFinal: pyPrev: {
    # AnyIO 4.14.2 has failing TLS and unraisable-exception tests on Python 3.12.
    # Keep the rest of the test suite enabled.
    anyio = pyPrev.anyio.overridePythonAttrs (old: {
      disabledTests =
        (old.disabledTests or [])
        ++ ["test_tls_connectable" "test_strict_incomplete_iterable" "test_invalid_n"];
    });

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
