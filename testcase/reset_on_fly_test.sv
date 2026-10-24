class reset_on_fly_test extends base_test;
int error_count = 0;

function new();
super.new();
endfunction

virtual task run_scenario();
bit [7:0] tcr_rd, tsr_rd, tdr_rd, tie_rd;
wait(dut_vif.presetn == 1'b1);
// Cho counter chạy gần tới overflow
write(8'h00, 8'b0000_0001);           // timer_en=1, count up
repeat(250) @(posedge dut_vif.ker_clk);

// Assert reset
dut_vif.presetn = 1'b0;
repeat(30) @(posedge dut_vif.pclk);
dut_vif.presetn = 1'b1;
repeat(10) @(posedge dut_vif.pclk);

// Check 1
read(8'h00, tcr_rd);
read(8'h01, tsr_rd);
read(8'h02, tdr_rd);
read(8'h03, tie_rd);

if (tcr_rd !== 8'h00) begin
$display("FAIL - TCR khong ve default sau reset, got 0x%0h", tcr_rd);
error_count++;
end
if (tsr_rd !== 8'h00) begin
$display("FAIL - TSR khong ve default sau reset, got 0x%0h", tsr_rd);
error_count++;
end
if (tie_rd !== 8'h00) begin
$display("FAIL - TIE khong ve default sau reset, got 0x%0h", tie_rd);
error_count++;
end
// Check 2
write(8'h00, 8'b0000_0001);           // bật timer_en
repeat(3) @(posedge dut_vif.ker_clk);
read(8'h01, tsr_rd);                  //TSR check bit overflow
if (tsr_rd[0] == 1'b1) begin
$display("FAIL - Counter bi overflow sau 3 chu ky -> KHONG ve 0 sau reset");
error_count++;
end
else begin
$display("PASS - Counter dem lai tu 0 dung nhu ky vong sau reset");
end
if (error_count == 0)
$display("[reset_on_fly_test] RESULT: PASSED");
else
$display("[reset_on_fly_test] RESULT: FAILED (%0d error)", error_count);
endtask
endclass
