class intr_underflow_enable_test extends base_test;
function new();
super.new();
endfunction

virtual task run_scenario();
wait(dut_vif.presetn==1'b1);
write(8'h03,8'h02);
div_by(8'h1B);
endtask
endclass
