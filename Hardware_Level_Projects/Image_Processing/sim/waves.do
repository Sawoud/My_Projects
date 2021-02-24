# activate waveform simulation

view wave

# format signal names in waveform

configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits us

# add signals to waveform

add wave -uns UUT/M2_unit/m2_state
add wave -uns UUT/M2_unit/M2_start

add wave -divider -height 10 {Fs' Signals}
add wave -uns UUT/M2_unit/fs_prime_states
add wave -hex UUT/SRAM_read_data
add wave -hex UUT/SRAM_write_data
add wave -hex UUT/SRAM_address
add wave -uns UUT/M2_unit/M2_address
add wave -uns UUT/M2_unit/Fsprime_i
add wave -uns UUT/M2_unit/RAM_Address_counter
add wave -uns UUT/M2_unit/Fs_prime_start
add wave -uns UUT/M2_unit/Fs_prime_finish
add wave -uns UUT/M2_unit/Fsprime_TEMP
add wave -hex UUT/M2_unit/write_data_a
add wave -uns UUT/M2_unit/write_enable_a
add wave -hex UUT/M2_unit/read_data_a
add wave -hex UUT/M2_unit/read_data_b

add wave -divider -height 10 {Ct Signals}
add wave -uns UUT/M2_unit/ct_state
add wave -uns UUT/M2_unit/CT_finish
add wave -uns UUT/M2_unit/CT_start
add wave -hex UUT/M2_unit/MAC_1
add wave -hex UUT/M2_unit/MAC_2
add wave -hex UUT/M2_unit/MAC_3
add wave -hex UUT/M2_unit/MAC_4
add wave -hex UUT/M2_unit/MULT1_IN_1
add wave -hex UUT/M2_unit/MULT1_IN_2
add wave -uns UUT/M2_unit/C_row
add wave -uns UUT/M2_unit/C_column
add wave -uns UUT/M2_unit/Sprime_row
add wave -uns UUT/M2_unit/Sprime_column
add wave -uns UUT/M2_unit/M2_Ram1_offset
add wave -uns UUT/M2_unit/address_a
add wave -uns UUT/M2_unit/address_b
add wave -hex UUT/M2_unit/write_data_a
add wave -hex UUT/M2_unit/write_data_b

add wave -divider -height 10 {Cs Signals}
add wave -hex UUT/M2_unit/CS_state
add wave -hex UUT/M2_unit/CS_start
add wave -hex UUT/M2_unit/CS_finish
add wave -hex UUT/M2_unit/TEMP_A
add wave -hex UUT/M2_unit/TEMP_B
add wave -hex UUT/M2_unit/CS_TEMP1
add wave -hex UUT/M2_unit/CS_TEMP2
add wave -hex UUT/M2_unit/CS_TEMP3
add wave -hex UUT/M2_unit/CS_TEMP4
add wave -hex UUT/M2_unit/accumulator1
add wave -hex UUT/M2_unit/accumulator2
add wave -hex UUT/M2_unit/accumulator3
add wave -hex UUT/M2_unit/accumulator4
add wave -hex UUT/M2_unit/ic_base
add wave -hex UUT/M2_unit/jc
add wave -hex UUT/M2_unit/i
add wave -hex UUT/M2_unit/j
add wave -hex UUT/M2_unit/accumulator1_final
add wave -hex UUT/M2_unit/accumulator2_final
add wave -hex UUT/M2_unit/accumulator3_final
add wave -hex UUT/M2_unit/accumulator4_final

add wave -divider -height 10 {Ws Signals}
add wave -hex UUT/M2_unit/WS_state
add wave -hex UUT/M2_unit/WS_start
add wave -hex UUT/M2_unit/WS_finish
add wave -hex UUT/M2_unit/M2_we_n

add wave -divider -height 20 {Top-level signals}

add wave -bin UUT/CLOCK_50_I
add wave -bin UUT/resetn
add wave UUT/top_state
add wave -uns UUT/UART_timer

add wave -divider -height 10 {SRAM signals}
add wave -uns UUT/SRAM_address
add wave -bin UUT/SRAM_we_n

add wave -divider -height 10 {VGA signals}
add wave -bin UUT/VGA_unit/VGA_HSYNC_O
add wave -bin UUT/VGA_unit/VGA_VSYNC_O
add wave -uns UUT/VGA_unit/pixel_X_pos
add wave -uns UUT/VGA_unit/pixel_Y_pos
add wave -hex UUT/VGA_unit/VGA_red
add wave -hex UUT/VGA_unit/VGA_green
add wave -hex UUT/VGA_unit/VGA_blue