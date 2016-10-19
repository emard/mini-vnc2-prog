module vnc2prog
(
  input  AP,   // TXEN  (FT232R: SLEEP)
  input  DN,   // TX    (FT232R: TXD) 
  inout  DP,   // RX    (FT232R: RXD) (3-state)
  inout  AN    // DEBUG (REVERSE-U16: X3 DEBUG) (3-state)
);

assign AN = AP ? DN : 1'bZ;
assign DP = AP ? 1'bZ : AN;

endmodule
