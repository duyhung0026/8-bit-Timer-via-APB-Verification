class counter_resume_test extends base_test;
function new();
super.new();
endfunction

virtual task run_scenario();
bit [7:0] hold,prev;
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
repeat(5) @(posedge dut_vif.clk_in);
  if (dut_vif.cnt !== hold) begin
    hold = dut_vif.cnt;
repeat(20) @(posedge dut_vif.clk_in);
  end

  if (dut_vif.cnt !== hold) begin
    $display("[disable] FAIL - cnt changed after disable"); error++;
  end

//re-enable
write(8'h00,8'h01);
repeat(2) @(posedge dut_vif.clk_in);
prev=dut_vif.cnt;

if(prev>hold) begin
$display("%0t: [Resume] PASSED hold=%0d, cnt_prev=%0d",$time,hold,prev);
end else
$display("%0t: [Resume] FAILED hold= %0d,cnt_prev= %0d",$time,hold,prev);
error++;
endtask
endclass
