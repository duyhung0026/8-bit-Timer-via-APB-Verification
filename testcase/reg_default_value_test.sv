class reg_default_value_test extends base_test;
bit [7:0] d0,d1,d2,d3;

function new();
super.new();
endfunction

virtual task run_scenario();
wait(dut_vif.presetn == 1'b1);
read(8'h00,d0);
$display("[Register default value test] register 0x00 read value: %h",d0);
read(8'h01,d1);
$display("[Register default value test] register 0x01 read value: %h",d1); 
read(8'h02,d2);
$display("[Register default value test] register 0x02 read value: %h",d2); 
read(8'h03,d3);
$display("[Register default value test] register 0x03 read value: %h",d3);
if((d0==8'h0) && (d1==8'h0) && (d2==8'h0) && (d3==8'h0)) 
$display("[Register default value test] TEST PASSED: all registers have correct default value");
else $display("[Register default value test] TEST FAIL: register has incorrect default value");

$display("[Register default value test] complete test"); 
endtask
endclass
