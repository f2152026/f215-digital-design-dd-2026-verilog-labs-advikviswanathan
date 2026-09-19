// and_beh_intra.v
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    // Change #1 to #2 or #3 for parts (b) and (c)
    y = #1 (a & b);
  end

endmodule