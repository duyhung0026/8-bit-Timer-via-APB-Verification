class reg_reserved_test extends base_test;
function new();
super.new();
endfunction
virtual task run_scenario();
bit [7:0] rd;
wait(dut_vif.presetn==1'b1);
for (int a=8'h04; a<=8'hFF; a++) begin
write(a[7:0],8'hFF);
read(a[7:0],rd);
if(rd!==8'h00) begin
$display("[reserved] FAIL addr=%h read=%h (exp 00)",a[7:0],rd);
error++;
end
end
if(error==0) $display("[reserved] PASS");
endtask
endclass
