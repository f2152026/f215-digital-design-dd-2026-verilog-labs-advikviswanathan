// and_beh_before.v
module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*) begin
    // Change #1 to #2 or #3 for parts (b) and (c)
    #1 y = a & b;
  end

endmodule