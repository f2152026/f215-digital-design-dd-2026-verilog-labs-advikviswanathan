// tb.v
// Self-checking testbench for Task 3 (comp2.v)

`timescale 1ns/1ps

module tb;

  reg  [1:0] t_a;
  reg  [1:0] t_b;
  wire       t_gt;
  wire       t_lt;
  wire       t_eq;

  // Instantiate DUT
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i, j;
  integer errors;
  reg exp_gt, exp_lt, exp_eq;

  initial begin
    errors = 0;

    // Test all 16 input combinations (4 values of A x 4 values of B)
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5; // Wait for combinational logic to settle

        // Golden model computed independently
        exp_gt = (t_a > t_b);
        exp_lt = (t_a < t_b);
        exp_eq = (t_a == t_b);

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b (%0d) B=%b (%0d) | got GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_a, t_b, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    // Summary line built with $write and finished with $display
    $write("Summary: %0d passed out of 16 total.", 16 - errors);
    if (errors == 0)
      $display(" ALL TESTS PASSED!");
    else
      $display(" FAILED with %0d errors.", errors);

    $finish;
  end

endmodule