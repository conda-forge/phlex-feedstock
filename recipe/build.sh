#!/bin/bash -e
cmake ${CMAKE_ARGS} -S ${SRC_DIR} -B build --preset default \
    -DCMAKE_CXX_STANDARD=${root_cxx_standard} \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_TESTING=OFF \
    -DENABLE_CLANG_TIDY=OFF \
    -DFORM_USE_RNTUPLE_STORAGE=ON
cmake --build build --parallel ${CPU_COUNT}
cmake --install build

# Install conda activation scripts so PHLEX_PLUGIN_PATH points at the plugin libdir.
for CHANGE in activate deactivate; do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    for EXT in sh csh fish; do
        cp "${RECIPE_DIR}/${CHANGE}.${EXT}" \
           "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.${EXT}"
    done
done
