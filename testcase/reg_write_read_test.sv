class reg_write_read_test extends base_test;
bit [7:0] wr,rd;
virtual task run_scenario ();
wait(dut_vif.presetn==1'b1);
wr=8'hAA;
write(8'h02,wr);
read(8'h02,rd);
if(wr==rd) $display("[Reg write read test] Write Read test SUCCESSFUL: write = %h , read = %h",wr,rd);
else if (wr!=rd) $display("[Reg write read test] Write Read test FAILED: write = %h, read = %h",wr,rd);
endtask
endclass
