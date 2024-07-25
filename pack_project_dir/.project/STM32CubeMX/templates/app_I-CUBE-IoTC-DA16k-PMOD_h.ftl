/* SPDX-License-Identifier: MIT
 * Copyright (C) 2024 Avnet
 * Authors: Witekio <ext.eng-h0025-iotconnect@witekio.com> et al.
 */
 
#ifndef __APP_I_CUBE_IOTC_DA16K_PMOD_H
#define __APP_I_CUBE_IOTC_DA16K_PMOD_H

#ifdef __cplusplus
extern "C" {
#endif

#include "da16k_comm.h"

/* The MX_*_Init & MX_*_Process functions are automatically called by the CubeMX code generator. */
int MX_${ModuleName}_Init(void);
int MX_${ModuleName}_Process(void);

#ifdef __cplusplus
}
#endif

#endif /* __APP_I_CUBE_IOTC_DA16K_PMOD_H */