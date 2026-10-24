package test_pkg;

  import timer_pkg::*;
`include "base_test.sv"
`include "reg_default_value_test.sv"
`include "reg_write_read_test.sv"
`include "reset_on_fly_test.sv"

`include "clk_no_div_test.sv"
`include "clk_div2_test.sv"
`include "clk_div4_test.sv"
`include "clk_div8_test.sv"

`include "count_up_from_zero_test.sv"
`include "count_down_from_zero_test.sv"
`include "count_up_with_data_test.sv"
`include "count_down_with_data_test.sv"
`include "timer_disable_when_counting.sv"
`include "counter_resume_test.sv"
`include "counter_switch_while_running.sv"
`include "intr_overflow_enable_test.sv"
`include "intr_overflow_disable_test.sv"
`include "intr_underflow_enable_test.sv"
`include "intr_underflow_disable_test.sv"
`include "intr_clear_test.sv"
`include "intr_both_enable_test.sv"
`include "intr_polling_mode_test.sv"
endpackage
