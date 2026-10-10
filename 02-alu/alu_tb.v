module alu_tb ();
reg [7:0] a; // first 8 bit operand
reg [7:0] b; // second 8 bit operand
reg [2:0] op; // operation selector
wire [7:0] result; // result of the ALU operation
wire cout; // carry out flag
wire overflow; // overflow flag
wire zero, negative; // zero and negative flags

alu mut (
    .a(a),
    .b(b),
    .op(op),
    .result(result),
    .cout(cout),
    .overflow(overflow),
    .zero(zero),
    .negative(negative)
); // instantiate the ALU module

integer i, j, k, errors; // loop counters and error counter
reg [7:0] result_check; // expected result for checking
reg overflow_check; // expected overflow flag for checking
reg cout_check; // expected carry out flag for checking
reg zero_check; // expected zero flag for checking
reg negative_check; // expected negative flag for checking

initial begin
    errors = 0; // initialize the error counter
    for (i = 0; i < 256; i = i + 1) begin // loop through all possible values for the first operand
        for (j = 0; j < 256; j = j + 1) begin // loop through all possible values for the second operand
            for (k = 0; k < 8; k = k + 1) begin // loop through all possible operations
                a = i;
                b = j;
                op = k;
                #1; // Wait for the ALU to compute the result

                case (op)
                    3'b000: begin // expected addition operation
                        result_check = a + b;
                        cout_check = (i + j) > 255;
                        overflow_check = ((a ^ result_check) & (b ^ result_check) & 8'h80) != 0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b001: begin // expected subtraction operation
                        result_check = a - b;
                        cout_check = (i >= j);
                        overflow_check = ( (a ^ b) & (a ^ result_check) & 8'h80) != 0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b010: begin // expected bitwise AND operation
                        result_check = a & b;
                        cout_check = 1'b0;
                        overflow_check = 1'b0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b011: begin // expected bitwise OR operation
                        result_check = a | b;
                        cout_check = 1'b0;
                        overflow_check = 1'b0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b100: begin // expected bitwise XOR operation
                        result_check = a ^ b;
                        cout_check = 1'b0;
                        overflow_check = 1'b0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b101: begin // expected left shift by 1 operation
                        result_check = a << 1;
                        cout_check = (a & 8'h80) != 0;
                        overflow_check = 1'b0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b110: begin // expected right shift by 1 operation
                        result_check = a >> 1;
                        cout_check = (a & 8'h01) != 0;
                        overflow_check = 1'b0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                    3'b111: begin // expected bitwise NOT of a operation
                        result_check = ~a;
                        cout_check = 1'b0;
                        overflow_check = 1'b0;
                        zero_check = (result_check == 8'h00);
                        negative_check = (result_check[7] == 1'b1);
                    end
                endcase

                if (result_check !== result || // check real against expected values
                    cout_check !== cout ||
                    overflow_check !== overflow ||
                    zero_check !== zero ||
                    negative_check !== negative) begin
                    errors = errors + 1; // increment errors until over 10
                    if (errors <= 10) begin
                        $display("FAIL op=%b a=%h b=%h | got r=%h c=%b v=%b z=%b n=%b | exp r=%h c=%b v=%b z=%b n=%b",
                                 op, a, b, result, cout, overflow, zero, negative,
                                 result_check, cout_check, overflow_check, zero_check, negative_check);
                    end 
                    end
            end
        end
    end

    if (errors == 0) 
        $display("All tests passed successfully.");
        else
            $display("Some tests failed.");
$finish;
end
endmodule

