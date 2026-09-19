// tb.v
// Self-checking testbench for Task 5 (alu.v)

`timescale 1ns/1ps

module tb;

  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;
  wire [3:0] t_result;

  // Instantiate the ALU
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer errors;
  reg [3:0] exp_result;
  integer i, j;

  initial begin
    errors = 0;

    // -------------------------------------------------------------
    // Test 1: Sensitivity list check (Hold operands, toggle op)
    // -------------------------------------------------------------
    t_a = 4'd5;
    t_b = 4'd2;
    t_op = 1'b0; // 5 + 2 = 7
    #5;
    if (t_result !== 4'd7) begin
      $display("FAIL [Sensitivity Test 1]: a=%0d, b=%0d, op=%0d | got %0d, expected 7",
               t_a, t_b, t_op, t_result);
      errors = errors + 1;
    end

    // Toggle op WITHOUT changing a or b
    t_op = 1'b1; // 5 - 2 = 3
    #5;
    if (t_result !== 4'd3) begin
      $display("FAIL [Sensitivity Test 2 - op toggle]: a=%0d, b=%0d, op=%0d | got %0d, expected 3",
               t_a, t_b, t_op, t_result);
      errors = errors + 1;
    end

    // -------------------------------------------------------------
    // Test 2: Full Sweep over sample combinations
    // -------------------------------------------------------------
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i[3:0];
        t_b = j[3:0];

        // Check addition (op = 0)
        t_op = 1'b0;
        #5;
        exp_result = (t_a + t_b) & 4'hF;
        if (t_result !== exp_result) begin
          $display("FAIL [ADD]: a=%0d b=%0d | got %0d, expected %0d",
                   t_a, t_b, t_result, exp_result);
          errors = errors + 1;
        end

        // Check subtraction (op = 1)
        t_op = 1'b1;
        #5;
        exp_result = (t_a - t_b) & 4'hF;
        if (t_result !== exp_result) begin
          $display("FAIL [SUB]: a=%0d b=%0d | got %0d, expected %0d",
                   t_a, t_b, t_result, exp_result);
          errors = errors + 1;
        end
      end
    end

    // -------------------------------------------------------------
    // Summary
    // -------------------------------------------------------------
    if (errors == 0)
      $display("\n>>> ALL TESTS PASSED SUCCESSFULLY! <<<\n");
    else
      $display("\n>>> TEST SUITE FAILED WITH %0d ERRORS <<<\n", errors);

    $finish;
  end

endmodule