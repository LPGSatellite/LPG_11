# Space Server - Telecommand Protocol

The telecommand packet begins with the following two fields:
*   **File Number (2B):** `60002` (0xEA62)
*   **Total Data Length (1B):** `124` (0x7C)

The 124-byte data segment of the telecommand is formatted as follows, consisting of a 32-byte control header and a 92-byte data payload for a single packet.

| Field Name | Length (Bytes) | Description |
| :--- | :--- | :--- |
| **TYPE** | 1 | **Telecommand Type:** Specifies the action to be performed. <br><ul><li>`100`: **Passthrough:** Forwards the `DATA` segment as-is to the specified `PORT`.</li><li>`101`: **Script Execution:** Executes a script at the path specified in the `DATA` segment (UTF-8 encoded).</li><li>`102`: **Measurement:** Measures the round-trip time of the ground-to-space link and forwards the result.</li><li>`103`: **Command Execution:** Executes a shell command specified in the `DATA` segment (UTF-8).</li><li>`104`: **File Upload:** Used for file transfer operations.</li><li>`105, 106`: **Script I/O **</li><li>`107`: **Kill Process:** Terminates a process corresponding to the ID in the `DATA` segment.</li><li>`108`: **Script I/O :** For interactive scripts. To enable streaming output, prefix the command with a special tag (e.g., `@tag -f log.file`).</li></ul>*Note: The Most Significant Bit (MSB) distinguishes the source: `1` for serial port, `0` for network port.* |
| **DIVIDE** | 1 | **Split Flag:** Indicates if the data is fragmented. <br><ul><li>`0`: **Not Split.** The `DATA` segment in this packet is complete.</li><li>`1`: **Split.** The `DATA` segment is a fragment and requires reassembly with other packets.</li></ul> |
| **SEQUENCE** | 1 | **Sequence Number:** The order of the packet in a fragmented sequence. <br><ul><li>If `DIVIDE` is `1`, this is a 1-based, auto-incrementing sequence number.</li><li>If `DIVIDE` is `0`, this value should be `1`.</li></ul> |
| **LENGTH** | 1 | **Total Fragments:** The total number of packets the data was split into. <br><ul><li>If `DIVIDE` is `1`, this value represents the total fragment count.</li><li>If `DIVIDE` is `0`, this value should be `1`.</li></ul> |
| **PORT** | 4 | **Destination Port:** The target port for passthrough data. Set to `0` if no forwarding is required. |
| **DATA_LENGTH** | 2 | **Valid Data Length:** The length of the valid data in the `DATA` segment, excluding padding. |
| **TEL_ID** | 1 | **Custom Telecommand ID:** A user-defined ID for the command. Range: 0-255. <br><ul><li>`0-243`: **General Command ID.** Valid only for the current proxy session; used for identifying commands within the session.</li><li>`244-254`: **Resumable Transfer ID.** Persistent across proxy sessions to support breakpoint resume functionality.</li><li>`255`: **Clear Resumable Transfer Cache.** The specific transfer ID to be cleared must be specified in the `DATA` field.</li></ul> |
| **RESERVED** | 21 | **Reserved:** Reserved for future use. Must be filled with `0x00`. |
| **DATA** | 92 | **Data Segment:** The payload of the command. The logical data (up to 124 bytes on the ground) is carried in this field. If the valid data for a given packet is less than 92 bytes, the remainder of this field must be padded with `0x00`. |
