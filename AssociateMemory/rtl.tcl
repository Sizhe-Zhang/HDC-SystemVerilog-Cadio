vlib work
vlog -sv ../RTL/memory_module.sv
vlog -sv ../RTL/tb.sv

vsim -c tb -do "run -all"

