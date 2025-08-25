# LPG
LPG is a framework for protecting location privacy at the protocol layer operating on an anonymous academic satellite. 

The LEO satellite used in our experiments are not for commercial use, only for acadamic research. However, it replicates the satellite structure for COTS computing devices to minimize the impact of unrelated factors. Due to the double-blindness and licensing restrictions, we do not disclose all parameters, protocols and agreement contents of the satellite. We only make those contents that have no impact on the safety of satellite operation publicly available, and they can prove the conclusions and procedures of LPG. 

This repository provides artifacts about LPG, and it also could help the community understand how to conduct experiments on acadamic satellites. Upon acceptance we will continue to improve the repository within ethical considerations. 


## Hardware Settings

Our in-orbit testbed consists of three main components:

**LEO Satellite:** A custom-built academic LEO satellite equipped with two commodity servers (8-core ARM processors, 16 GB DDR4 RAM, 256 GB storage) as payload.

**Ground Server:** A terrestrial server acting as the MNO, with an Intel Xeon Gold 6330 CPU and 256 GB of RAM.

**User Equipment (UE):** Two commodity phones, a Xiaomi 14 Ultra and a Google Pixel 9 Pro, used for end-to-end testing.


## On-Board Satellite Experiment Procedures

In [`On-Board-Satellite-Procedures`](https://github.com/LPGSatellite/LPG/tree/main/On-Board-Satellite-Procedures), we discussed the basic procedures of on-board experiments, covering ground instruction making, experiment process generation, result acquisition, experiment execution and other aspects. 

Due to the lack of interactive shell access (e.g., SSH) in orbit, all procedures are executed via pre-scripted remote commands. This section contains:

**tcgen.sh:** The command-line utility used to convert human-readable shell commands into the hexadecimal packet format required by the satellite's On-Board Computer (OBC).

**Reconstruction_Workflow.md:** A detailed guide on the on-orbit software installation and update process.

**Onboard.md:** The general workflow for preparing, executing, and retrieving results from on-orbit experiments.



## Telemetry

In [`Telemetry`](https://github.com/LPGSatellite/LPG/tree/main/telemetry), we provide the communication and measurement interface of the satellite payload. It contains:

**Telecommand_Protocol.md & Telemetry_Specification.md:** The formal specifications for the remote control and telemetry data packets, detailing every field and data type. These definitions correspond directly to the data collected in our evaluation.

**ReadPower.sh, ReadTemp.sh, etc.:** Shell scripts that interface with the onboard sensors to read real-time power and temperature data.

## Protocol Scripts

In [`protocol-scripts`](https://github.com/LPGSatellite/LPG/tree/main/protocol-scripts), we provide the core shell scripts that execute the experimental workloads for LPG and the baseline systems. 

[`./satellite/`](https://github.com/LPGSatellite/LPG/tree/main/protocol-scripts/satellite) contains the workload scripts that run on the satellite's ARM processor. This includes scripts for running the different components of LPG, LOCA, and other baseline protocols.(LOCA, PGPP, MOSAIC, SPACECORE)
[`./phone/`](https://github.com/LPGSatellite/LPG/tree/main/protocol-scripts/satellite) contains the client-side scripts that run on the UE phone. These scripts are used to drive the experiments, push necessary data, and benchmark performance

## Evaluation Data

In [`data`](https://github.com/LPGSatellite/LPG/tree/main/data)  we provide the dataset and plotting code used in the LPG section 5 Evaluation.

## References

[Anonymous tokens (AT)](https://github.com/google/anonymous-tokens)

[Scalable Collaborative ZK-snark](https://github.com/LBruyne/Scalable-Collaborative-zkSNARK)

[ZKLP](https://github.com/tumberger/zk-Location)

[ECIES](https://github.com/ecies)


