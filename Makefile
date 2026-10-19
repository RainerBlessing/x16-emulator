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
# Resolve cmake here: GNU make 4.3 fails with "cmake: Permission denied" when a PATH entry contains
# a directory called "cmake" ahead of the real binary (emsdk's upstream/emscripten/cmake).
CMAKE := $(shell command -v cmake)

.PHONY: all wasm clean distclean

all:
	@$(CMAKE) -E echo "Building with CMake"
	$(CMAKE) -E make_directory $(BUILD_DIR)
	$(CMAKE) -S . -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
	$(CMAKE) --build $(BUILD_DIR) $(ARGS)

	@$(CMAKE) -E echo "x16emu and makecart executables can be found in ./$(BUILD_DIR)"

# Needs the Emscripten SDK (source emsdk_env.sh) and a rom.bin (X16_ROM=<path>, default ./rom.bin)
wasm:
	@command -v emcmake >/dev/null || { echo "emcmake not found, source emsdk_env.sh first"; exit 1; }
	emcmake cmake -S . -B $(WASM_BUILD_DIR) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DENABLE_FLUIDSYNTH=OFF -DENABLE_TRACE=OFF -DX16_ROM=$(abspath $(X16_ROM))
	$(CMAKE) --build $(WASM_BUILD_DIR) $(ARGS)
	@$(CMAKE) -E echo "wasm artifacts can be found in ./$(WASM_BUILD_DIR)/emu_binaries"

clean:
	-$(CMAKE) --build $(BUILD_DIR) --target clean

distclean:
	$(CMAKE) -E remove_directory $(BUILD_DIR) $(WASM_BUILD_DIR)
