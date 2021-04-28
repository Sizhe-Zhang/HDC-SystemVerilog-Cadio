`timescale  1ns / 1ps
module tb(); 
parameter N = 10000;
parameter PRECISION = $clog2 (N);
parameter PRECISION_RI = 31;
parameter MAXLETTERS = 10;

parameter init_mem_st=0, otv_st=1, rtv_st=2, wait_st=3, wtv_st=4, ctv_st=5, counting=6, readDistance =7, dummy=8, dummy2=9, fin=10;

reg [4:0] state;

reg [4 : 0] inputLetter;
reg [8:0] c;
reg clk, rst, computeAngle, rst_RI;
wire [PRECISION-1 : 0] distance;

wire done;

integer	i, j, k, unknown, correct, numTests, waitingCycles;
integer	fileHandle, fileListHandle, fileHandleRI;

string langFileAddr;
string langLabels[MAXLETTERS] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

string textFileDir = "../../testing/";
string textFileAddr;
string textFileName;
reg [4: 0]actualLang;

reg [PRECISION-1 : 0] randomVal [N-1 : 0];
reg [4: 0] label;
reg [4: 0] position; 
reg f_signal;
reg tf_signal;
reg t_signal;
reg rst_tb = 0;
reg [4:0] position_num;
reg mem_rst;
reg mem_f_signal;

always @(posedge clk)
begin
	if (mem_f_signal) begin
		if (!rst_tb ) begin
			state <= otv_st; // set next state to memory initialization
			rst_tb = 1;
			
		end
		else
			case (state)

				otv_st:		//open a test file
					begin
						
						rst <= 0;
						//if there is still a test file to read
						if ($fscanf(fileListHandle, "%s\n", textFileName) == 1) begin
							textFileAddr = {textFileDir, textFileName};
							fileHandle = $fopen(textFileAddr, "r");
							state <= rtv_st; // read the content of test file
							position_num <= 0;
							rst <= 1;
							//$display ("finish opening " );
						end
						else 	// there is no test file so go to final state
							state <= fin;
					end
				
				rtv_st:		// read content of test file
					begin
						//$display ("rtv_st " );
						//$display ("reading " );
						if (tf_signal) begin
							c = $fgetc(fileHandle);
						
							//$display ("read " );
							if (c == 'h1ff && tf_signal ) begin
								//$display ("read " );
								t_signal <= 0;
								//$display ("end of test file %s is reached", textFileAddr);
								$fclose(fileHandle);
								state <= otv_st; // compute the text vector for classification
								numTests += 1;
							end
							else begin	// map the read char to the range of [1,27] for the item memory

								
								if (c == 32)  begin

									//$display ("reading " );
								end//ascii code space

								else if (c >= 48 && c <= 57) //ascii code lowercase letters
									begin
										//$display ("Reading");
										inputLetter <= c - 48;
										label <= actualLang;
										position <= position_num;
										position_num <= position_num +1;
										t_signal = 1;
										end

								else 
									unknown += 1;
								state <= rtv_st;	// read next char
							end
						end
					end

				fin: 
					begin
						$display ("numTests=%d ", numTests, $time);
						$finish;
					end
				
			endcase
	end
end



memory_module #() MM( 
	.inputLetter(inputLetter), 
	.position(position),
	.label(label), 
	.f_signal(f_signal),
	.tf_signal(tf_signal),
	.t_signal(t_signal),
	.clk(clk),
	.mem_rst(mem_rst),
	.mem_f_signal(mem_f_signal),
	.rst(rst));


initial begin
	clk = 0;
	rst = 0; 
	inputLetter = 0;
	position = 0;
	label= 0;
	f_signal = 0;
	mem_rst = 0;
	numTests = 0;
	fileListHandle = $fopen("../../testing/list.lst","r");	
	#100000000;
	$display ("Sims started");
	
	rst = 1; 
	
end

always #2.3 clk = !clk;

always @(*) begin
	case ({textFileName[0]})//-------
		"0" : actualLang = 0;
		"1" : actualLang = 1;
		"2" : actualLang = 2;
		"3" : actualLang = 3;
		"4" : actualLang = 4;
		"5" : actualLang = 5;		
		"6" : actualLang = 6;
		"7" : actualLang = 7;
		"8" : actualLang = 8;
		"9" : actualLang = 9;
	endcase
end



endmodule

