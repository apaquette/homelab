{ lib }:

{
  assertEqual = name: expected: actual:
    assert lib.assertMsg (expected == actual)
      "${name}: expected ${builtins.toJSON expected}, got ${builtins.toJSON actual}";
    true;

  assertContains = name: value: list:
    assert lib.assertMsg (builtins.elem value list)
      "${name}: expected list to contain ${builtins.toJSON value}";
    true;

  assertPathExists = name: path:
    assert lib.assertMsg (builtins.pathExists path)
      "${name}: expected path to exist: ${toString path}";
    true;
}