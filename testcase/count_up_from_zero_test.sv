class count_up_from_zero_test extends base_test;
bit [7:0] rdata;
function new();
super.new();
endfunction

virtual task run_scenario();
wait(dut_vif.presetn==1'b1);
counter_tdr_tcr_expected(8'h0,8'h01,8'h0);
if(error==0)
$display("[Count up from 0] PASSED");
else 
$display("[Count up from 0] FAILED (%0d error)",error);
endtask 
endclass
