`timescale 1ns/1ps

module testbench; 
  import timer_pkg::*;
  import test_pkg::*;
 
  dut_if d_if();

  timer_top u_dut(
    .ker_clk(d_if.ker_clk),       
    .pclk(d_if.pclk),       
    .presetn(d_if.presetn),    
    .psel(d_if.psel),       
    .penable(d_if.penable),    
    .pwrite(d_if.pwrite),     
    .paddr(d_if.paddr),      
    .pwdata(d_if.pwdata),     
    .prdata(d_if.prdata),     
    .pready(d_if.pready),     
    .interrupt(d_if.interrupt));
assign d_if.cnt= u_dut.u_counter.cnt;
assign d_if.clk_in=u_dut.u_counter.clk_in;
initial begin
    d_if.presetn = 0;
    #100ns d_if.presetn = 1;
  end

  // 50 MHz
  initial begin
    d_if.pclk = 0;
    forever begin 
      #10ns;
      d_if.pclk = ~d_if.pclk;
    end
  end
 
  // 200 MHz
  initial begin
    d_if.ker_clk = 1;
    forever begin 
      #2.5ns;
      d_if.ker_clk = ~d_if.ker_clk;
    end
  end

  initial begin
    #1ms;
    $display("[testbench] Time out....Seems your tb is hang!");
    $finish;
  end
base_test base=new();
reg_default_value_test default_value=new();
reg_write_read_test wr_rd=new();
reset_on_fly_test rst_on_fly=new();
reg_reserved_test reserved=new();

clk_no_div_test no_div=new();
clk_div2_test div2=new();
clk_div4_test div4=new();
clk_div8_test div8=new();

count_up_from_zero_test 	up_from_zero=new();
count_down_from_zero_test 	dw_from_zero=new();
count_up_with_data_test 	up_with_data=new();
count_down_with_data_test 	dw_with_data=new();
timer_disable_when_counting 	timer_disable_cnt=new();
counter_resume_test 		cnt_resume=new();
counter_switch_while_running    cnt_sw=new();

intr_overflow_enable_test	intr_ovf_enb=new();
intr_overflow_disable_test	intr_ovf_dis=new();
intr_underflow_enable_test	intr_unf_enb=new();
intr_underflow_disable_test	intr_unf_dis=new();
intr_clear_test			intr_clr=new();
intr_both_enable_test		intr_both_enb=new();
intr_polling_mode_test		intr_polling=new();
initial begin
if($test$plusargs("reg_default_value_test")) base = default_value;
if($test$plusargs("reg_write_read_test")) base = wr_rd;
if($test$plusargs("reset_on_fly_test")) base = rst_on_fly;
if($test$plusargs("reg_reserved_test")) base=reserved;

if($test$plusargs("clk_no_div_test")) base = no_div;
if($test$plusargs("clk_div2_test")) base=div2;
if($test$plusargs("clk_div4_test")) base=div4;
if($test$plusargs("clk_div8_test")) base=div8;

if($test$plusargs("count_up_from_zero_test")) 		base=up_from_zero;
if($test$plusargs("count_down_from_zero_test")) 	base=dw_from_zero;
if($test$plusargs("count_up_with_data_test"))		base=up_with_data;
if($test$plusargs("count_down_with_data_test")) 	base=dw_with_data;
if($test$plusargs("timer_disable_when_counting")) 	base=timer_disable_cnt;
if($test$plusargs("counter_resume_test")) 		base=cnt_resume;
if($test$plusargs("counter_switch_while_running"))	base=cnt_sw;

if($test$plusargs("intr_overflow_enable_test"))		base=intr_ovf_enb;
if($test$plusargs("intr_overflow_disable_test"))	base=intr_ovf_dis;
if($test$plusargs("intr_underflow_enable_test"))	base=intr_unf_enb;
if($test$plusargs("intr_underflow_disable_test"))	base=intr_unf_dis;
if($test$plusargs("intr_clear_test"))			base=intr_clr;
if($test$plusargs("intr_both_enable_test"))		base=intr_both_enb;
if($test$plusargs("intr_polling_mode_test"))		base=intr_polling;
base.dut_vif=d_if;
base.run_test();
end
endmodule
