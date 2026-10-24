packet apb_trans;

bit last_overflow_en;
bit last_underflow_en;

covergroup APB_GROUP;

apb_transfer: coverpoint apb_trans.transfer{
bins READ={packet::READ};
bins WRITE={packet::WRITE};
}

apb_address: coverpoint apb_trans.addr{
bins TCR={8'h00};
bins TSR={8'h01};
bins TDR={8'h02};
bins TIE={8'h03};
bins RSVD={[8'h04:8'hFF]};
}
//TCR
tcr_clk_div: coverpoint apb_trans.data[4:3]{
bins div0={2'b00};
bins div2={2'b01};
bins div4={2'b10};
bins div8={2'b11};
}

tcr_load: coverpoint apb_trans.data[2]{
bins normal={1'b0};
bins cnt={1'b1};
}


tcr_count: coverpoint apb_trans.data[1]{
bins up={1'b0};
bins down={1'b1};
}

tcr_timer_en: coverpoint apb_trans.data[0]{
bins disable_timer={1'b0};
bins enable_timer={1'b1};
}

//TSR
tsr_overflow: coverpoint apb_trans.data[0]{
bins overflow={1'b1};
bins no_overflow={1'b0};
}

tsr_underflow: coverpoint apb_trans.data[1]{
bins underflow={1'b1};
bins no_underflow={1'b0};
}

//TIE 
tie_overflow_en: coverpoint apb_trans.data[0]{
bins overflow_en_off={1'b0};
bins overflow_en_on={1'b1};
}

tie_underflow_en: coverpoint apb_trans.data[1]{
bins underflow_en_off={1'b0};
bins underflow_en_on={1'b1};
}

last_underflow_en_state: coverpoint last_underflow_en{
bins off={1'b0};
bins on={1'b1};
}

last_overflow_en_state: coverpoint last_overflow_en{
bins off={1'b0};
bins on={1'b1};
}

apb_transaction: cross apb_transfer,apb_address;

tcr_write_feature: cross apb_transfer, apb_address, tcr_clk_div, tcr_count, tcr_load, tcr_timer_en{
ignore_bins tcr_write = !binsof(apb_transfer) intersect {packet::WRITE} || !binsof(apb_address) intersect {8'h00};
}

tie_write_feature: cross apb_transfer, apb_address, tie_overflow_en, tie_underflow_en{
ignore_bins tie_write = !binsof(apb_transfer) intersect {packet::WRITE} || !binsof(apb_address) intersect {8'h03};
}

overflow_with_itr_en: cross apb_address,tsr_overflow,last_overflow_en_state{
ignore_bins tsr_read = !binsof(apb_address) intersect {8'h01};
}

underflow_with_itr_en: cross apb_address,tsr_underflow,last_underflow_en_state{
ignore_bins tsr_read = !binsof(apb_address) intersect {8'h01};
}
endgroup

