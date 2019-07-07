if [[ "${TRAVIS_OS_NAME}" == osx ]]; then
cat > conda_build_config.yml <<END
CONDA_BUILD_SYSROOT:
- $(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${MACOSX_DEPLOYMENT_TARGET}.sdk # [osx]
END
cat conda_build_config.yml
fi
