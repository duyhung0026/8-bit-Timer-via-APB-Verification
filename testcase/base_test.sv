class base_test;

environment env;
virtual dut_if dut_vif;

int error=0;

function new();
endfunction

function void build();
env = new (dut_vif);
env.build();
endfunction

task write (bit [7:0] addr, bit[7:0] data);
packet pkt = new();
pkt.addr=addr;
pkt.data=data;
pkt.transfer = packet::WRITE;
env.stim.send_pkt(pkt);
@(env.drv.xfer_done);
endtask

task read (bit [7:0] addr, ref bit[7:0] data);
packet pkt = new();
pkt.addr=addr;
pkt.transfer = packet::READ;
env.stim.send_pkt(pkt);
@(env.drv.xfer_done);
data = pkt.data;
endtask

task div_by( bit [7:0] data);
//check both underflow and overflow in divide test
bit [7:0] rdata;
bit [7:0] temp;
bit [7:0] cnt_prev,cnt_curr;
bit [7:0] tie_rd;
bit exp_intr;

read(8'h03,tie_rd);
exp_intr=data[1]?tie_rd[1]:tie_rd[0];
if (data[1]) begin
write(8'h02, 8'hFD);
write(8'h00, 8'b0000_0100);
end

write(8'h00, data);
cnt_prev=dut_vif.cnt;
forever begin
@(posedge dut_vif.clk_in);
cnt_curr=dut_vif.cnt;
if(cnt_prev==8'hFF && cnt_curr==8'h00) break;
if(cnt_prev==8'h00 && cnt_curr==8'hFF) break;
cnt_prev=cnt_curr;
end

repeat(3) @(posedge dut_vif.pclk);
read(8'h01,rdata);//read TSR
if(data[1]) begin
if(rdata[1]!=1) begin
$display("[TSR] FAILED: Underflow bit not triggered");
error++;
end else begin
$display("[TSR] PASS: Underflow bit triggered");
repeat (3) @(posedge dut_vif.pclk);
if(dut_vif.interrupt !==exp_intr) begin
$display("[FAIL] Interrupt=%0b expected=%0b TIE=%h",dut_vif.interrupt,exp_intr,tie_rd);
error++;
end else $display("[PASS] Interrupt=%0b TIE=%h",dut_vif.interrupt,tie_rd);
end
end else begin
if(rdata[0]!=1) begin
$display("[TSR] FAILED: Overflow bit not triggered");
error++;
end else begin
$display("[TSR] PASS: Overflow bit triggered");
repeat (3) @(posedge dut_vif.pclk);
if(dut_vif.interrupt!==exp_intr) begin
$display("[FAILED] Interrupt=%0b expected=%0b TIE=%h",dut_vif.interrupt,exp_intr,tie_rd);
error++;
end else $display("[PASS] Interrupt=%0b TIE=%h",dut_vif.interrupt,tie_rd);
end
end
write(8'h00,8'h00);
write(8'h01,8'h03);
read(8'h01,temp);
$display("TSR cleared -> %0h",temp);

repeat(3) @(posedge dut_vif.pclk);
if(dut_vif.interrupt!==1'b0) begin
$display("[Interrupt] FAILED Interrupt not deasserted after W1C");
error++;
end
write(8'h00,8'h00);
write(8'h03,8'h00);
endtask

task counter_tdr_tcr_expected(bit [7:0] tdr_data, bit [7:0] tcr_data, bit [7:0] expected_data);
bit [7:0] cnt_val;
bit [7:0] cnt_before, cnt_after;
int i;
//load
if (tdr_data!=0) begin
write(8'h02, tdr_data);
write(8'h00, 8'b0000_0100);  // load=1
end

write(8'h00, tcr_data);// clk_div/count_down/timer_en
cnt_val = dut_vif.cnt;
if (cnt_val !== expected_data) begin
$display("[FAIL] Counter started WRONG data, expect %0d got %0d",expected_data, cnt_val);
error++;
end else begin
$display("[PASS] Counterstarted RIGHT data %0d", cnt_val);
end
@(posedge dut_vif.clk_in);
for (i = 0; i < 5; i++) begin
cnt_before = dut_vif.cnt;
@(posedge dut_vif.clk_in);
cnt_after = dut_vif.cnt;
if (tcr_data[1]) begin  // count_down
if (cnt_after == cnt_before - 1'b1)
$display("[PASS] Counting down RIGHT: %0d -> %0d", cnt_before, cnt_after);
else begin
$display("[FAIL] Counting down WRONG : %0d -> %0d (expected -1)", cnt_before, cnt_after);
error++;
end
end else begin // count_up
if (cnt_after == cnt_before + 1'b1)
$display("[PASS] Counting up RIGHT: %0d -> %0d", cnt_before, cnt_after);
else begin
$display("[FAIL] Counting up WRONG: %0d -> %0d (expected +1)", cnt_before, cnt_after);
error++;
end
end
end
write(8'h00, 8'h00);
endtask
virtual task run_scenario();
endtask

task run_test();
build();
fork
env.run();
run_scenario();
join_any
#1us;
$display("%0t: [base_test] End Simulation",$time);
$finish;
endtask

endclass
