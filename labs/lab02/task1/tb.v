// tb.v
// Testbench for Task 1

`timescale 1ns/1ps

module tb;

  // DUT inputs driven procedurally inside initial block -> reg
  reg   t_i0, t_i1, t_s;
  // DUT output driven continuously by module instance -> wire
  wire  t_y;

  // Instantiate DUT
  DUT uut (
    .I0 (t_i0),
    .I1 (t_i1),
    .S  (t_s),
    .Y  (t_y)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, uut);
    end
  end

  integer i;
  initial begin
    // Apply all 8 combinations of (S, I1, I0) 5 time units apart
    for (i = 0; i < 8; i = i + 1) begin
      {t_s, t_i1, t_i0} = i[2:0];
      #5;
    end
    $finish;
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule