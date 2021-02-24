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
module M2 (
		/////// board clocks
		input  logic            Clock,
		input  logic            Resetn,
		
		input  logic   [15:0]   SRAM_read_data,
		
		/////// M1 specific
		output logic	[17:0]	M2_address,
		output logic	[15:0]	M2_write_data,
		output logic 				M2_we_n,
		
		input logic 				M2_start,
		output logic				M2_finish
);


logic [7:0] address_a[2:0];
logic [7:0] address_b[2:0];
logic [31:0] write_data_a [2:0];
logic [31:0] write_data_b [2:0];
logic write_enable_a [2:0];
logic write_enable_b [2:0];
logic [31:0] read_data_a [2:0];
logic [31:0] read_data_b [2:0];
logic [7:0] overall_counter;
logic [7:0] accumulator1_final, accumulator2_final, accumulator3_final, accumulator4_final;

// RAM0
dual_port_RAM0 RAM_inst0 (
	.address_a ( address_a[0] ),
	.address_b ( address_b[0] ),
	.clock ( Clock ),
	.data_a ( write_data_a[0] ),
	.data_b ( write_data_b[0] ),
	.wren_a ( write_enable_a[0] ),
	.wren_b ( write_enable_b[0] ),
	.q_a ( read_data_a[0] ),
	.q_b ( read_data_b[0] )
	);

// RAM1
dual_port_RAM1 RAM_inst1 (
	.address_a ( address_a[1] ),
	.address_b ( address_b[1] ),
	.clock ( Clock ),
	.data_a ( write_data_a[1] ),
	.data_b ( write_data_b[1] ),
	.wren_a ( write_enable_a[1] ),
	.wren_b ( write_enable_b[1] ),
	.q_a ( read_data_a[1] ),
	.q_b ( read_data_b[1] )
	);


// RAM3
dual_port_RAM2 RAM_inst2 (
	.address_a ( address_a[2] ),
	.address_b ( address_b[2] ),
	.clock ( Clock ),
	.data_a ( write_data_a[2] ),
	.data_b ( write_data_b[2] ),
	.wren_a ( write_enable_a[2] ),
	.wren_b ( write_enable_b[2] ),
	.q_a ( read_data_a[2] ),
	.q_b ( read_data_b[2] )
	);

M2_state m2_state;
Fs_prime_states fs_prime_states;
CT_state ct_state;
CS_state_type CS_state;
WS_state_type WS_state;

/*Fs*/
logic Fs_prime_start, Fs_prime_finish;
logic [31:0] Fsprime_TEMP;
logic [7:0] Fsprime_i, RAM_Address_counter, Fs_counter;
/*-----------------------------------------------*/

/*Ct*/
logic [7:0] C_row, C_column, Sprime_row, Sprime_column;
logic [31:0] MAC_1, MAC_2, MAC_3, MAC_4, TEMP, TEMP1;
logic [7:0] M2_Ram1_offset;

logic CT_start, CT_finish, four_flag;
/*-----------------------------------------------*/

/*Cs*/
logic [2:0] i, j, ej, sT_j, i_base;
logic [4:0] i_cs_w, j_cs_w;
logic flag, half, kill, A, L,make, do_half, do_kill;
integer ic, jc, jc_base, ic_base;
logic [31:0] TEMP_A, TEMP_B, accumulator1, accumulator2, accumulator3, accumulator4;
logic [2:0]counter;
logic [15:0] counterbig;
logic [32:0] CS_TEMP1,CS_TEMP2,CS_TEMP3,CS_TEMP4;

logic CS_start, CS_finish;

/*-----------------------------------------------*/

/*Ws*/
logic [17:0] write_counter;
logic [15:0] TEMP1_WS,TEMP2_WS,TEMP3_WS,TEMP4_WS, Y_base, U_base, V_base;
logic [3:0] jw,iw, jw_larger;
logic [1:0] location;
logic stopws, stopcs, flagw;

logic WS_start, WS_finish;
/*-----------------------------------------------*/


// 1
//-------------------------------------------------
logic signed [31:0] MULT1_IN_1, MULT1_IN_2, MULT1_OUT_1;
logic [63:0] MULT1_OUT_1_long;

assign MULT1_OUT_1_long = MULT1_IN_1 * MULT1_IN_2;
assign MULT1_OUT_1 = MULT1_OUT_1_long[31:0];

//-------------------------------------------------

// 2
//-------------------------------------------------
logic [31:0] MULT2_IN_1, MULT2_IN_2, MULT2_OUT_2;
logic [63:0] MULT2_OUT_2_long;

assign MULT2_OUT_2_long = MULT2_IN_1 * MULT2_IN_2;
assign MULT2_OUT_2 = MULT2_OUT_2_long[31:0];

//-------------------------------------------------

// 3-----------------------------------------

logic [31:0] MULT3_IN_1, MULT3_IN_2, MULT3_OUT_3;
logic [63:0] MULT3_OUT_3_long;

assign MULT3_OUT_3_long = MULT3_IN_1 * MULT3_IN_2;
assign MULT3_OUT_3 = MULT3_OUT_3_long[31:0];

logic [31:0] MULT4_IN_1, MULT4_IN_2, MULT4_OUT_4;
logic [63:0] MULT4_OUT_4_long;

assign MULT4_OUT_4_long = MULT4_IN_1 * MULT4_IN_2;
assign MULT4_OUT_4 = MULT4_OUT_4_long[31:0];
//-------------------------------------------------


always_comb begin // this always comb block performs the clipping operation for the Compute S section

	if (accumulator1[31] == 1'b1) begin
		accumulator1_final = 8'h00;
	end else if (|accumulator1[30:24] == 1'b1) begin
		accumulator1_final = 8'hFF;
	end else begin
		accumulator1_final = accumulator1[23:16];
	end
	
	if (accumulator2[31] == 1'b1) begin
		accumulator2_final = 8'h00;
	end else if (|accumulator2[30:24] == 1'b1) begin
		accumulator2_final = 8'hFF;
	 end else begin
		accumulator2_final = accumulator2[23:16];
	end
	
	if (accumulator3[31] == 1'b1) begin
		accumulator3_final = 8'h00;
	end else if (|accumulator3[30:24] == 1'b1) begin
		accumulator3_final = 8'hFF;
	end else begin
		accumulator3_final = accumulator3[23:16];
	end
	
	if (accumulator4[31] == 1'b1) begin
		accumulator4_final = 8'h00;
	end else if (|accumulator4[30:24] == 1'b1) begin
		accumulator4_final = 8'hFF;
	 end else begin
		accumulator4_final = accumulator4[23:16];
	end

end


/* M2 CONTROL FSM */
always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin
		m2_state <= S_M2_IDLE;
		Fs_prime_start <= 1'd0;
		CT_start <= 1'd0;
		CS_start <= 1'd0;
		WS_start <= 1'd0;
		overall_counter <= 8'd0;
	end else begin
	
		case(m2_state)
		
		S_M2_IDLE: begin
			if (M2_start) begin
				m2_state <= S_M2_LEADIN_1;
			end
		end
		
		S_M2_LEADIN_1: begin
			/*Fs prime*/
			if (~Fs_prime_finish) begin
				Fs_prime_start <= 1'd1;
			end else begin
				Fs_prime_start <= 1'd0;
				m2_state <= S_M2_LEADIN_2;
			end
		end
		
		S_M2_LEADIN_2: begin
			/*Ct*/
			if (~CT_finish) begin
				CT_start <= 1'd1;
			end else begin
				CT_start <= 1'd0;
				m2_state <= S_M2_1;
			end
		end
		
		S_M2_1: begin
			/*Cs*/
			if (~CS_finish) begin
				CS_start <= 1'd1;
			end else begin
				CS_start <= 1'd0;
			end
			
			/*Fs prime*/
			if (~Fs_prime_finish) begin
				Fs_prime_start <= 1'd1;
			end else begin
				Fs_prime_start <= 1'd0;
			end
			
			if (Fs_prime_finish && CS_finish) begin
				m2_state <= S_M2_2;
				overall_counter <= overall_counter + 8'd1;
			end
		end
		
		S_M2_2: begin
			/*Ws*/
			if (~WS_finish) begin
				WS_start <= 1'd1;
			end else begin
				WS_start <= 1'd0;
			end
			
			/*Ct*/
			if (~CT_finish) begin
				CT_start <= 1'd1;
			end else begin
				CT_start <= 1'd0;
			end
			
			if (WS_finish && CT_finish && overall_counter == 8'd62) begin
				m2_state <= S_M2_LEADOUT_1;
			end
		end
		
		S_M2_LEADOUT_1: begin
			/*Cs*/
			if (~CS_finish) begin
				CS_start <= 1'd1;
			end else begin
				CS_start <= 1'd0;
				m2_state <= S_M2_LEADOUT_2;
			end
		end
		
		S_M2_LEADOUT_2: begin
			/*Ws*/
			if (~WS_finish) begin
				WS_start <= 1'd1;
			end else begin
				WS_start <= 1'd0;
				m2_state <= S_M2_IDLE;
				M2_finish <= 1'd1;
			end
		end
		
		endcase
		
	end
end
/*-----------------------------------------------*/


always @(posedge Clock or negedge Resetn) begin
	if (~Resetn) begin // all the required registers are given parameters
		fs_prime_states <= FS_IDLE;
		Fs_counter <= 8'd0;
		Fsprime_i <= 8'd0;
		M2_we_n <= 1'd1;
		Fs_prime_finish <= 1'd0;
		address_a[0] <= 32'd0;
		RAM_Address_counter <= 8'd0;
		write_data_a[0] <= 32'd0;
		write_enable_a[0] <= 1'd0;
		Fsprime_TEMP <= 32'd0;
		CS_finish <= 1'd0;
		WS_finish <= 1'd0;
		
		write_counter <= 18'd0;
		location <= 2'd0;
		Y_base <= 16'd0;
		U_base <= 16'd38400;
		U_base <= 16'd57600;
		flagw <= 1'b1;
		jw_larger <= 3'd0;
		write_enable_a[2] <= 1'b0;
		write_enable_a[2] <= 1'b0;
		iw <= 0;
		jw <= 0;
		counterbig <=0;
		WS_state <= S_WS_IDLE;
		TEMP_A <= 32'd0;
		TEMP_B <= 32'd0;
		ic <= 0;
		jc <= 0;
		j<=0;
		half <= 1'b0;
		i<=0;
		jc_base <= 0;
		ic_base <= 0;
		i_base <= 0;
		flag <= 1'b0;
		sT_j <= 0;
		counter <= 3'd0;
		counterbig <= 3'd0;
		kill <= 1'b0;
		A <= 0;
		L<=1;
		accumulator1 <= 32'd0;
		accumulator2 <= 32'd0;
		accumulator3 <= 32'd0;
		accumulator4 <= 32'd0;
		i_cs_w <= 0;
		j_cs_w <= 0;
		do_half <= 1'b0;
		do_kill <= 1'b0;
		CS_state <= S_CS_IDLE;
		make <= 1'b0;
		ct_state <= CT_IDLE;
		C_row <= 8'd0;
		C_column <= 8'd0;
		Sprime_row <= 8'd0;
		Sprime_column <= 8'd0;
		MAC_1 <= 32'd0;
		MAC_2 <= 32'd0;
		MAC_3 <= 32'd0;
		MAC_4 <= 32'd0;
		M2_Ram1_offset <= 8'd0;
		write_enable_a[1] <= 1'd0;
		address_a[1] <= 1'd0;
		address_b[1] <= 1'd0;
		address_b[0] <= 1'd0;
		four_flag <= 1'd0;
		CT_finish <= 1'd0;
		i <= 1'd0;
		M2_address <= 18'd0;
		M2_write_data <= 16'd0;
	end else begin
		
		/*Fs'*/
		case (fs_prime_states)
			FS_IDLE: begin
				if (Fs_prime_start && ~Fs_prime_finish) begin
					fs_prime_states <= FS_LEADIN_1;
				end
			end
			// Lead in start
			FS_LEADIN_1: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i; // these lines traverse the pre-IDCT section...
				Fsprime_i <= Fsprime_i + 1'd1; //... to put the correct values in the from the SRAM into RAM 1
				Fs_counter <= Fs_counter + 1'd1;
				M2_we_n <= 1'd1;
				
				fs_prime_states <= FS_LEADIN_2;
			end
			
			FS_LEADIN_2: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_i <= Fsprime_i + 1'd1;
				Fs_counter <= Fs_counter + 1'd1;
				
				fs_prime_states <= FS_LEADIN_3;
			end
			
			FS_LEADIN_3: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_i <= Fsprime_i + 1'd1;
				Fs_counter <= Fs_counter + 1'd1;
				
				fs_prime_states <= FS_LEADIN_4;
			end
			
			FS_LEADIN_4: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_i <= Fsprime_i + 1'd1;
				Fs_counter <= Fs_counter + 1'd1;
				Fsprime_TEMP <= SRAM_read_data;
				
				fs_prime_states <= FS_LEADIN_5;
			end
			
			FS_LEADIN_5: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_i <= Fsprime_i + 1'd1;
				Fs_counter <= Fs_counter + 1'd1;
				write_enable_a[0] <= 2'd1;
				
				address_a[0] <= RAM_Address_counter;
				write_data_a[0] <= {Fsprime_TEMP,SRAM_read_data}; //S'0 and S'1 (and so on) are concatenated then put into one postion
				
				fs_prime_states <= FS_1;
			end
			// Lead in ends
			// Common state starts
			FS_1: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_i <= Fsprime_i + 1'd1;
				Fs_counter <= Fs_counter + 1'd1;
				Fsprime_TEMP <= SRAM_read_data;
				RAM_Address_counter <= RAM_Address_counter + 1'd1;
				write_enable_a[0] <= 2'd0;
				
				fs_prime_states <= FS_2;
			end
			
			FS_2: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_i <= Fsprime_i + 1'd1;
				Fs_counter <= Fs_counter + 1'd1;
				
				address_a[0] <= RAM_Address_counter;
				write_data_a[0] <= {Fsprime_TEMP,SRAM_read_data};
				write_enable_a[0] <= 2'd1;
				
				if (Fs_counter == 8'd62) begin
					Fs_counter <= 8'd0;
					fs_prime_states <= FS_LEADOUT_1;
				end else begin
					fs_prime_states <= FS_1;
				end
			end
			// Common state ends
			// Lead out starts
			FS_LEADOUT_1: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				Fsprime_TEMP <= SRAM_read_data;
				RAM_Address_counter <= RAM_Address_counter + 1'd1;
				write_enable_a[0] <= 2'd0;
				
				fs_prime_states <= FS_LEADOUT_2;
			end
			
			FS_LEADOUT_2: begin
				M2_address <= PREIDCT_SEGMENT_BASE + Fsprime_i;
				
				address_a[0] <= RAM_Address_counter;
				write_data_a[0] <= {Fsprime_TEMP,SRAM_read_data};
				RAM_Address_counter <= RAM_Address_counter + 1'd1;
				write_enable_a[0] <= 2'd1;
				
				fs_prime_states <= FS_LEADOUT_3;
			end
			
			FS_LEADOUT_3: begin
				Fsprime_TEMP <= SRAM_read_data;
				write_enable_a[0] <= 2'd0;
				
				fs_prime_states <= FS_LEADOUT_4;
			end
			
			FS_LEADOUT_4: begin
				address_a[0] <= RAM_Address_counter;
				write_data_a[0] <= {Fsprime_TEMP,SRAM_read_data};
				write_enable_a[0] <= 2'd1;
				
				fs_prime_states <= FS_LEADOUT_5;
			end
			
			FS_LEADOUT_5: begin //Since FS is done it sets its finish flag to 1 and sets its state to IDLE
				Fs_prime_finish <= 1'd1; 
				fs_prime_states <= FS_IDLE;
				write_enable_a[0] <= 2'd0;
			end
			// Lead out ends
		endcase
		
		
		/*Ct*/
		case (ct_state)
		
			CT_IDLE: begin
				if (CT_start && ~CT_finish) begin
					Fs_prime_finish <= 1'd0;
					ct_state <= CT_LEADIN_1;
				end
				
			end
			// Lead In begins
			CT_LEADIN_1: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column); // this statement ensures the appropriate values get put into the address
				
				ct_state <= CT_LEADIN_2;
			end
			
			CT_LEADIN_2: begin
				Sprime_column <= Sprime_column + 1'd1;
				
				ct_state <= CT_LEADIN_3;
			end
			
			CT_LEADIN_3: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed($signed(read_data_b[0][31:16])); // this statement ensures all the needed registers get treated as signed registers
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				ct_state <= CT_LEADIN_4;
			end
			
			CT_LEADIN_4: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1; // values get loaded into the acc. unit
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_5;
			end
			
			CT_LEADIN_5: begin			
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_6;
			end
			
			CT_LEADIN_6: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_7;
			end
			
			CT_LEADIN_7: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_8;
			end
			
			CT_LEADIN_8: begin
				Sprime_column <= 1'd0;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_9;
			end
			
			CT_LEADIN_9: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_10;
			end
			
			CT_LEADIN_10: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_column <= 3'd4;
				C_row <= 1'd0;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADIN_11;
			end
			
			CT_LEADIN_11: begin		
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_1;
			end
			// Lead In ends
			// Common case starts
			CT_1: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MULT1_OUT_1;
				MAC_2 <= MULT2_OUT_2;
				MAC_3 <= MULT3_OUT_3;
				MAC_4 <= MULT4_OUT_4;
				
				//--------------------------------------------------
				address_a[1] <= M2_Ram1_offset;
				write_enable_a[1] <= 1'd1;
				write_data_a[1] <= (MAC_1 >> 8);
				TEMP <= MAC_3;
				
				address_b[1] <= M2_Ram1_offset + 1'd1;
				write_enable_b[1] <= 1'd1;
				write_data_b[1] <= (MAC_2 >> 8);
				TEMP1 <= MAC_4;
				
				ct_state <= CT_2;
			end
			
			CT_2: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				//--------------------------------------------------
				address_a[1] <= M2_Ram1_offset + 2'd2;
				write_enable_a[1] <= 1'd1;
				write_data_a[1] <= (TEMP >> 8);
				
				address_b[1] <= M2_Ram1_offset + 3'd3;
				write_enable_b[1] <= 1'd1;
				write_data_b[1] <= (TEMP1 >> 8);
				
				ct_state <= CT_3;
			end
			
			CT_3: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				M2_Ram1_offset <= M2_Ram1_offset + 3'd4;
				
				ct_state <= CT_4;
			end
			
			CT_4: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_5;
			end
			
			CT_5: begin
				Sprime_column <= 1'd0;
				if (C_column == 3'd4) begin
					Sprime_row <= Sprime_row + 1'd1;
				end
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_6;
			end
			
			CT_6: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_7;
			end
			
			CT_7: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= 1'd0;
				
				if (four_flag) begin
					C_column <= 3'd4;
				end else begin
					C_column <= 1'd0;
				end
				four_flag <= ~four_flag;
				
				//--------------------------------------------------
				MULT1_IN_1 <= read_data_b[0][15:8];
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= read_data_b[0][15:8];
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= read_data_b[0][15:8];
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= read_data_b[0][15:8];
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_8;
			end
			
			CT_8: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				if (Sprime_column == 4'd1 && Sprime_row == 4'd7 && C_column == 3'd4) begin
					ct_state <= CT_LEADOUT_1;
				end else begin
					ct_state <= CT_1;
				end
			end
			// Common case ends
			// Lead out begins
			CT_LEADOUT_1: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MULT1_OUT_1;
				MAC_2 <= MULT2_OUT_2;
				MAC_3 <= MULT3_OUT_3;
				MAC_4 <= MULT4_OUT_4;
				
				//--------------------------------------------------
				address_a[1] <= M2_Ram1_offset;
				write_enable_a[1] <= 1'd1;
				write_data_a[1] <= (MAC_1 >> 8);
				TEMP <= MAC_3;
				
				address_b[1] <= M2_Ram1_offset + 1'd1;
				write_enable_b[1] <= 1'd1;
				write_data_b[1] <= (MAC_2 >> 8);
				TEMP1 <= MAC_4;
				
				ct_state <= CT_LEADOUT_2;
			end
			
			CT_LEADOUT_2: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				//--------------------------------------------------
				address_a[1] <= M2_Ram1_offset + 2'd2;
				write_enable_a[1] <= 1'd1;
				write_data_a[1] <= (TEMP >> 8);
				
				address_b[1] <= M2_Ram1_offset + 3'd3;
				write_enable_b[1] <= 1'd1;
				write_data_b[1] <= (TEMP1 >> 8);		
				
				ct_state <= CT_LEADOUT_3;
			end
			
			CT_LEADOUT_3: begin
				Sprime_column <= Sprime_column + 1'd1;
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				write_enable_a[1] <= 1'd0;
				write_enable_b[1] <= 1'd0;
				
				M2_Ram1_offset <= M2_Ram1_offset + 3'd4;
				
				ct_state <= CT_LEADOUT_4;
			end
			
			CT_LEADOUT_4: begin
				address_b[0] <= (Sprime_row << 2) + (Sprime_column);
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADOUT_5;
			end
			
			CT_LEADOUT_5: begin
				C_row <= C_row + 1'd1;
				
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADOUT_6;
			end
			
			CT_LEADOUT_6: begin
				C_row <= C_row + 1'd1;
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][31:16]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADOUT_7;
			end
			
			CT_LEADOUT_7: begin
				//--------------------------------------------------
				MULT1_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT1_IN_2 <= C[C_row][C_column];
				
				MULT2_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT2_IN_2 <= C[C_row][C_column + 1'd1];
				
				MULT3_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT3_IN_2 <= C[C_row][C_column + 2'd2];
				
				MULT4_IN_1 <= $signed(read_data_b[0][15:0]);
				MULT4_IN_2 <= C[C_row][C_column + 2'd3];
				//--------------------------------------------------
				
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADOUT_8;
			end
			
			CT_LEADOUT_8: begin
				MAC_1 <= MAC_1 + MULT1_OUT_1;
				MAC_2 <= MAC_2 + MULT2_OUT_2;
				MAC_3 <= MAC_3 + MULT3_OUT_3;
				MAC_4 <= MAC_4 + MULT4_OUT_4;
				
				ct_state <= CT_LEADOUT_9;
			end
			
			CT_LEADOUT_9: begin
				address_a[1] <= M2_Ram1_offset;
				write_enable_a[1] <= 1'd1;
				write_data_a[1] <= (MAC_1 >> 8);
				TEMP <= MAC_3;
				
				address_b[1] <= M2_Ram1_offset + 1'd1;
				write_enable_b[1] <= 1'd1;
				write_data_b[1] <= (MAC_2 >> 8);
				TEMP1 <= MAC_4;
				
				ct_state <= CT_LEADOUT_10;
			end
			
			CT_LEADOUT_10: begin
				address_a[1] <= M2_Ram1_offset + 2'd2;
				write_data_a[1] <= (TEMP >> 8);
				
				address_b[1] <= M2_Ram1_offset + 2'd3;
				write_data_b[1] <= (TEMP1 >> 8);
				
				ct_state <= CT_LEADOUT_11;
			end
			
			CT_LEADOUT_11: begin
				CT_finish <= 1'd1;
				write_enable_a[1] <= 1'd0;
				write_enable_b[1] <= 1'd0;
				ct_state <= CT_IDLE;
			end
			// Lead out ends
		endcase
		
		/*Ws*/
		case(WS_state)
				S_WS_IDLE: begin
					if (WS_start) begin
						WS_state <= S_WS1;
					end
				end
				
				S_WS1:begin	// Common case starts
					M2_we_n <= 1'b1;
					counterbig <= counterbig + 1;
					write_enable_a[2] <= 1'b0;
					write_enable_a[2] <= 1'b0;
					address_a[2] <= (iw << 2) + jw; //SOS8 (this is the format of how the data is stored)
					address_b[2] <= ((iw+3'd1) << 2)+jw; //S1S9
					
					WS_state <= S_WS2;
						
					end
				
				S_WS2:begin
					counterbig <= counterbig + 1;
					WS_state <= S_WS3;
				end
				
				S_WS3:begin
					counterbig <= counterbig + 1;
					M2_address<= write_counter;
					M2_we_n <= 1'b0;
					write_counter <= write_counter + 18'd1;
					
					// CHOSING WHICH SECTION TO WRITE
					
					if (flagw) begin
						M2_write_data <= {read_data_a[2][15:8],read_data_b[2][15:8]}; // The concatenated 8-bit values get stored into the SEAM at the appropriate positions
					end else begin
						M2_write_data <= {read_data_a[2][7:0],read_data_b[2][7:0]};
					end

						// CHOSING WHICH SECTION TO WRITE
					
						// LOGIC FOR NEXT STEP
						if(flagw == 1'b0 && jw == 4'd3 && iw == 4'd6)begin // this block checks if the mode should go into IDLE
								iw <= 0;
								jw <= 0;
								WS_finish <= 1'd1;
								WS_state <= S_WS_IDLE;
						end
						else if(iw == 4'd6 && flagw == 1'b1)begin // the 2 else if blocks alternate between reading the upper or lower half of the RAM...
							iw <= 0;											// ...by changing the flag bit
							flagw <= 1'b0;
							WS_state <= S_WS1;
						end
						else if(iw == 4'd6 && flagw == 1'b0)begin
							iw <= 0;
							jw <= jw + 1;
							flagw <= 1'b1;
							WS_state <= S_WS1;
						end
						else begin		//this else block is for the normal case if none of the upper blocks
							iw <= iw + 2;
							WS_state <= S_WS1;

						end
						// Common case ends
				end


				default: WS_state <= S_WS_IDLE;
		endcase
		
		
		/*Cs*/
		case (CS_state) 
					// Lead In begins
					S_CS_IDLE:begin
						if (CS_start && ~CS_finish) begin
							CS_state <= S_CS_L1;
						end
					end
					
					S_CS_L1:begin
						counterbig <= counterbig + 16'd1;

						write_enable_a[1] <= 1'b0; // the enables are set to what is required of them
						write_enable_b[1] <= 1'b0;
						write_enable_a[2] <= 1'b1;
						write_enable_b[2] <= 1'b1;
						//this block determines what constant to add
						address_a[1] <= 0;
						address_b[1] <= 8;

						//this block determines what constant to add


						i <= i + 3'd2;
						CS_state <= S_CS_L2;
					
					end
					
					S_CS_L2:begin
						CS_state <= S_CS_L3;
					end
					
					S_CS_L3:begin
						CS_state <= S_CS_1;
						TEMP_A <= read_data_a[1];
						TEMP_B <= read_data_b[1];
					end
					// Lead In ends
					
					//Common Case Starts
					S_CS_1:begin
							counterbig <= counterbig + 16'd1;
							if(i == 0)begin // these if blocks ensure that i*8 operation happens...
								address_a[1] <= 0+j;//... a multiplier was not used since already 4 were used for this section
								address_b[1] <= 8+j;
							end
							if(i == 2)begin
								address_a[1] <= 16+j;
								address_b[1] <= 24+j;
							end
							if(i == 4)begin
								address_a[1] <= 32+j;
								address_b[1] <= 40+j;
							end		
							if(i == 6)begin
								address_a[1] <= 48+j;
								address_b[1] <= 56+j;
							end	
							if(!L)begin
								accumulator1 <= accumulator1 + MULT1_OUT_1;
								accumulator2 <= accumulator2 + MULT2_OUT_2;
								accumulator3 <= accumulator3 + MULT3_OUT_3;
								accumulator4 <= accumulator4 + MULT4_OUT_4;
							end
							else begin 
								L<= 0;
							end
							//this block determines what constant to add
					
							//this block determines what constant to add
						
							MULT1_IN_1 <= $signed(TEMP_A);
							MULT1_IN_2 <= CT[ic_base+0][jc];
							
							MULT2_IN_1 <= $signed(TEMP_A);
							MULT2_IN_2 <= CT[ic_base+1][jc]; 

							MULT3_IN_1 <= $signed(TEMP_A);
							MULT3_IN_2 <= CT[ic_base+2][jc];

							MULT4_IN_1 <= $signed(TEMP_A);
							MULT4_IN_2 <= CT[ic_base+3][jc];
							
						
															
							
							//normal case
							if(j == 3'd7 && i == 3'd6 && half == 1'b1)begin // this block sets the do_kill bet to high...
								do_kill <= 1'b1; //... which lets the final write occur then it puts this mode into IDLE

								CS_state <=S_CS_3;
							end
							else begin
								if(jc == 7)begin // this block means one set is done (IT DOES NOT ADD A VALUE TO j)

										CS_state <=S_CS_3;

									end
									else begin // this block just adds 1 to j
										jc <= jc + 1;
										CS_state <=S_CS_3;
									end
							if(j == 3'd7 && i == 3'd6 && half == 1'b0)begin // this block means the half way point has been reached
									do_half <= 1'b1;

							end
						end

							
					end

					S_CS_3: begin
						CS_state <=S_CS_2;
						
					end
					
					S_CS_2:begin
							TEMP_A <= read_data_a[1];
							TEMP_B <= read_data_b[1];

							counterbig <= counterbig + 16'd1;

							
							//for calculations from previous clock cycle
							accumulator1 <= accumulator1 + MULT1_OUT_1;
							accumulator2 <= accumulator2 + MULT2_OUT_2;
							accumulator3 <= accumulator3 + MULT3_OUT_3;
							accumulator4 <= accumulator4 + MULT4_OUT_4;

							MULT1_IN_1 <= $signed(TEMP_B);
							MULT1_IN_2 <= CT[ic_base+0][jc];
							
							MULT2_IN_1 <= $signed(TEMP_B);
							MULT2_IN_2 <= CT[ic_base+1][jc]; 

							MULT3_IN_1 <= $signed(TEMP_B);
							MULT3_IN_2 <= CT[ic_base+2][jc];

							MULT4_IN_1 <= $signed(TEMP_B);
							MULT4_IN_2 <= CT[ic_base+3][jc];
							
							
							if(do_kill)begin // explained above
								kill <= 1'b1;
								A <= 1'b0;
								jc <= jc + 1;
								CS_state <=S_CS_4;
							end
							else begin
							if(do_half == 1'b1)begin
									i <=0;
									j <=0;
									half <= 1'b1;
									do_half <= 1'b0;
									ic_base <= 4;
									jc <= jc + 1;
									CS_state <=S_CS_1;
							end
							else	if(jc == 7)begin 
										j <= j + 1;
										i <= 0;
										jc <= 0;
										counter <= counter + 1;
										A <= 1'b0;
										CS_state <=S_CS_4;
									end
									else begin 
										jc <= jc + 1;
										i <= i + 2;
										CS_state <=S_CS_1;
									end

						end
					end
					// Common Case ends
					// Special case for writing starts
					S_CS_4:begin
							jc <= jc + 1;
							MULT1_IN_1 <= $signed(TEMP_A);
							MULT1_IN_2 <= CT[ic_base+0][jc];
							
							MULT2_IN_1 <= $signed(TEMP_A);
							MULT2_IN_2 <= CT[ic_base+1][jc]; 

							MULT3_IN_1 <= $signed(TEMP_A);
							MULT3_IN_2 <= CT[ic_base+2][jc];

							MULT4_IN_1 <= $signed(TEMP_A);
							MULT4_IN_2 <= CT[ic_base+3][jc];
							
							accumulator1 <= accumulator1 + MULT1_OUT_1;
							accumulator2 <= accumulator2 + MULT2_OUT_2;
							accumulator3 <= accumulator3 + MULT3_OUT_3;
							accumulator4 <= accumulator4 + MULT4_OUT_4;
					
							CS_state <=S_CS_5;		
					end
					
					S_CS_5:begin
							MULT1_IN_1 <= $signed(TEMP_B);
							MULT1_IN_2 <= CT[ic_base+0][jc];
							
							MULT2_IN_1 <= $signed(TEMP_B);
							MULT2_IN_2 <= CT[ic_base+1][jc]; 

							MULT3_IN_1 <= $signed(TEMP_B);
							MULT3_IN_2 <= CT[ic_base+2][jc];

							MULT4_IN_1 <= $signed(TEMP_B);
							MULT4_IN_2 <= CT[ic_base+3][jc];
							
							accumulator1 <= accumulator1 + MULT1_OUT_1;
							accumulator2 <= accumulator2 + MULT2_OUT_2;
							accumulator3 <= accumulator3 + MULT3_OUT_3;
							accumulator4 <= accumulator4 + MULT4_OUT_4;
							
							CS_state <=S_CS_6;
					end
					
					S_CS_6:begin
						if(i == 0)begin
							address_a[1] <= 0+j;
							address_b[1] <= 8+j;
						end
						if(i == 2)begin
							address_a[1] <= 16+j;
							address_b[1] <= 24+j;
						end
						if(i == 4)begin
							address_a[1] <= 32+j;
							address_b[1] <= 40+j;
						end		
						if(i == 6)begin
							address_a[1] <= 48+j;
							address_b[1] <= 56+j;
						end
						write_enable_a[2] <= 1'b1;
						write_enable_b[2] <= 1'b1;

						CS_TEMP1 <= accumulator1_final;
						CS_TEMP2 <= accumulator2_final;
						CS_TEMP3 <= accumulator3_final;
						CS_TEMP4 <= accumulator4_final;

						CS_state <= S_CS_7;
					end
						
					S_CS_7:begin
						

						MULT1_IN_1 <= 32'd0;
						MULT2_IN_1 <= 32'd0;
						MULT3_IN_1 <= 32'd0;
						MULT4_IN_1 <= 32'd0;
						accumulator1 <= 32'd0;
						accumulator2 <= 32'd0;
						accumulator3 <= 32'd0;
						accumulator4 <= 32'd0;
						CS_state <= S_CS_8;
						if(i == 6 && j == 7)begin
							address_a[2] <= (i_cs_w);
							address_b[2] <= (i_cs_w+1);
							i_cs_w <= i_cs_w + 2;
							write_data_a[2] <= {CS_TEMP1[7:0],CS_TEMP2[7:0]}; // signal conct. again
							write_data_b[2] <= {CS_TEMP3[7:0],CS_TEMP4[7:0]};
						end
						
					end				
						
						

					S_CS_8:begin
						
						address_a[2] <= (i_cs_w);
						address_b[2] <= (i_cs_w+1);
						i_cs_w <= i_cs_w + 2;



						
						counterbig <= counterbig + 16'd1;
						write_data_a[2] <= {CS_TEMP1[7:0],CS_TEMP2[7:0]};
						write_data_b[2] <= {CS_TEMP3[7:0],CS_TEMP4[7:0]};
						
						write_enable_a[2] <= 1'b0;
						write_enable_b[2] <= 1'b0;
						
						if(!kill)begin
							TEMP_A <= read_data_a[1];
							TEMP_B <= read_data_b[1];
							i <= i + 2;
							CS_state<=S_CS_1;
						end else begin
							CS_finish <= 1'd1;
							i_cs_w <= 0;
							CS_state <= S_CS_IDLE;
						end

					end			
					default: CS_state <= S_CS_IDLE;
					// Special case for writing ends
				endcase	
		
		
	end
end

endmodule