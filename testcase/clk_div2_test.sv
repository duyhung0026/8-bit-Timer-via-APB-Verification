class clk_div2_test extends base_test;
bit[7:0]rd;
function new();
super.new();
endfunction

virtual task run_scenario();
wait(dut_vif.presetn==1'b1);
repeat(5) @(posedge dut_vif.pclk);
write(8'h02,8'h00);
div_by(8'h09);
write(8'h03,8'h03);
div_by(8'h0B);
wait(dut_vif.interrupt==1'b1);
endtask
endclass
