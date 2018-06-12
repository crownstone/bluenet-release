# Bluenet service data v2.1.0
-----------------------------

This only documents the latest service data protocol. The old versions are kept up in a separate [document](SERVICE_DATA_DEPRECATED.md).

# Index

- [Header](#service_data_header)
- [Device type and encrypted state](#servicedata_device_type)
- [Device type and setup state](#servicedata_device_type_setup)

<a name="service_data_header"></a>
# Service data header
This packet contains the state info. If encryption is enabled, the last 16 bytes will be encrypted using [AES 128 ECB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_Codebook_.28ECB.29) using the guest key.
You receive a MAC address on Android and an UUID on iOS for each advertisement packet. This allows you to get the Crownstone ID associated with the packet and you verify the decryption by checking the expected Crownstone ID against the one in the packet.

![Scan response service data](../docs/diagrams/scan-response-service-data.png)

The type determines how to parse the remaining bytes.

Type | Packet
--- | ---
5 | [Device type + data](#servicedata_device_type). Advertised when in normal mode.
6 | [Device type + data](#servicedata_device_type_setup). Advertised when in setup mode.



<a name="switch_state_packet"></a>
#### Switch state
To be able to distinguish between the relay and dimmer state, the switch state is a bit struct with the following layout:

![Switch State Packet](../docs/diagrams/switch_state_packet.png)

Bit 7 is used for the relay flag, where 0 = OFF, 1 = ON.
Bits 6-0 are used for PWM, where 100 is fully ON, 0 is OFF, dimmed in between.

<a name="flags_bitmask"></a>
#### Flags bitmask

Bit | Name |  Description
--- | --- | ---
0 | Dimming available | When dimming is physically available, this will be 1.
1 | Marked as dimmable | When dimming is configured to be allowed, this will be 1.
2 | Error |  If this is 1, the Crownstone has an error, you can check what error it is in the [error service data](#service_data_encrypted_error), or by reading the [error state](PROTOCOL.md#state_packet).
3 | Switch locked | When the switch state is locked, this will be 1.
4 | Time set | If this is 1, the time is set on this Crownstone.
5 | Switchcraft | If this is 1, switchcraft is enabled on this Crownstone.
6 | Reserved | Reserved for future use.
7 | Reserved | Reserved for future use.



<a name="servicedata_device_type"></a>
# Device type and encrypted service data
This packet contains the device type and the state info. If encryption is enabled, the state is encrypted using [AES 128 ECB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_Codebook_.28ECB.29) using the guest key.
You receive a MAC address on Android and an UUID on iOS for each advertisement packet. This allows you to get the Crownstone ID associated with the packet and you verify the decryption by checking the expected Crownstone ID against the one in the packet.

![Device typeEncrypted service data](../docs/diagrams/service-data-device-type-and-encrypted.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | Device type | 1 | Type of stone: plug, builtin, guidestone, etc.
uint 8 | Data type | 1 | Type of data, see below.
uint 8[] | Encrypted data | 16 | Encrypted data, see below.

The following data types are available:

Type | Packet
--- | ---
0 | [State](#service_data_encrypted_state_2).
1 | [Error](#service_data_encrypted_error_2).
2 | [External state](#service_data_encrypted_ext_state_2).
3 | [External error](#service_data_encrypted_ext_error_2).

<a name="service_data_encrypted_state_2"></a>
## State packet

The following type gives the latest state of the Crownstone.

![Encrypted service data state](../docs/diagrams/service-data-encrypted-state-2.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | Crownstone ID | 1 | ID that identifies this Crownstone.
uint 8 | [Switch state](#switch_state_packet) | 1 | The state of the switch.
uint 8 | [Flags bitmask](#flags_bitmask) | 1 | Bitflags to indicate a certain state of the Crownstone.
int 8 | Temperature | 1 | Chip temperature (°C).
int 8 | Power factor | 1 | The power factor at this moment. Divide by 127 to get the actual power factor.
int 16 | Power usage | 2 | The real power usage at this moment. Divide by 8 to get power usage in Watt. Divide real power usage by the power factor to get apparent power usage in VA.
int 32 | Energy used | 4 | The total energy used. Multiply by 64 to get the energy used in Joule.
uint 16 | Partial timestamp | 2 | The least significant bytes of the timestamp when this was the state of the Crownstone. If the time was not set on the Crownstone (can be seen in flags), this will be replaced by a counter.
uint 8 | Reserved | 1 | Reserved for future use.
uint 8 | Validation | 1 | Value is always `0xFA`. Can be used to help validating that the decryption was successful.

<a name="service_data_encrypted_error_2"></a>
## Error packet

The following type only gets advertised in case there is an error. It will be interleaved with the state type.

![Encrypted service data error](../docs/diagrams/service-data-encrypted-error-2.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | Crownstone ID | 1 | The identifier of the crownstone which has this state.
uint 32 | [Error bitmask](#state_error_bitmask) | 4 | Error bitmask of the Crownstone.
uint 32 | Timestamp | 4 | The timestamp when the first error occured.
uint 8 | [Flags bitmask](#flags_bitmask) | 1 | Bitflags to indicate a certain state of the Crownstone.
int 8 | Temperature | 1 | Chip temperature (°C).
uint 16 | Partial timestamp | 2 | The least significant bytes of the timestamp when this were the flags and temperature of the Crownstone. If the time was not set on the Crownstone (can be seen in flags), this will be replaced by a counter.
int 16 | Power usage | 2 | The real power usage at this moment. Divide by 8 to get power usage in Watt. Divide real power usage by the power factor to get apparent power usage in VA.

<a name="service_data_encrypted_ext_state_2"></a>
## External state packet

The following type sends out the last known state of another Crownstone. It will be interleaved with the state type (unless there's an error).

![Encrypted service data external state](../docs/diagrams/service-data-encrypted-ext-state-2.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | External Crownstone ID | 1 | The identifier of the crownstone which has the following state.
uint 8 | [Switch state](#switch_state_packet) | 1 | The state of the switch.
uint 8 | [Flags bitmask](#flags_bitmask) | 1 | Bitflags to indicate a certain state of the Crownstone.
int 8 | Temperature | 1 | Chip temperature (°C).
int 8 | Power factor | 1 | The power factor at this moment. Divide by 127 to get the actual power factor.
int 16 | Power usage | 2 | The real power usage at this moment. Divide by 8 to get power usage in Watt. Divide real power usage by the power factor to get apparent power usage in VA.
int 32 | Energy used | 4 | The total energy used. Multiply by 64 to get the energy used in Joule.
uint 16 | Partial timestamp | 2 | The least significant bytes of the timestamp when this was the state of the Crownstone. If the time was not set on the Crownstone (can be seen in flags), this will be replaced by a counter.
int 8 | RSSI | 1 | RSSI to the external crownstone.
uint 8 | Validation | 1 | Value is always `0xFA`. Can be used to help validating that the decryption was successful.

<a name="service_data_encrypted_ext_error_2"></a>
## External error packet

The following type sends out the last known error of another Crownstone. It will be interleaved with the state type (unless there's an error).

![Encrypted service data external error](../docs/diagrams/service-data-encrypted-ext-error-2.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | External Crownstone ID | 1 | The identifier of the crownstone which has the following state.
uint 32 | [Error bitmask](#state_error_bitmask) | 4 | Error bitmask of the Crownstone.
uint 32 | Timestamp | 4 | The timestamp when the first error occured.
uint 8 | [Flags bitmask](#flags_bitmask) | 1 | Bitflags to indicate a certain state of the Crownstone.
int 8 | Temperature | 1 | Chip temperature (°C).
uint 16 | Partial timestamp | 2 | The least significant bytes of the timestamp when this were the flags and temperature of the Crownstone. If the time was not set on the Crownstone (can be seen in flags), this will be replaced by a counter.
int 8 | RSSI | 1 | RSSI to the external crownstone.
uint 8 | Validation | 1 | Value is always `0xFA`. Can be used to help validating that the decryption was successful.




<a name="servicedata_device_type_setup"></a>
# Device type and setup service data
This packet contains the state info, it is unencrypted.

![Setup service data](../docs/diagrams/service-data-setup-2.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | Device type | 1 | Type of stone: plug, builtin, guidestone, etc.
uint 8 | Data type | 1 | Type of data, see below.
uint 8[] | Data | 16 | Data, see below.

Type | Packet
--- | ---
0 | [State](#service_data_encrypted_state_2).

<a name="service_data_setup_state_2"></a>
## Setup state packet

![Setup service data state](../docs/diagrams/service-data-device-type-and-setup.png)

Type | Name | Length | Description
--- | --- | --- | ---
uint 8 | [Switch state](#switch_state_packet) | 1 | The state of the switch.
uint 8 | [Flags bitmask](#flags_bitmask) | 1 | Bitflags to indicate a certain state of the Crownstone.
int 8 | Temperature | 1 | Chip temperature (°C).
int 8 | Power factor | 1 | The power factor at this moment. Divide by 127 to get the actual power factor.
int 16 | Power usage | 2 | The real power usage at this moment. Divide by 8 to get power usage in Watt. Divide real power usage by the power factor to get apparent power usage in VA.
uint 32 | [Error bitmask](#state_error_bitmask) | 4 | Error bitmask of the Crownstone.
uint 8 | Counter | 1 | Simply counts up and overflows.
uint 8 | Reserved | 4 | Reserved for future use.