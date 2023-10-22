module TRN_RMS(
    input wire clk,
    input wire reset,
    input wire [DATA_WIDTH-1:0] data_in,
	output wire rms_tlast,
    output wire [39:0] result
);

parameter DATA_WIDTH = 20;
parameter SAMPLE_COUNT = 128;
localparam SHIFT_AMOUNT = $clog2(SAMPLE_COUNT); // $clog2 ile SAMPLE_COUNT'ın log2 değeri alınır

reg signed [46:0] sum; // 2*20+log2(sample_count) 
reg [7:0] sample_counter; // log2(sample_count)
reg signed [DATA_WIDTH-1:0] square_input;
reg [39:0] result_reg;
reg [39:0] old_data;
reg rms_tlast_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sum <= 0;
        sample_counter <= 0;
        square_input <= 0;
        result_reg <= 0;
		rms_tlast_reg <= 0;
		old_data <= 0;
    end else begin
        square_input <= $signed(data_in);
		sum <= sum + square_input * square_input;
		sample_counter <= sample_counter + 1;

        if (sample_counter == SAMPLE_COUNT - 1) begin
            result_reg <= sum >> SHIFT_AMOUNT;
            sum <= 0;
            sample_counter <= 0;
			old_data <= result_reg;
			rms_tlast_reg <= 1;			
        end else begin
			result_reg <= old_data;
			rms_tlast_reg <= 0;
		end 
    end
end 
assign result = result_reg;
assign rms_tlast = rms_tlast_reg;

endmodule