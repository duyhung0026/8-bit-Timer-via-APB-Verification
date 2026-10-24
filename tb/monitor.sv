class monitor;
virtual dut_if dut_vif;
mailbox #(packet) m2s_mb;

function new(virtual dut_if dut_vif,mailbox #(packet) m2s_mb);
this.dut_vif=dut_vif;
this.m2s_mb=m2s_mb;
endfunction

task run();
packet pkt;

while (1) begin
@(posedge dut_vif.pclk);
wait(dut_vif.psel&&dut_vif.penable);

pkt=new();
pkt.addr=dut_vif.paddr;
pkt.transfer = dut_vif.pwrite ? packet::WRITE : packet::READ;
pkt.data = dut_vif.pwrite ? dut_vif.pwdata : dut_vif.prdata;

$display("%0t: [Monitor] Captured APB %s: address = %0h, data = %0h",$time, pkt.transfer.name(),pkt.addr,pkt.data);

m2s_mb.put(pkt);

@(posedge dut_vif.pclk);
end
endtask
endclass
