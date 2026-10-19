## WebAssembly/HTML5 Support
The Commander X16 emulator supports a HTML/WebAssembly build target using the [Emscripten compiler](https://emscripten.org/).

## Demo
[HTML X16 Emulator Demo](https://sebastianvog.github.io/x16-emulator/x16emu.html)
## Installation
Follow installation steps from [here](https://emscripten.org/docs/getting_started/downloads.html#)

## Build

Activate the SDK (`source /path/to/emsdk/emsdk_env.sh`), then:

    make wasm                      # bundles ./rom.bin
    make wasm X16_ROM=/path/to/rom.bin

The system ROM (rom.bin) can be built from the [X16 ROM source](https://github.com/X16Community/x16-rom) or taken from its latest release. The ROM is bundled into `x16emu.data`; the build fails if it is not found.

Everything that can be uploaded to a web server is collected in `build-wasm/emu_binaries/`:

	x16emu.data x16emu.html x16emu.js x16emu.wasm webassembly/styles.css webassembly/main.js webassembly/jszip.min.js

### Testing
To run a test webserver:

    python3 -m http.server 8080 -d build-wasm/emu_binaries

And start [http://localhost:8080/x16emu.html](http://localhost:8080/x16emu.html)

Note: You will get the error `wasm streaming compile failed: TypeError: Failed to execute 'compile' on 'WebAssembly'...`
This is because SimpleHTTPServer does not serve .wasm files with the correct mime type. don't worry, everything will still work fine though.

### Supported Browsers
Working Browsers are Chrome, Safari, FireFox, Opera and Microsoft Edge (Beta)

### Known Issues
* Speed of the webassembly emulation is lacking, compared to the native version
* No support to load PRGs (yet)
* Doesn't display particularly well in portrait mode on mobile
