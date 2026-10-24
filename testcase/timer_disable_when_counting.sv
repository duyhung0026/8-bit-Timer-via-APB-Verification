class timer_disable_when_counting extends base_test;

function new();
super.new();
endfunction

virtual task run_scenario();
bit [7:0] hold;
wait(dut_vif.presetn==1'b1);

//timer ovf_unf enable
write(8'h03,8'h03);
write(8'h00,8'h01);

fork
wait(dut_vif.cnt >= 8'd10);
begin
repeat (30) @(posedge dut_vif.clk_in);
$display("[Disable] FAILED disable");
error++;
end
join_any
disable fork;

write(8'h00,8'h00);
hold = dut_vif.cnt;
repeat(100) @(posedge dut_vif.clk_in);  
if (dut_vif.cnt !== hold) begin
hold = dut_vif.cnt;
repeat(100) @(posedge dut_vif.clk_in);
end

if (dut_vif.cnt !== hold) begin
$display("[disable] FAIL - cnt changed after disable"); error++;
end else
$display("[disable] PASS - cnt holding = %0d", hold);
endtask
endclass
