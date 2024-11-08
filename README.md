# Ibex Demo System

![Ibex demo system block diagram](doc/IbexDemoSystemBlockDiagram.png "Ibex demo system block diagram with in the center an Ibex processor connected by a memory bus to the RAM, GPIO, SPI, UART and debug module. Switches, buttons and LEDs are connected to the GPIO. The LCD is driven by SPI. The UART is used for a serial console. Finally, the debug module is used to drive the JTAG.")

This an example RISC-V SoC targeting the Arty-A7 FPGA board. It comprises the
[lowRISC Ibex core](https://www.github.com/lowrisc/ibex) along with the
following features:

* RISC-V debug support (using the [PULP RISC-V Debug Module](https://github.com/pulp-platform/riscv-dbg))
* UART
* GPIO
* PWM
* Timer
* SPI
* A basic peripheral to write ASCII output to a file and halt simulation from software

#### Install dependencies and activate our environment

```bash
git clone git@github.com:lowRISC/ibex-demo-system.git
cd ibex-demo-system


## Native Python Environment

```bash
# Setup python venv
python3 -m venv .venv
source .venv/bin/activate

# Install python requirements
pip3 install -r python-requirements.txt
```

You may need to run the last command twice if you get the following error:
`ERROR: Failed building wheel for fusesoc`


## Building Software

### C stack

First the software must be built.
This can be passed to a verilator simulation model to be simulated on a PC.

```
mkdir sw/c/build
pushd sw/c/build
cmake ..
make
popd
```
## Building Simulation

The Demo System simulator binary can be built via FuseSoC. From the Ibex
repository root run:

```sh
fusesoc --cores-root=. run --target=sim --tool=verilator --setup --build lowrisc:ibex:demo_system
```

## Running the Simulator

Having built the simulator and software, to simulate using Verilator we can use the following commands.
`<sw_elf_file>` should be a path to an ELF file  (or alternatively a vmem file)
built as described above. Use `./sw/c/build/demo/hello_world/demo` to run the `demo`
binary.

Run from the repository root run:
```sh
# For example :
./build/lowrisc_ibex_demo_system_0/sim-verilator/Vtop_verilator \
  --meminit=ram,./sw/c/build/demo/hello_world/demo

# You need to substitute the <sw_elf_file> for a binary we have build above.
./build/lowrisc_ibex_demo_system_0/sim-verilator/Vtop_verilator [-t] --meminit=ram,<sw_elf_file>
```

Pass `-t` to get an FST trace of execution that can be viewed with
[GTKWave](http://gtkwave.sourceforge.net/).

```
Simulation statistics
=====================
Executed cycles:  5899491
Wallclock time:   1.934 s
Simulation speed: 3.05041e+06 cycles/s (3050.41 kHz)

Performance Counters
====================
Cycles:                     457
NONE:                       0
Instructions Retired:       296
LSU Busy:                   108
Fetch Wait:                 20
Loads:                      53
Stores:                     55
Jumps:                      21
Conditional Branches:       12
Taken Conditional Branches: 7
Compressed Instructions:    164
Multiply Wait:              0
Divide Wait:                0
```
