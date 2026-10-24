class scoreboard;
mailbox#(packet) m2s_mb;

`include "coverage.sv"

function new(mailbox#(packet) m2s_mb);
this.m2s_mb=m2s_mb;
apb_trans=new();
APB_GROUP=new();
endfunction

function void sample_apb_fc(packet pkt);
$cast(apb_trans,pkt);
if(apb_trans.transfer == packet::WRITE && apb_trans.addr ==8'h03) begin
last_overflow_en = apb_trans.data [0];
last_underflow_en = apb_trans.data [1];
end
APB_GROUP.sample();
endfunction

task run();
packet pkt;
while (1) begin
m2s_mb.get(pkt);
$display("%0t: [Scoreboard] Get packet from monitor: %s: addr = %b, data = %h",
										$time,pkt.transfer.name(),pkt.addr,pkt.data);
sample_apb_fc(pkt);

end
endtask
endclass
