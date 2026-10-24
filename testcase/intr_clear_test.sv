class intr_clear_test extends base_test;
function new();
super.new();
endfunction
virtual task run_scenario();
bit[7:0] tsr;
wait(dut_vif.presetn==1'b1);
write(8'h03,8'h03);
write(8'h02,8'hFC);
write(8'h00,8'b0000_0100);
write(8'h00,8'b0000_0001);
repeat (10) @(posedge dut_vif.clk_in);
write(8'h00,8'h00);
repeat (3) @(posedge dut_vif.pclk);
read(8'h01,tsr);
if(tsr[1:0]!==2'b01 || dut_vif.interrupt!==1'b1) begin
$display("[Overflow Set] FAILED - TSR=%b (exp 01) interrupt=%0b",tsr[1:0],dut_vif.interrupt);
error++;
end else $display("[Overflow Set] PASSED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
write(8'h02,8'h03);
write(8'h00,8'b0000_0110);
write(8'h00,8'b0000_0011);
repeat (10) @(posedge dut_vif.clk_in);
write(8'h00,8'h00);
repeat (3) @(posedge dut_vif.pclk);
read(8'h01,tsr);
if(tsr[1:0]!==2'b11 || dut_vif.interrupt!==1'b1) begin
$display("[OVF&UNF] FAILED - TSR=%b (exp 11) interrupt=%0b",tsr[1:0],dut_vif.interrupt);
error++;
end else $display("[OVF&UNF] PASSED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
write(8'h01,8'h00);
repeat (3) @(posedge dut_vif.pclk);
read(8'h01,tsr);
if(tsr[1:0]!==2'b11 || dut_vif.interrupt!==1'b1) begin
$display("[write 0] FAILED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
error++;
end else $display("[write 0] PASSED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
// xoa rieng overflow: underflow con -> interrupt van 1
write(8'h01,8'h01);
repeat (3) @(posedge dut_vif.pclk);
read(8'h01,tsr);
if(tsr[1:0]!==2'b10 || dut_vif.interrupt!==1'b1) begin
$display("[clear overflow] FAILED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
error++;
end else $display("[clear overflow] PASSED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
write(8'h01,8'h02);
repeat (3) @(posedge dut_vif.pclk);
read(8'h01,tsr);
if(tsr[1:0]!==2'b00 || dut_vif.interrupt!==1'b0) begin
$display("[clear underflow] FAILED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
error++;
end else $display("[clear underflow] PASSED - TSR=%b interrupt=%0b",tsr[1:0],dut_vif.interrupt);
write(8'h03,8'h00);
endtask
endclass
