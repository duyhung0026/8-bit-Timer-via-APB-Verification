class count_down_with_data_test extends base_test;
bit [7:0] rdata;
function new();
super.new();
endfunction

virtual task run_scenario();
wait(dut_vif.presetn==1'b1);
	
counter_tdr_tcr_expected(8'd100,8'h03,8'd100);
if(error==0)
$display("[Count down from 100] PASSED");
else 
$display("[Count down from 100] FAILED (%0d error)",error);
endtask 
endclass
