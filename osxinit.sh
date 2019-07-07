curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall > ~/uninstall_homebrew
chmod +x ~/uninstall_homebrew
~/uninstall_homebrew -fq

cat > conda_build_config.yml <<END
CONDA_BUILD_SYSROOT:
- $(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${MACOSX_DEPLOYMENT_TARGET}.sdk # [osx]
END
cat conda_build_config.yml
