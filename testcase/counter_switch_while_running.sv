class counter_switch_while_running extends base_test;
function new();
super.new();
endfunction
virtual task run_scenario();
bit [7:0] a, b;
int up_cnt = 0, dw_cnt = 0;
wait(dut_vif.presetn==1'b1);

//timer ovf_unf enable
write(8'h03,8'h03);
write(8'h00,8'h01);            

fork
wait(dut_vif.cnt >= 8'd20);
begin
repeat (60) @(posedge dut_vif.clk_in);
$display("%0t: [switch_dir] FAILED counter NOT run",$time);
error++;
end
join_any
disable fork;

write(8'h00,8'h03);            
repeat (3) @(posedge dut_vif.clk_in);


repeat (8) begin
a = dut_vif.cnt;
@(posedge dut_vif.clk_in);
b = dut_vif.cnt;
if (b==a+8'd1) up_cnt++;
else if (b==a-8'd1) dw_cnt++;
end

$display("%0t: [switch_dir] up=%0d down=%0d",$time,up_cnt, dw_cnt);

if (dw_cnt >= 6)
$display("%0t: [switch_dir] INFO - DUT changed to count down",$time);
else if (up_cnt >= 6)
$display("%0t: [switch_dir] INFO - DUT SKIPPED count down state",$time);
else begin
$display("[switch_dir] FAILED undefined");
error++;
end
endtask
endclass
