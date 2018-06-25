<a name="setup"></a>
# Setup mode
When a Crownstone is new or factory reset, it will go into setup mode.

Setup mode turns down the power of the antenna (low TX) so you can only communicate with it when you're close by. The purpose of this mode
is to configure the Crownstone so only you, or people in your group, can communicate with it.

The setup process goes as follows:

- Crownstone is in setup mode (low TX, [Setup Service active](#setup_service)).
- Phone is closeby and connects to the Crownstone.
- Phone reads the **session key** and **session nonce** from the [setup service](#setup_service). These characteristics are not encrypted.
The values are only valid for this connection session. The session key and the session nonce will be used to encrypt the rest of the setup phase using AES 128 CTR as explained [here](#encrypted_write_read).
- Phone subscribes to [control](#setup_service) characteristic.
- Phone commands Crownstone to setup via the control characteristic.
- Phone waits for control characteristic result to become SUCCESS (See [result packet](#command_result_packet)).
- Crownstone will reboot to normal mode.