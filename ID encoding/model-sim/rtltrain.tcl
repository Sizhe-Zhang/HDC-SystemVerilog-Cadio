vlib work
vlog -sv ../RTL/hamming_distance_element.sv
vlog -sv ../RTL/hamming_distance_block.sv
vlog -sv ../RTL/random_index_block.sv
vlog -sv ../RTL/training_block.sv
vlog -sv ../RTL/hyperdimensional_module.sv
vlog -sv ../RTL/training.sv
vsim -c tb -do "run -all"