# Usage
1. Download the [pack](pack_project_dir/Avnet-IotConnect.I-CUBE-IoTC-DA16k-PMOD.1.0.0.pack) to your machine.
1. Open up [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html)
1. Create your CubeMX project if you haven't already.
1. In the CubeMX view click on “Manage Software Packs”
1. Click on "From Local ..."
1. Navigate to the pack & select it
1. Accept the license
1. Close the window
1. Now go to "Select Components"
1. Check the box beside "_Extension Board_/iotc_da16k_pmod / subgroup"
1. Select “single_thread” from the "_Device_ Application" pull-down menu.
1. Click "OK".
1. Set up an available serial port:
 - Parameter Settings:
   - Mode: Asynchronous
   - Baud: 115200
   - Word Length: 8 bits (including Parity)
   - Parity: None
   - Stop Bits: 1
 - NVIC Settings:
   - Global Interrupt enabled
 - DMA Settings:
   1. Click "Add".
   1. Select the "*_TX" option from the "DMA Request" column.
14. Now in the "Pinout & Configutation" tab of the CubeMX view, select "I-CUBE-IoTC-DA16k-PMOD" from "Middlewares & Software Packs" on the left hand side of the window.
1. Check both the "Extension Board iotc da16k pmod" & "Device Application" boxes.
1. This will make the "Platform Settings" tab available below, CubeMX will query the current setup & find the suitable serial ports that can be used with the pack. In "IPs or Components" select the type fo serial port you configured previously.
1. Now select the serial port previously configured from the "Found Solutions" pull-down menu.
1. "Ctrl + s" to save the settings & generate the code.

# Next Steps
Once the code has been generated the next steps are:
## Configuration/Provisioning.
There are parameters for duid, certificates & env etc in the CubeMX view, but currently these are not supported. So provisioning directly on the PMOD platform as per its quickstart guide is the only way to acheive this.
## Send Telemetry.
The user should be able to send telemetry by following the usual process of calling `da16_create/send_msg*`.
## React to C2D commands
By default the code will output received commands to a debug output. This can be redirected by provided a "strong" version of the `void da16k_cmd_handler(da16k_cmd_t * cmd)
` function.
