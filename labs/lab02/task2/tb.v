// tb.v
// Testbench for Task 2 (lut.v)

`timescale 1ns/1ps

module tb;

  localparam TB_WIDTH = 8;
  localparam TB_DEPTH = 8;
  localparam ADDR_WIDTH = $clog2(TB_DEPTH);

  reg  [ADDR_WIDTH-1:0] t_sel;
  wire [TB_WIDTH-1:0]   t_dout;

  // Instantiate DUT with parameter override
  lut #(
    .WIDTH(TB_WIDTH),
    .DEPTH(TB_DEPTH)
  ) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer k;
  reg [TB_WIDTH-1:0] expected_val;
  integer errors;

  initial begin
    errors = 0;
    t_sel = 0;
    #5;

    // Loop through every valid address
    for (k = 0; k < TB_DEPTH; k = k + 1) begin
      t_sel = k;
      #5; // Wait for combinational output to settle

      expected_val = k * k;
      if (t_dout !== expected_val) begin
        $display("FAIL at time %0t: sel=%0d | got dout=%0d, expected=%0d",
                 $time, t_sel, t_dout, expected_val);
        errors = errors + 1;
      end else begin
        $display("PASS at time %0t: sel=%0d | dout=%0d", $time, t_sel, t_dout);
      end
    end

    #5;
    if (errors == 0)
      $display("\nALL %0d ADDRESS CHECKS PASSED!\n", TB_DEPTH);
    else
      $display("\nTEST FINISHED WITH %0d ERROR(S).\n", errors);

    $finish;
  end

  initial
    $monitor($time, " sel=%b (%0d) | dout=%b (%0d)", t_sel, t_sel, t_dout, t_dout);

endmodule