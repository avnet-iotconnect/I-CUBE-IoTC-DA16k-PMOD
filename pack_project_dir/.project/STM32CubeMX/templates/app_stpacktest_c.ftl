[#ftl]
#include "da16k_comm.h"
#include "${FamilyName?lower_case}xx_hal.h"
#include "Avnet-IotConnect.stpacktest_conf.h"

da16k_iotc_cfg_t iotc_cfg = {
		iotc_mode,
		iotc_duid,
		iotc_env,
		"",
		iotc_device_cert,
		iotc_device_key
};

da16k_wifi_cfg_t iotc_wifi_cfg = {
		iotc_wifi_ssid,
		iotc_wifi_passphrase,
		iotc_wifi_encryption_type,
		iotc_wifi_hidden_network,
		iotc_wifi_connection_timeout
};

da16k_cfg_t cfg = {
		&iotc_cfg,
		&iotc_wifi_cfg,
		0
};

int MX_da16k_pmod_Init(void) {
	int err = 0;

	if(da16k_init(&cfg) != DA16K_SUCCESS)
		err=-1;

	return err;
}

int MX_da16k_pmod_Process(void) {
	da16k_cmd_t current_cmd = {0};
	float cpuTemp = 0.0;
	da16k_err_t err;
#define TELEMETRY_TICK_PERIOD (2000)
	static uint32_t telemetry_tick_expiry=0;

	if(telemetry_tick_expiry==0)
		telemetry_tick_expiry = HAL_GetTick()+TELEMETRY_TICK_PERIOD;

	err = da16k_get_cmd(&current_cmd);

	if (current_cmd.command) {
		//            iotc_demo_handle_command(&current_cmd);
		da16k_destroy_cmd(current_cmd);
	}

	if (err == DA16K_SUCCESS) {
		DA16K_PRINT("Command received: %s, parameters: %s\r\n", current_cmd.command, current_cmd.parameters ? current_cmd.parameters : "<none>" );
	}
	/* obtain sensor data */

	//cpuTemp = get_cpu_temperature();
	if(HAL_GetTick() > telemetry_tick_expiry){
		telemetry_tick_expiry=HAL_GetTick()+TELEMETRY_TICK_PERIOD;

		err = da16k_send_msg_direct_float("cpu_temperature", cpuTemp);
	}

	return 0;
}
