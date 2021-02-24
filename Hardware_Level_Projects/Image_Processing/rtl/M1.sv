/*
Copyright by Henry Ko and Nicola Nicolici
Department of Electrical and Computer Engineering
McMaster University
Ontario, Canada
*/

`timescale 1ns/100ps
`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

// This is the top module
// It connects the UART, SRAM and VGA together.
// It gives access to the SRAM for UART and VGA
module M1 (
		/////// board clocks
		input  logic            Clock,
		input  logic            Resetn,
		
		input  logic   [15:0]   SRAM_read_data,
		
		/////// M1 specific
		output logic	[17:0]	M1_address,
		output logic	[15:0]	M1_write_data,
		output logic 				M1_we_n,
		
		input logic 				M1_start,
		output logic				M1_finish
);

M1_upsampling_state_type upsample_state;

// V
//-------------------------------------------------
logic [31:0] MULT2_IN_1, MULT2_IN_2, MULT2_OUT_2;
logic [63:0] MULT2_OUT_2_long;

assign MULT2_OUT_2_long = MULT2_IN_1 * MULT2_IN_2;
assign MULT2_OUT_2 = MULT2_OUT_2_long[31:0];

logic [7:0] RV0, RV1, RV2, RV3, RV4, RV5;
logic [15:0] Vprime;
logic [7:0] TEMP1_V, TEMP2_V, TEMP3_V;
logic [31:0] accumulatorV;
//-------------------------------------------------

// U
//-------------------------------------------------
logic [31:0] MULT1_IN_1, MULT1_IN_2, MULT1_OUT_1;
logic [63:0] MULT1_OUT_1_long;

assign MULT1_OUT_1_long = MULT1_IN_1 * MULT1_IN_2;
assign MULT1_OUT_1 = MULT1_OUT_1_long[31:0];

logic [7:0] RU0, RU1, RU2, RU3, RU4, RU5;
logic [15:0] Uprime;
logic [7:0] TEMP1_U, TEMP2_U;
logic [31:0] accumulatorU;
//-------------------------------------------------

// CSC
//-------------------------------------------------
logic [31:0] Reven, Geven, Beven, Rodd, Godd, Bodd;
logic [15:0] Y, U, V;
logic [7:0] R_even_final, G_even_final, B_even_final, R_odd_final, G_odd_final, B_odd_final;

logic [31:0] MULT3_IN_1, MULT3_IN_2, MULT3_OUT_3;
logic [63:0] MULT3_OUT_3_long;

assign MULT3_OUT_3_long = MULT3_IN_1 * MULT3_IN_2;
assign MULT3_OUT_3 = MULT3_OUT_3_long[31:0];

logic [31:0] MULT4_IN_1, MULT4_IN_2, MULT4_OUT_4;
logic [63:0] MULT4_OUT_4_long;

assign MULT4_OUT_4_long = MULT4_IN_1 * MULT4_IN_2;
assign MULT4_OUT_4 = MULT4_OUT_4_long[31:0];
//-------------------------------------------------

logic [17:0] data_counter, data_counterY, data_counterRGB, j;
logic [15:0] C1, C2, C3, Y_HOLDER, U_HOLDER, V_HOLDER;
logic [15:0] rowCounter;

logic readMoreUV;

always_comb begin

	if (Reven[31] == 1'b1) begin
		R_even_final = 8'h00;
	end else if (|Reven[30:24] == 1'b1) begin
			R_even_final = 8'hFF;
	end else begin
			R_even_final = Reven[23:16];
	end
	
	if (Geven[31] == 1'b1) begin
		G_even_final = 8'h00;
	end else if (|Geven[30:24] == 1'b1) begin
			G_even_final = 8'hFF;
	end else begin
			G_even_final = Geven[23:16];
	end
	
	if (Beven[31] == 1'b1) begin
		B_even_final = 8'h00;
	end else if (|Beven[30:24] == 1'b1) begin
			B_even_final = 8'hFF;
	end else begin
			B_even_final = Beven[23:16];
	end
	
	if (Rodd[31] == 1'b1) begin
		R_odd_final = 8'h00;
	end else if (|Rodd[30:24] == 1'b1) begin
			R_odd_final = 8'hFF;
	end else begin
			R_odd_final = Rodd[23:16];
	end
	
	if (Godd[31] == 1'b1) begin
		G_odd_final = 8'h00;
	end else if (|Godd[30:24] == 1'b1) begin
			G_odd_final = 8'hFF;
	end else begin
			G_odd_final = Godd[23:16];
	end
	
	if (Bodd[31] == 1'b1) begin
		B_odd_final = 8'h00;
	end else if (|Bodd[30:24] == 1'b1) begin
			B_odd_final = 8'hFF;
	end else begin
			B_odd_final = Bodd[23:16];
	end
	
end


always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		MULT1_IN_1 <= 32'd0;
		MULT1_IN_2 <= 32'd0;
		MULT2_IN_1 <= 32'd0;
		MULT2_IN_2 <= 32'd0;
		MULT3_IN_1 <= 32'd0;
		MULT3_IN_2 <= 32'd0;
		MULT4_IN_1 <= 32'd0;
		MULT4_IN_2 <= 32'd0;
		RU0 <= 8'd0;
		RU1 <= 8'd0;
		RU2 <= 8'd0;
		RU3 <= 8'd0;
		RU4 <= 8'd0;
		RU5 <= 8'd0;
		RV0 <= 8'd0;
		RV1 <= 8'd0;
		RV2 <= 8'd0;
		RV3 <= 8'd0;
		RV4 <= 8'd0;
		RV5 <= 8'd0;
		Uprime <= 16'd0;
		Vprime <= 16'd0;
		TEMP1_U <= 8'd0;
		TEMP2_U <= 8'd0;
		TEMP1_V <= 8'd0;
		TEMP2_V <= 8'd0;
		accumulatorU <= 32'd0;
		accumulatorV <= 32'd0;
		M1_we_n <= 1'd1;
		M1_address <= 18'd0;
		M1_finish <= 1'd0;
		readMoreUV <= 1'd0;
		j <= 1'd0;
		Y <= 16'd0;
		U <= 16'd0;
		V <= 16'd0;
		C1 <= 16'd0;
		C2 <= 16'd0;
		C3 <= 16'd0;
		data_counter <= 18'd0;
		data_counterY <= 18'd0;
		data_counterRGB <= 18'd0;
		upsample_state <= S_M1_IDLE;
		Reven <= 32'd0;
		Geven <= 32'd0;
		Beven <= 32'd0;
		Rodd <= 32'd0;
		Godd <= 32'd0;
		Bodd <= 32'd0;
		rowCounter <= 16'd0;
	end else begin
	
		case (upsample_state)
			
			S_M1_IDLE: begin
				if (M1_start) begin
					upsample_state <= S_M1_LEADIN_1;
				end
			end
			
			S_M1_LEADIN_1: begin
				//--------------------------------------
				M1_address <= U_SEGMENT_BASE + data_counter;
				M1_we_n <= 1'd1;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_2;
			end
			
			S_M1_LEADIN_2: begin
				//--------------------------------------
				M1_address <= U_SEGMENT_BASE + data_counter + 2'd1;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_3;
				
			end
			
			S_M1_LEADIN_3: begin
				//--------------------------------------
				M1_address <= U_SEGMENT_BASE + data_counter + 3'd2;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_4;
			end
			
			S_M1_LEADIN_4: begin
				//--------------------------------------
				M1_address <= V_SEGMENT_BASE + data_counter;
				RU5 <= SRAM_read_data[7:0];
				RU4 <= SRAM_read_data[15:8];
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_5;
			end
			
			S_M1_LEADIN_5: begin
				//--------------------------------------
				M1_address <= V_SEGMENT_BASE + data_counter + 2'd1;
				
				RU2 <= RU4;
				RU3 <= RU5;
				RU5 <= SRAM_read_data[7:0];
				RU4 <= SRAM_read_data[15:8];
				
				MULT1_IN_1 <= 8'd21;
				MULT1_IN_2 <= RU4;
				
				accumulatorU <= 8'd128;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_6;				
			end
			
			S_M1_LEADIN_6: begin
				//--------------------------------------
				M1_address <= V_SEGMENT_BASE + data_counter + 3'd2;
				data_counter <= data_counter + 2'd3;
				
				RU0 <= RU2;
				RU1 <= RU3;
				RU2 <= RU4;
				RU3 <= RU5;
				RU5 <= SRAM_read_data[7:0];
				RU4 <= SRAM_read_data[15:8];
				
				MULT1_IN_1 <= 8'd52;
				MULT1_IN_2 <= RU2;
				
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_7;
			end
			
			S_M1_LEADIN_7: begin
				//--------------------------------------
				MULT1_IN_1 <= 8'd159;
				MULT1_IN_2 <= RU0;
				
				accumulatorU <= accumulatorU - MULT1_OUT_1;
				//--------------------------------------
				RV5 <= SRAM_read_data[7:0];
				RV4 <= SRAM_read_data[15:8];
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_8;
			end
			
			S_M1_LEADIN_8: begin
				//--------------------------------------
				M1_address <= Y_SEGMENT_BASE + data_counterY;
				
				MULT1_IN_1 <= 8'd159;
				MULT1_IN_2 <= RU1;
				
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//--------------------------------------
				RV2 <= RV4;
				RV3 <= RV5;
				RV5 <= SRAM_read_data[7:0];
				RV4 <= SRAM_read_data[15:8];
				
				MULT2_IN_1 <= 8'd21;
				MULT2_IN_2 <= RV4;
				MULT3_IN_1 <= 8'd52;
				MULT3_IN_2 <= RV4;
				MULT4_IN_1 <= 8'd159;
				MULT4_IN_2 <= RV4;
				
				accumulatorV <= 8'd128;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_9;
			end
			
			S_M1_LEADIN_9: begin
				data_counterY <= data_counterY + 1'd1;
				//--------------------------------------
				MULT1_IN_1 <= 8'd52;
				MULT1_IN_2 <= RU2;
				
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//--------------------------------------
				RV0 <= RV2;
				RV1 <= RV3;
				RV2 <= RV4;
				RV3 <= RV5;
				RV5 <= SRAM_read_data[7:0];
				RV4 <= SRAM_read_data[15:8];
				
				MULT2_IN_1 <= 8'd159;
				MULT2_IN_2 <= RV3;
				MULT3_IN_1 <= 8'd52;
				MULT3_IN_2 <= RV4;
				MULT4_IN_1 <= 8'd21;
				MULT4_IN_2 <= RV5;
				//												21				52					159
				accumulatorV <= accumulatorV + MULT2_OUT_2 - MULT3_OUT_3 + MULT4_OUT_4;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_10;
			end
			
			S_M1_LEADIN_10: begin
				j <= j + 3'd3;
				//--------------------------------------
				MULT1_IN_1 <= 8'd21;
				MULT1_IN_2 <= RU3;
				
				accumulatorU <= accumulatorU - MULT1_OUT_1;
				//--------------------------------------
				//											159				52					21
				accumulatorV <= accumulatorV + MULT2_OUT_2 - MULT3_OUT_3 + MULT4_OUT_4;
				
				TEMP2_U <= RU5;
				TEMP3_V <= RV5;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_11;
			end
			
			S_M1_LEADIN_11: begin
				//--------------------------------------
				Y_HOLDER <= SRAM_read_data;
				
				MULT1_IN_1 <= 8'd21;
				MULT1_IN_2 <= RU0;
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//--------------------------------------
				TEMP2_V <= (accumulatorV >> 8);
				
				MULT2_IN_1 <= 8'd21;
				MULT2_IN_2 <= RV0;
				accumulatorV <= 8'd128;
				//--------------------------------------
				upsample_state <= S_M1_LEADIN_12;
			end
			
			S_M1_LEADIN_12: begin
				//--------------------------------------
				RU0 <= RU1;
				RU1 <= RU2;
				RU2 <= RU3;
				RU3 <= RU4;
				RU4 <= RU5;
				RU5 <= RU0;
				
				TEMP2_U <= RU5;
				
				MULT1_IN_1 <= 8'd52;
				MULT1_IN_2 <= RU0;
				accumulatorU <= 8'd128 + MULT1_OUT_1;
				
				TEMP1_U <= (accumulatorU >> 8);
				//--------------------------------------
				RV0 <= RV1;
				RV1 <= RV2;
				RV2 <= RV3;
				RV3 <= RV4;
				RV4 <= RV5;
				RV5 <= RV0;
				
				TEMP3_V <= RV5;
				
				MULT2_IN_1 <= 8'd52;
				MULT2_IN_2 <= RV0;
				accumulatorV <= accumulatorV + MULT2_OUT_2;
				//--------------------------------------
				upsample_state <= S_M1_1;
			end
			
			S_M1_1: begin
				M1_address <= Y_SEGMENT_BASE + data_counterY;
				M1_we_n <= 1'd1;
				//-----------------------------------------
				RU0 <= RU1;
				RU1 <= RU2;
				RU2 <= RU3;
				RU3 <= RU4;
				RU4 <= RU5;
				RU5 <= RU0;
				
				Uprime <= {RU5, TEMP1_U};
				
				MULT1_IN_1 <= 8'd159;
				MULT1_IN_2 <= RU0;
				
				accumulatorU <= accumulatorU - MULT1_OUT_1;
				//-----------------------------------------
				if (j >= 3'd5) begin
					MULT3_IN_1 <= a21;
					MULT3_IN_2 <= U[15:8] - 8'd128;
					Geven <= Geven + MULT3_OUT_3;
					
					MULT4_IN_1 <= a21;
					MULT4_IN_2 <= U[7:0] - 8'd128;
					Godd <= Godd + MULT4_OUT_4;
				end
				//-----------------------------------------
				RV0 <= RV1;
				RV1 <= RV2;
				RV2 <= RV3;
				RV3 <= RV4;
				RV4 <= RV5;
				RV5 <= RV0;
				
				MULT2_IN_1 <= 8'd159;
				MULT2_IN_2 <= RV0;
				accumulatorV <= accumulatorV - MULT2_OUT_2;
				//-----------------------------------------
				upsample_state <= S_M1_2;
			end
			
			S_M1_2: begin
				if (readMoreUV == 1'd0) begin
					M1_address <= V_SEGMENT_BASE + data_counter;
				end
				data_counterY <= data_counterY + 1'd1;
				//-------------------------------------
				RU0 <= RU1;
				RU1 <= RU2;
				RU2 <= RU3;
				RU3 <= RU4;
				RU4 <= RU5;
				RU5 <= RU0;
				
				MULT1_IN_1 <= 8'd159;
				MULT1_IN_2 <= RU0;
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//-------------------------------------
				Y <= Y_HOLDER;
				if (j >= 3'd5) begin
					Beven <= Beven + MULT3_OUT_3;
					
					Bodd <= Bodd + MULT4_OUT_4;
				end
				//-------------------------------------
				RV0 <= RV1;
				RV1 <= RV2;
				RV2 <= RV3;
				RV3 <= RV4;
				RV4 <= RV5;
				RV5 <= RV0;
				
				Vprime <= {RV4, TEMP2_V};
				
				MULT2_IN_1 <= 8'd159;
				MULT2_IN_2 <= RV0;
				accumulatorV <= accumulatorV + MULT2_OUT_2;
				//-------------------------------------
				upsample_state <= S_M1_3;
			end
			
			S_M1_3: begin
				if (readMoreUV == 1'd0) begin
					M1_address <= U_SEGMENT_BASE + data_counter;
				end
				//-------------------------------------
				RU0 <= RU1;
				RU1 <= RU2;
				RU2 <= RU3;
				RU3 <= RU4;
				RU4 <= RU5;
				RU5 <= RU0;
				
				MULT1_IN_1 <= 8'd52;
				MULT1_IN_2 <= RU0;
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//-------------------------------------
				U <= Uprime;
				V <= Vprime;
				
				MULT3_IN_1 <= a00;
				MULT3_IN_2 <= Y[15:8] - 8'd16;
				
				MULT4_IN_1 <= a00;
				MULT4_IN_2 <= Y[7:0] - 8'd16;
				
				Reven <= 32'd0;
				Geven <= 32'd0;
				Beven <= 32'd0;
				Rodd <= 32'd0;
				Godd <= 32'd0;
				Bodd <= 32'd0;
				
				if (j >= 3'd5) begin
					C1 <= {R_even_final,G_even_final};
					C2 <= {B_even_final,R_odd_final};
					C3 <= {G_odd_final,B_odd_final};
				end
				//-------------------------------------
				RV0 <= RV1;
				RV1 <= RV2;
				RV2 <= RV3;
				RV3 <= RV4;
				RV4 <= RV5;
				RV5 <= RV0;
				
				if (readMoreUV) begin
					TEMP1_V <= V_HOLDER[15:8];
					TEMP3_V <= V_HOLDER[7:0];
				end
				
				MULT2_IN_1 <= 8'd52;
				MULT2_IN_2 <= RV0;
				accumulatorV <= accumulatorV + MULT2_OUT_2;
				//-------------------------------------
				upsample_state <= S_M1_4;
			end
			
			S_M1_4: begin
				j <= j + 2'd2;
				readMoreUV <= ~readMoreUV;
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				if (readMoreUV && j < 16'd313) begin
					data_counter <= data_counter + 1'd1;
				end
				if (j >= 3'd5) begin
					M1_we_n <= 1'd0;
				end
				//-------------------------------------
				RU0 <= RU2;
				RU1 <= RU3;
				RU2 <= RU4;
				RU3 <= RU5;
				RU4 <= RU0;
				
				if (j >= 16'd313) begin
					RU5 <= RU0; //EDGE CASE LEAD OUT
				end else begin
					if (readMoreUV) begin
						TEMP2_U <= U_HOLDER[7:0];
						RU5 <= U_HOLDER[15:8];
					end else begin
						RU5 <= TEMP2_U;
					end
				end
				
				Y_HOLDER = SRAM_read_data;
			
				MULT1_IN_1 <= 8'd21;
				MULT1_IN_2 <= RU0;
				accumulatorU <= accumulatorU - MULT1_OUT_1;
				//-------------------------------------
				MULT3_IN_1 <= a02;
				MULT3_IN_2 <= V[15:8] - 8'd128;
				
				MULT4_IN_1 <= a02;
				MULT4_IN_2 <= V[7:0] - 8'd128;
				
				Reven <= Reven + MULT3_OUT_3;
				Geven <= Geven + MULT3_OUT_3;
				Beven <= Beven + MULT3_OUT_3;				
				Rodd <= Rodd + MULT4_OUT_4;
				Godd <= Godd + MULT4_OUT_4;
				Bodd <= Bodd + MULT4_OUT_4;
				
				if (j >= 3'd5) begin
					M1_write_data <= C1;
					data_counterRGB <= data_counterRGB + 1'd1;
				end
				//-------------------------------------
				RV0 <= RV2;
				RV1 <= RV3;
				RV2 <= RV4;
				RV3 <= RV5;
				RV4 <= RV0;
				
				if (j >= 16'd313) begin
					RV5 <= RV0; //EDGE CASE LEAD OUT
				end else begin
					if (readMoreUV) begin
						RV5 <= TEMP1_V;
					end else begin
						RV5 <= TEMP3_V;
					end
				end
				
				MULT2_IN_1 <= 8'd21;
				MULT2_IN_2 <= RV0;
				accumulatorV <= accumulatorV - MULT2_OUT_2;
				//-------------------------------------
				upsample_state <= S_M1_5;
			end
			
			S_M1_5: begin
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				if (j >= 4'd7) begin
					data_counterRGB <= data_counterRGB + 1'd1;
				end
				//-------------------------------------
				RU0 <= RU1;
				RU1 <= RU2;
				RU2 <= RU3;
				RU3 <= RU4;
				RU4 <= RU5;
				RU5 <= RU0;
				
				MULT1_IN_1 <= 8'd21;
				MULT1_IN_2 <= RU0;
				accumulatorU <= accumulatorU + MULT1_OUT_1;
				//-------------------------------------
				if (readMoreUV) begin
					V_HOLDER <= SRAM_read_data;
				end
				
				MULT3_IN_1 <= a11;
				MULT3_IN_2 <= U[15:8] - 8'd128;
				Reven <= Reven + MULT3_OUT_3;
				
				MULT4_IN_1 <= a11;
				MULT4_IN_2 <= U[7:0] - 8'd128;
				Rodd <= Rodd + MULT4_OUT_4;
				//-------------------------------------
				RV0 <= RV1;
				RV1 <= RV2;
				RV2 <= RV3;
				RV3 <= RV4;
				RV4 <= RV5;
				RV5 <= RV0;
				
				MULT2_IN_1 <= 8'd21;
				MULT2_IN_2 <= RV0;
				accumulatorV <= accumulatorV + MULT2_OUT_2;
				
				if (j >= 3'd5) begin
					M1_write_data <= C2;
				end
				//-------------------------------------
				upsample_state <= S_M1_6;
			end
			
			S_M1_6: begin
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				if (j >= 4'd7) begin
					data_counterRGB <= data_counterRGB + 1'd1;
				end
				//-----------------------------------------
				RU0 <= RU1;
				RU1 <= RU2;
				RU2 <= RU3;
				RU3 <= RU4;
				RU4 <= RU5;
				RU5 <= RU0;
				
				MULT1_IN_1 <= 8'd52;
				MULT1_IN_2 <= RU0;
				accumulatorU <= 8'd128 + MULT1_OUT_1;
				//-----------------------------------------
				if (readMoreUV) begin
					U_HOLDER <= SRAM_read_data;
				end
				
				TEMP1_U <= (accumulatorU >> 8);
				
				MULT3_IN_1 <= a12;
				MULT3_IN_2 <= V[15:8] - 8'd128;
				Geven <= Geven + MULT3_OUT_3;
				
				MULT4_IN_1 <= a12;
				MULT4_IN_2 <= V[7:0] - 8'd128;
				Godd <= Godd + MULT4_OUT_4;
				
				if (j >= 3'd5) begin
					M1_write_data <= C3;
				end
				//-----------------------------------------
				RV0 <= RV1;
				RV1 <= RV2;
				RV2 <= RV3;
				RV3 <= RV4;
				RV4 <= RV5;
				RV5 <= RV0;
				
				TEMP2_V <= (accumulatorV >> 8);
				
				MULT2_IN_1 <= 8'd52;
				MULT2_IN_2 <= RV0;
				accumulatorV <= 8'd128 + MULT2_OUT_2;
				//-----------------------------------------
				if (j == 18'd321) begin
					upsample_state <= S_M1_LEADOUT_1;
				end else begin
					upsample_state <= S_M1_1;
				end
			end
			
			S_M1_LEADOUT_1: begin
				Uprime <= {RU1, TEMP1_U};
				M1_we_n <= 1'd1;
				
				MULT3_IN_1 <= a21;
				MULT3_IN_2 <= U[15:8] - 8'd128;
				Geven <= Geven + MULT3_OUT_3;
				
				MULT4_IN_1 <= a21;
				MULT4_IN_2 <= U[7:0] - 8'd128;
				Godd <= Godd + MULT4_OUT_4;
				
				upsample_state <= S_M1_LEADOUT_2;
			end
			
			S_M1_LEADOUT_2: begin
				Vprime <= {RV1, TEMP2_V};
				Y <= Y_HOLDER;
				
				Beven <= Beven + MULT3_OUT_3;
				Bodd <= Bodd + MULT4_OUT_4;
				
				upsample_state <= S_M1_LEADOUT_3;
			end
			
			S_M1_LEADOUT_3: begin
				U <= Uprime;
				V <= Vprime;
				
				MULT3_IN_1 <= a00;
				MULT3_IN_2 <= Y[15:8] - 8'd16;
				
				MULT4_IN_1 <= a00;
				MULT4_IN_2 <= Y[7:0] - 8'd16;
				
				Reven <= 32'd0;
				Geven <= 32'd0;
				Beven <= 32'd0;
				Rodd <= 32'd0;
				Godd <= 32'd0;
				Bodd <= 32'd0;
				
				if (j >= 3'd5) begin
					C1 <= {R_even_final,G_even_final};
					C2 <= {B_even_final,R_odd_final};
					C3 <= {G_odd_final,B_odd_final};
				end
				
				upsample_state <= S_M1_LEADOUT_4;
			end
			
			S_M1_LEADOUT_4: begin
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				M1_we_n = 1'd0;
				
				MULT3_IN_1 <= a02;
				MULT3_IN_2 <= V[15:8] - 8'd128;
				
				MULT4_IN_1 <= a02;
				MULT4_IN_2 <= V[7:0] - 8'd128;
				
				Reven <= Reven + MULT3_OUT_3;
				Geven <= Geven + MULT3_OUT_3;
				Beven <= Beven + MULT3_OUT_3;				
				Rodd <= Rodd + MULT4_OUT_4;
				Godd <= Godd + MULT4_OUT_4;
				Bodd <= Bodd + MULT4_OUT_4;
				
				if (j >= 3'd5) begin
					M1_write_data <= C1;
					data_counterRGB <= data_counterRGB + 1'd1;
				end
				
				upsample_state <= S_M1_LEADOUT_5;
			end
			
			S_M1_LEADOUT_5: begin
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				if (j >= 4'd7) begin
					data_counterRGB <= data_counterRGB + 1'd1;
				end
				
				MULT3_IN_1 <= a11;
				MULT3_IN_2 <= U[15:8] - 8'd128;
				Reven <= Reven + MULT3_OUT_3;
				
				MULT4_IN_1 <= a11;
				MULT4_IN_2 <= U[7:0] - 8'd128;
				Rodd <= Rodd + MULT4_OUT_4;
				
				if (j >= 3'd5) begin
					M1_write_data <= C2;
				end
				
				upsample_state <= S_M1_LEADOUT_6;
			end
			
			S_M1_LEADOUT_6: begin
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				if (j >= 4'd7) begin
					data_counterRGB <= data_counterRGB + 1'd1;
				end
				
				MULT3_IN_1 <= a12;
				MULT3_IN_2 <= V[15:8] - 8'd128;
				Geven <= Geven + MULT3_OUT_3;
				
				MULT4_IN_1 <= a12;
				MULT4_IN_2 <= V[7:0] - 8'd128;
				Godd <= Godd + MULT4_OUT_4;
				
				if (j >= 3'd5) begin
					M1_write_data <= C3;
				end
				
				upsample_state <= S_M1_LEADOUT_7;
			end
			
			S_M1_LEADOUT_7: begin
				M1_we_n <= 1'd1;
			
				MULT3_IN_1 <= a21;
				MULT3_IN_2 <= U[15:8] - 8'd128;
				Geven <= Geven + MULT3_OUT_3;
				
				MULT4_IN_1 <= a21;
				MULT4_IN_2 <= U[7:0] - 8'd128;
				Godd <= Godd + MULT4_OUT_4;
				
				upsample_state <= S_M1_LEADOUT_8;
			end
			
			S_M1_LEADOUT_8: begin
				Beven <= Beven + MULT3_OUT_3;	
				Bodd <= Bodd + MULT4_OUT_4;
				
				upsample_state <= S_M1_LEADOUT_9;
			end
			
			S_M1_LEADOUT_9: begin
				M1_we_n <= 1'd0;
				
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				data_counterRGB <= data_counterRGB + 1'd1;
				M1_write_data <= {R_even_final,G_even_final}; //C1
			
				C2 <= {B_even_final,R_odd_final};
				C3 <= {G_odd_final,B_odd_final};
				
				upsample_state <= S_M1_LEADOUT_10;
			end
			
			S_M1_LEADOUT_10: begin	
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				data_counterRGB <= data_counterRGB + 1'd1;
				M1_write_data <= C2;
				
				upsample_state <= S_M1_LEADOUT_11;
			end
			
			S_M1_LEADOUT_11: begin
				M1_address <= RGB_SEGMENT_BASE + data_counterRGB;
				data_counterRGB <= data_counterRGB + 1'd1;
				M1_write_data <= C3;
				
				upsample_state <= S_M1_LEADOUT_12;
			end
			
			S_M1_LEADOUT_12: begin
				M1_we_n <= 1'd1;
				
				if (rowCounter == 16'd239) begin
					M1_finish <= 1'd1;
					upsample_state <= S_M1_IDLE;
				end else begin
					j <= 18'd0;
					readMoreUV <= 1'd0;
					rowCounter <= rowCounter + 1'd1;
					upsample_state <= S_M1_LEADIN_1;
				end
			end
			
			default: upsample_state <= S_M1_IDLE;
			
		endcase
		
		
	end
end



endmodule