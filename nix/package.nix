{
  lib,
  mkHyprlandPlugin,
  hyprland,
  cmake,
}:
mkHyprlandPlugin {
  pluginName = "macos-zoom";
  version = "0.1.0";

  src = lib.cleanSourceWith {
    src = ../.;
    filter = path: _type: let
      name = baseNameOf path;
    in
      !(builtins.elem name ["nix" "flake.nix" "flake.lock" "assets" "build"]);
  };

  # Hyprland 0.55 has no State::monitorState(); fall back to g_pCompositor there
  patches = lib.optional (lib.versionOlder hyprland.version "0.56") ./hyprland-0.55-compat.patch;

  nativeBuildInputs = [cmake];
  cmakeFlags = ["-DBUILD_TESTING=OFF"];

  meta = {
    description = "Continuous macOS-like modifier-scroll screen zoom for Hyprland";
    homepage = "https://github.com/aastrand/hyprland-macos-zoom";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
