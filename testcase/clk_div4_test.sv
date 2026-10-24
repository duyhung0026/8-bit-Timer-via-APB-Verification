class clk_div4_test extends base_test;
bit[7:0] rd;

function new();
super.new();
endfunction

virtual task run_scenario();
wait(dut_vif.presetn==1'b1);
repeat(5) @(posedge dut_vif.pclk);
write(8'h02,8'h00);
div_by(8'h13);//0001 0011
read(8'h01,rd);
wait(dut_vif.interrupt==1'b1);
endtask
endclass
