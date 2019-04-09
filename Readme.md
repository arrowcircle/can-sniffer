# ESP32 CAN sniffer

## Getting started

### Wiring

CAN Transceiver should be connected to the board. Without it board will not be able to send and receive messages even in test mode (loopback enabled). On some transceivers 120 Ohms termination resistor is needed even for loopback mode. Without termination resistore TEST_MODE may not work.

| CAN transceiver | ESP32 |
| :-------------: | :---: |
| 3V3 | 3V3 |
| GND | GND |
| CTX | 5 |
| CRX | 4 |

### Building the code

1. Install [Visual Studio Code](https://code.visualstudio.com/)
2. Install [PlatformIO](https://platformio.org/install/ide?install=vscode)
3. Open project via PlatformIO home tab
4. Open any file in the project, ex Readme.md
5. On the bottom colorful toolbar click "✓" symbol to build project

### Uploading to the board

1. Connect the board to the USB (If flashing does not work, connect USB while holding boot button).
2. Click on the "→" symbol to upload the code to the board.
3. If all is ok, serial monitor will show debug information of the board.

## CAN Bus

From the 11-bit IDs it looks like CAN2.0A standard is used.
Speed is `256kbit/s`
