module alu ( 
    input wire [7:0] a, // first 8 bit operand
    input wire [7:0] b, // second 8 bit operand
    input wire [2:0] op, // operation selector
    output reg [7:0] result, // result of the ALU operation
    output reg cout, // carry out flag
    output reg overflow, // overflow flag
    output wire zero, // zero flag
    output wire negative // negative flag
);
    wire sub = (op == 3'b001); // subtraction flag
    wire [7:0] b_op = sub ? ~b : b; // complement of b if subtraction
    

    always @(*) begin
        cout = 1'b0; // reset carry out flag
        overflow = 1'b0; // reset overflow flag
        case (op)
            3'b000, 3'b001: begin // addition or subtraction
                {cout, result} = a + b_op + sub;
                overflow = ((a[7] == b_op[7]) && (a[7] != result[7]));
            end
            3'b010: result = a & b; // bitwise AND
            3'b011: result = a | b; // bitwise OR
            3'b100: result = a ^ b; // bitwise XOR
            3'b101: begin // left shift by 1
                result = a << 1;
                cout = (a & 8'h80) != 0;
            end
            3'b110: begin // right shift by 1
                result = a >> 1;
                cout = (a & 8'h01) != 0;
            end
            3'b111: result = ~a; // bitwise NOT of a
        endcase
    end
    assign zero = (result == 8'b0); // zero flag
    assign negative = (result[7] == 1'b1); // negative flag
endmodule
    
    
