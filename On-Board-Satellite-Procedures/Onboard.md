# Procedures of on-board experiments 


## Ground Scripts

First, you need to use `tcgen.sh` to make the commands. After that, copy the output of `tcgen.sh` to a txt file. Each command must be saved in a `.txt` file with the following format:
`${ExperimentID}-${CommandID}-${Description}.txt`
The ExperimentID should correspond to the ID assigned to your experiment. CommandID and Description can be determined by the researcher to distinguish between different command files.

### Telecommand Generator

The `tcgen.sh` (Telecommand Generator) is a crucial command-line utility for preparing all on-orbit experiments. Due to the lack of direct interactive shell access (e.g., SSH) to the in-orbit payloads, all procedures must be executed via pre-formatted remote commands that are uplinked to the satellite's On-Board Computer (OBC).

This script serves as the bridge between human-readable shell commands (e.g., /path/to/script.sh) and the specific hexadecimal packet format required by the OBC. It automatically handles the conversion to hex, prepends the necessary control headers—including metadata like packet length and sequence numbers—and splits commands larger than the 92-byte payload limit into multiple, linkable parts.


### Generate Command

If you want to run `/experiment/04/start.sh` on the satellite server, then you can input `./tcgen.sh -i` . Then, you enter the interactive mode. Type `/experiment/04/start.sh` , then the script will output six commands. 

For example, one of the commands is 

EB900100000100000000000001000100002D000000000091000000001108000000030000EA627C65000101000000000017010000000000000000000000000000000000000000002F6578706572696D656E742F30342F73746172742E736800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000



## Collect Results

The collected experimental results are divided into two parts: (1) telemetry data, (2) logs.

We have a website where you can query all the telemetry data within a time period, and the link to this website will be opened upon acceptance.

The telemetry data that can be collected includes the following:

In addition, the telemetry data broadcast by OBC needs to be collected in another procedure. This command takes 1min to run and can be executed many times. To pack the OBC results, we need to run the `/home/user/scripts/pack.sh` script. 

The following table details the telemetry data points available for query. These metrics are used to generate the performance and overhead results in the LPG paper's evaluation section.


| Metric | Description |
| :--- | :--- |
| **CPU Core Temperature (°C)** | Temperature of the CPU core. |
| **CPU Core Voltage (mV)** | Voltage of the CPU.  |
| **CPU Operating Frequency (MHz)** | Average operating frequency across the four CPU cores. |
| **CPU Core 1 Load (%)** | The load on CPU core 1. |
| **CPU Core 2 Load (%)** | The load on CPU core 2. |
| **CPU Core 3 Load (%)** | The load on CPU core 3. |
| **CPU Core 4 Load (%)** | The load on CPU core 4. |
| **Remaining Memory Capacity (MiB)** | The amount of available RAM. |
| **Remaining Storage Capacity (MiB)** | The amount of available disk storage. |
| **CPU Voltage** | Voltage of the single-board computer's CPU.  |
| **CPU Current** | Current of the single-board computer's CPU. |
| **System Voltage** | Total voltage for the entire payload.  |
| **System Current** | Total current for the entire payload.  |
| **Board Temperature** | Temperature of the main board. |
| **GPU Power (W)** | GPU power consumption. |
| **GPU Temperature (°C)** | GPU temperature. |




