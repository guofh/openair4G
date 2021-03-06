/*******************************************************************************
    OpenAirInterface
    Copyright(c) 1999 - 2014 Eurecom

    OpenAirInterface is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.


    OpenAirInterface is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with OpenAirInterface.The full GNU General Public License is
   included in this distribution in the file called "COPYING". If not,
   see <http://www.gnu.org/licenses/>.

  Contact Information
  OpenAirInterface Admin: openair_admin@eurecom.fr
  OpenAirInterface Tech : openair_tech@eurecom.fr
  OpenAirInterface Dev  : openair4g-devel@eurecom.fr

  Address      : Eurecom, Compus SophiaTech 450, route des chappes, 06451 Biot, France.

 *******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "ProtocolDiscriminator.h"
#include "EpsBearerIdentity.h"
#include "ProcedureTransactionIdentity.h"
#include "MessageType.h"

#ifndef ESM_INFORMATION_REQUEST_H_
#define ESM_INFORMATION_REQUEST_H_

/* Minimum length macro. Formed by minimum length of each mandatory field */
#define ESM_INFORMATION_REQUEST_MINIMUM_LENGTH (0)

/* Maximum length macro. Formed by maximum length of each field */
#define ESM_INFORMATION_REQUEST_MAXIMUM_LENGTH (0)

/*
 * Message name: ESM information request
 * Description: This message is sent by the network to the UE to request the UE to provide ESM information, i.e. protocol configuration options or APN or both. See table 8.3.13.1.
 * Significance: dual
 * Direction: network to UE
 */

typedef struct esm_information_request_msg_tag {
  /* Mandatory fields */
  ProtocolDiscriminator                protocoldiscriminator:4;
  EpsBearerIdentity                    epsbeareridentity:4;
  ProcedureTransactionIdentity         proceduretransactionidentity;
  MessageType                          messagetype;
} esm_information_request_msg;

int decode_esm_information_request(esm_information_request_msg *esminformationrequest, uint8_t *buffer, uint32_t len);

int encode_esm_information_request(esm_information_request_msg *esminformationrequest, uint8_t *buffer, uint32_t len);

#endif /* ! defined(ESM_INFORMATION_REQUEST_H_) */

