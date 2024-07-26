[#ftl]
/* SPDX-License-Identifier: MIT
 * Copyright (C) 2024 Avnet
 * Authors: Witekio <ext.eng-h0025-iotconnect@witekio.com> et al.
 */
 
#include "app_${ModuleName}.h"
#include "${FamilyName?lower_case}xx_hal.h"
[#assign t = name]
[#assign u = t?replace(version,"___")]
[#assign v = u?replace(".___","_conf.h")]
#include "${v}"

/* 
 * Configuration variables below that utilize the parameters specified in the CubeMX view.
 */
 
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

da16k_cfg_t mx_iotc_cfg = {
        &iotc_cfg,
        &iotc_wifi_cfg,
        0
};

/* 
 * Function that fetches configuration info from somewhere during initialisation. Written as weak so it can be easily
 * replaced by a board specific version. By default it returns the configuration variables above.
 */
__weak da16k_cfg_t * da16k_get_config(void) {
    return &mx_iotc_cfg;
}

/* 
 * Function definition as per the CubeMX framework. Initialises the chosen serial port & any other data as required by
 * the AT library, e.g. configuration data.
 */
int MX_${ModuleName}_Init(void) {
    int err = 0;
    da16k_cfg_t * cfg_p = da16k_get_config();

    if(!cfg_p)
        return -1;

    if(da16k_init(cfg_p) != DA16K_SUCCESS)
        err=-2;

    return err;
}

/* 
 * Function that triggers as & when a command is received from the DA16k PMOD board. Written as weak so it can be easily
 * replaced by a board specific version. By default it prints the command strings to stout.
 */
__weak void da16k_cmd_handler(da16k_cmd_t * cmd) {
    DA16K_PRINT("Command received: %s, parameters: %s\r\n",
        cmd->command, cmd->parameters ? cmd->parameters : "<none>" );
}

/* 
 * Function definition as per the CubeMX framework. Called from within the super loop of single-threaded implementations
 * Its main job is to read communications from the DA16k PMOD board, detect any c2d commands & call a commands handler
 * function accordingly.
 */
int MX_${ModuleName}_Process(void) {
    da16k_cmd_t current_cmd = {0};
    da16k_err_t err;
    static uint32_t tick_expiry = 0;
    uint32_t tick_current = HAL_GetTick();

    if(tick_current < tick_expiry) {
        return 0;
    } else {
        tick_expiry += 2000;
    }

    err = da16k_get_cmd(&current_cmd);

    if (err == DA16K_SUCCESS && current_cmd.command) {
        da16k_cmd_handler(&current_cmd);
        da16k_destroy_cmd(current_cmd);
    }

    return 0;
}
