##################################################################################################
#
# COMMANDER X16 EMULATOR MAKEFILE
#
##################################################################################################

BUILD_DIR = build
WASM_BUILD_DIR = build-wasm
BUILD_TYPE ?= Release
# rom.bin bundled into the wasm build
X16_ROM ?= rom.bin

.PHONY: all wasm clean distclean

all:
	@cmake -E echo "Building with CMake"
	cmake -E make_directory $(BUILD_DIR)
	cmake -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
	cmake --build $(BUILD_DIR) $(ARGS)

	@cmake -E echo "x16emu and makecart executables can be found in ./$(BUILD_DIR)"

# Needs the Emscripten SDK (source emsdk_env.sh) and a rom.bin (X16_ROM=<path>, default ./rom.bin)
wasm:
	@command -v emcmake >/dev/null || { echo "emcmake not found, source emsdk_env.sh first"; exit 1; }
	emcmake cmake -S . -B $(WASM_BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DENABLE_FLUIDSYNTH=OFF -DENABLE_TRACE=OFF -DX16_ROM=$(abspath $(X16_ROM))
	cmake --build $(WASM_BUILD_DIR) $(ARGS)
	@cmake -E echo "wasm artifacts can be found in ./$(WASM_BUILD_DIR)/emu_binaries"

clean:
	-cmake --build $(BUILD_DIR) --target clean

distclean:
	cmake -E remove_directory $(BUILD_DIR) $(WASM_BUILD_DIR)
