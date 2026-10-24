class intr_polling_mode_test extends base_test;
function new();
super.new();
endfunction
virtual task run_scenario();
int d;
wait(dut_vif.presetn==1'b1);
for(d=0;d<2;d++) begin
write(8'h03,8'h00);
div_by({6'b0,d[0],1'b1});
end
endtask
endclass
