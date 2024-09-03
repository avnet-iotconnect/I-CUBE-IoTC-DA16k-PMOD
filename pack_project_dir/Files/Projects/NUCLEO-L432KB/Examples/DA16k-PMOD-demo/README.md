# Intro
This example project demostrates how to integrate the I-CUBE-IoTC-DA16k-PMOD add-on pack to a NUCLEO-L432KB using the CubeMX enviroment.

When running the project will:
* configure a DA16k-PMOD dongle with the specific device connection data
* connect to IoTC
* Toggle LED LD2 whenever a specific command is received.
* Send dummy telemetry whenever a button is pressed.

# Hardware setup.
| NUCLEO-L432KB  | DA16K-PMOD |
|:-------------:|:-------------:|
| GND | Pin 5 or 11 |
| 3v3 | Pin 6 or 12 |
| D1/TX | Pin2 |
| D0/RX | Pin3 |
| D3 | A "push to close" button. <br> _When closed button should connect to GND._ |

# DA16k PMOD Firmware.
To ensure compatability with this I-CUBE pack, matching DA16k-PMOD firmware has been included within it.

The image files can be found in the STM32Cube Repository e.g.

```
~/STM32Cube/Repository/Packs/Avnet-IotConnect/I-CUBE-IoTC-DA16k-PMOD/1.0.0/iotc-dialog-da16k-sdk/images/
```

Follow the instructions in the [Quickstart guide](https://github.com/avnet-iotconnect/iotc-dialog-da16k-sdk/blob/main/doc/QUICKSTART.md) to flash the DA16k PMOD, just using the FW bundled with the I-CUBE pack instead of what is hosted on Github.

# Device Certificates & Keys

THe I-CUBE package doesn't send sensitive data like certificates & keys via the PMOD channel. Whilst it's possible to do this via AT commands, here it's recommended that the direct serial connection be treated as a trusted zone. Hence the device certificate & key from the IoTC device creation procedure can be uploaded to the PMOD using the following steps:
1. From the top of the PMOD console enter `net` to enter the networking menu
2. enter `cert write cert1`
3. paste in the certificate
4. stop the process with `Ctrl+c`
5. check if the process executed successfully, if not retry from step 2.
6. enter `cert write key1`
7. paste in the key
8. stop the process with `Ctrl+c`
8. check if the process executed successfully, if not retry from step 6.

# ST Link Debug Console.
The NUCLEO-L432KB's on board ST-Link should provide a virtual COM port. Connecting to this port with the following settings should display debug messages.

* Mode: Asynchronous
* Baud: 115200
* Word Length: 8 bits (including Parity)
* Parity: None
* Stop Bits: 1

# How to use
1. Import the project into your workspace via File->Import...->Existing projects into workspace.
2. Double click on DA16k-PMOD-demo-n32l43.ioc to open the CubeMX perspective.
3. Navigate to "Middleware and Software Packs->I-CUBE-IoTC-DA16k-PMOD->Parameter Settings"
4. Enter in the IoTC device specific details
5. Enter in the wifi connection details
6. Save & close the file to generate the code.
7. Build & run the code.
8. One the device displays as "connected" on the IoTC dashboard, sending the "test" command should toggle LD2 & display debug messages.
9. Pressing the button on D3 should send sample telemetry & display debug messages.
