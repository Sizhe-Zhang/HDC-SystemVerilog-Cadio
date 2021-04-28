module hamming_distance_element(
	langVector,
    textVector,
    distance,
	index,
	enable,
	clk,
	rst
);
parameter N = 10000;
parameter PRECISION = $clog2 (N);
input [N-1 : 0] textVector;
input [N-1 : 0] langVector;
input [PRECISION-1 : 0] index;
output [PRECISION-1 : 0] distance;
input clk;
input rst;
input enable;
integer i;
reg [PRECISION-1 : 0] distance;
reg [N-1 : 0] temp;

reg [32 : 0 ] counter = 0;            

always @(posedge clk) begin
	if (!rst) 
		distance <= 0;
		
	else 
		if (enable)
			if ( counter == 10000)
				counter <= 0;
			
			else
				begin
					counter <= counter +1;
					temp <=  langVector * textVector;
					distance <= distance + temp;
				end
            // for (i = 0; i < N; i = i + 1)
            //     begin
            //         temp <=  langVector[i]*textVector[i];
            //         distance <= distance + temp;
            //     end  
	
		
end
endmodule