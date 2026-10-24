class driver;
mailbox#(packet) s2d_mb;
virtual dut_if dut_vif;
event xfer_done;

function new(virtual dut_if dut_vif,mailbox#(packet) s2d_mb);
this.dut_vif=dut_vif;
this.s2d_mb=s2d_mb;
endfunction

task run();
packet pkt;

while (1) begin
s2d_mb.get(pkt);
$display("%0t: [Driver] Get packet from stimulus",$time);
//SETUP
@(posedge dut_vif.pclk);
dut_vif.paddr <= pkt.addr;
dut_vif.pwrite <= (pkt.transfer == packet :: WRITE);
dut_vif.pwdata <= (pkt.transfer == packet :: WRITE) ? pkt.data :0;
dut_vif.psel <= 1'b1;
dut_vif.penable<=1'b0;
//ACCESS
@(posedge dut_vif.pclk);
dut_vif.penable <=1'b1;
if (pkt.transfer == packet :: READ)
pkt.data <= dut_vif.prdata;
//BACK TO IDLE
@(posedge dut_vif.pclk);
dut_vif.psel <=1'b0;
dut_vif.penable<=1'b0;
-> xfer_done;
end
endtask
endclass

