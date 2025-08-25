# Space Server - Telemetry Protocol Specification

This document specifies the data format for the telemetry packet, corresponding to the "Payload Telemetry Response" in Chapter 6 of the "Space Server - UDP Protocol" document. The total telemetry packet length is 100 bytes. Unspecified fields are reserved for future use.


| Category | Field Name | Length (Bytes) | Data Type | Description | Cumulative Length (Bytes) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Basic TC/TM** | Telemetry Packet Count | 1 | `unsigned char` | The number of telemetry packets received. | 1 |
| | Telecommand Count | 1 | `unsigned char` | The number of telecommands received. | 2 |
| | Telecommand Status | 1 | `unsigned char` | Execution status of the last command: `0`: Pending, `1`: Success, `2`: Failure, `3`: Duplicate ID. | 3 |
| | Telecommand Type | 1 | `unsigned char` | Type of the last command executed. The MSB distinguishes the source: `1` for serial, `0` for network. Examples: `101`: Script, `102`: Measurement. | 4 |
| **Clock** | Timestamp | 4 | `unsigned int` | The Raspberry Pi's internal clock timestamp in milliseconds (ms). This value plus the `Clock Error` equals the GPS timestamp. | 8 |
| | PPS Count | 2 | `unsigned short` | The number of PPS (Pulse Per Second) signals received. | 10 |
| | Clock Sync Count | 2 | `unsigned short` | The number of clock synchronization events that have occurred. | 12 |
| | Clock Error | 4 | `int` | The error between the GPS clock and the Raspberry Pi clock, in units of 100 nanoseconds (100ns). | 16 |
| **File Reconstruction** | Reconstruction Status | 1 | `unsigned short` | The status of the file reconstruction process. `0`: Idle, `1`: Reconstructing, `2`: Success, `3`: Failure (reverted), `4`: Install script failed, `5`: File not found or checksum error. Resets to `0` sixty seconds after completion. | 17 |
| | Reconstructed Software ID | 1 | `unsigned short` | The ID of the software being reconstructed. | 18 |
| | Reconstructed Software Version | 1 | `unsigned short` | The target version of the software being reconstructed. | 19 |
| | On-orbit Calculated HASH | 2 | `uint16` | The 16-bit hash value of the most recently received software package calculated on the satellite. | 21 |
| **Network Proxy** | Running Status | 1 | `unsigned char` | Indicates if the network proxy application is currently running. | 22 |
| | Log File Count | 1 | `unsigned char` | The number of log files generated. | 23 |
| | Total Log File Size | 1 | `unsigned char` | The total size of all files in the log output directory, in GiB. | 24 |
| | TC Success Count | 1 | `unsigned char` | The number of successful uplink telecommands executed by the proxy. | 25 |
| | TC Failure Count | 1 | `unsigned char` | The number of failed uplink telecommands executed by the proxy. | 26 |
| | Last Successful TC Type | 1 | `unsigned char` | The type of the last successfully executed telecommand (same encoding as `Telecommand Type`). | 27 |
| **System Status** | CPU Core Temperature | 1 | `int` | The temperature of the CPU core in degrees Celsius (°C). | 28 |
| | CPU Core Voltage | 2 | `unsigned int` | The voltage of the CPU core in millivolts (mV). | 30 |
| | CPU Operating Frequency | 2 | `unsigned int` | The operating frequency of the CPU in megahertz (MHz). | 32 |
| | CPU Core 1 Load | 1 | `unsigned int` | The load on CPU core 1 as a percentage (%). | 33 |
| | CPU Core 2 Load | 1 | `unsigned int` | The load on CPU core 2 as a percentage (%). | 34 |
| | CPU Core 3 Load | 1 | `unsigned int` | The load on CPU core 3 as a percentage (%). | 35 |
| | CPU Core 4 Load | 1 | `unsigned int` | The load on CPU core 4 as a percentage (%). | 36 |
| | Remaining Memory | 2 | `unsigned int` | The amount of available RAM in mebibytes (MiB). | 38 |
| | Remaining Storage | 2 | `unsigned int` | The amount of available disk storage in mebibytes (MiB). | 40 |
| | Network Heartbeat | 1 | `unsigned int` | A bitmap representing the status of pings sent every 10s. Big-endian format, with each bit representing a device (Space Server, Laser Baseband, OBC, X-band). `0`: Normal, `1`: Ping failed. | 41 |
| **Temperature Sensors** | Sensor 0x48 | 2 | `unsigned short` | Temperature reading from this sensor. The value is a 12-bit fixed-point number, transmitted in big-endian format. The MSB indicates the sign (positive/negative), and the lower 11 bits represent the magnitude. Each unit (LSB) is 0.0625°C. | 43 |
| | Sensor 0x49 - 0x4F | 14 | `unsigned short` | Same format as Sensor 0x48. | 45-57 |
| **Power Sensors** | CPU Voltage | 2 | `unsigned short` | The CPU voltage, transmitted in big-endian format. The MSB indicates sign, and the other 15 bits represent magnitude. Each unit (LSB) is 1.25mV. | 59 |
| | CPU Current | 2 | `unsigned short` | The CPU current, transmitted in big-endian format. The MSB indicates sign, and the other 15 bits represent magnitude. Each unit (LSB) is 200µA. | 61 |
| | Total Voltage | 2 | `unsigned short` | Same format as CPU Voltage. | 63 |
| | Total Current | 2 | `unsigned short` | Same format as CPU Current. | 65 |
| **GPU** | GPU Power | 1 | `uint8` | The GPU power consumption. | 66 |
| | GPU Temperature | 1 | `uint8` | The GPU temperature. | 67 |
| **Custom Telemetry** | Reserved Field | 21 | - | Reserved for future use. | - |
