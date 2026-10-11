module Nb_alu_tb;
    parameter N = 8;
    reg [N-1:0] a;
    reg [N-1:0] b;
    reg [2:0] op;
    wire [N-1:0] result;
    wire cout;
    wire overflow;
    wire zero;
    wire negative;

    Nb_alu #(.N(N)) mut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .cout(cout),
        .overflow(overflow),
        .zero(zero),
        .negative(negative)
    );
    
    integer errors;
    integer seed = 1;
    reg [N-1:0] i, j;
    reg [2:0] k;
    reg [N-1:0] result_check;
    reg cout_check;
    reg overflow_check;
    reg zero_check;
    reg negative_check;

    reg [N-1:0] corners [6:0]; 
    integer ci, cj, ck;

    initial begin

        errors = 0;

        corners [0] = 0;
        corners [1] = 1'b1;
        corners [2] = {1'b0, {(N-1){1'b1}}};
        corners [3] = {(N){1'b1}};
        corners [4] = {1'b1, {(N-1){1'b0}}};
        corners [5] = {(N/2){2'b01}};
        corners [6] = {(N/2){2'b10}};

        for (ci = 0; ci < 7; ci = ci + 1) begin
            for (cj = 0; cj < 7; cj = cj + 1) begin
                for (ck = 0; ck < 8; ck = ck + 1) begin
                    a = corners[ci];
                    b = corners[cj];
                    op = ck;

                    #1;

                    case (op)
                        3'b000: begin
                            result_check = a + b;
                            cout_check = (result_check < a);
                            overflow_check = ((a ^ result_check) & (b ^ result_check) & {1'b1, {(N-1){1'b0}}}) != 0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b001: begin
                            result_check = a - b;
                            cout_check = (a >= b);
                            overflow_check = ((a ^ b) & (a ^ result_check) & {1'b1, {(N-1){1'b0}}}) != 0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b010: begin
                            result_check = a & b;
                            cout_check = 1'b0;
                            overflow_check = 1'b0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b011: begin
                            result_check = a | b;
                            cout_check = 1'b0;
                            overflow_check = 1'b0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b100: begin
                            result_check = a ^ b;
                            cout_check = 1'b0;
                            overflow_check = 1'b0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b101: begin
                            result_check = a << 1;
                            cout_check = a[N-1];
                            overflow_check = 1'b0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b110: begin
                            result_check = a >> 1;
                            cout_check = a[0];
                            overflow_check = 1'b0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                        3'b111: begin
                            result_check = ~a;
                            cout_check = 1'b0;
                            overflow_check = 1'b0;
                            zero_check = (result_check == 0);
                            negative_check = (result_check[N-1] == 1'b1);
                        end
                    endcase

                    if (result !== result_check ||
                        cout !== cout_check ||
                        overflow !== overflow_check ||
                        zero !== zero_check ||
                        negative !== negative_check) begin
                            errors = errors + 1;
                            if (errors <= 10) begin
                                $display ("FAIL op=%b a=%h b=%h | got r=%h c=%b v=%b z=%b n=%b | exp r=%h c=%b v=%b z=%b n=%b",
                                                op, a, b, result, cout, overflow, zero, negative,
                                                result_check, cout_check, overflow_check, zero_check, negative_check);
                            end
                        end
                end
            end
        end
                   
        repeat (1_000_000) begin

        i = {$random(seed), $random(seed)};
        j = {$random(seed), $random(seed)};
        k = $random(seed);

        a = i;
        b = j;
        op = k;

        #1;

        case (op)
            3'b000: begin
                result_check = a + b;
                cout_check = (result_check < a);
                overflow_check = ((a ^ result_check) & (b ^ result_check) & {1'b1, {(N-1){1'b0}}}) != 0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b001: begin
                result_check = a - b;
                cout_check = (a >= b);
                overflow_check = ((a ^ b) & (a ^ result_check) & {1'b1, {(N-1){1'b0}}}) != 0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b010: begin
                result_check = a & b;
                cout_check = 1'b0;
                overflow_check = 1'b0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b011: begin
                result_check = a | b;
                cout_check = 1'b0;
                overflow_check = 1'b0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b100: begin
                result_check = a ^ b;
                cout_check = 1'b0;
                overflow_check = 1'b0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b101: begin
                result_check = a << 1;
                cout_check = a[N-1];
                overflow_check = 1'b0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b110: begin
                result_check = a >> 1;
                cout_check = a[0];
                overflow_check = 1'b0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
            3'b111: begin
                result_check = ~a;
                cout_check = 1'b0;
                overflow_check = 1'b0;
                zero_check = (result_check == 0);
                negative_check = (result_check[N-1] == 1'b1);
            end
        endcase

        if (result !== result_check ||
        cout !== cout_check ||
        overflow !== overflow_check ||
        zero !== zero_check ||
        negative !== negative_check) begin
            errors = errors + 1;
            if (errors <= 10) begin
                $display ("FAIL op=%b a=%h b=%h | got r=%h c=%b v=%b z=%b n=%b | exp r=%h c=%b v=%b z=%b n=%b",
                                 op, a, b, result, cout, overflow, zero, negative,
                                 result_check, cout_check, overflow_check, zero_check, negative_check);
            end
        end
    end
    
    if (errors == 0) 
        $display ("ALL TESTS PASSED");
        else 
        $display ("SOME TESTS FAILED");

        $finish;
    

    end
endmodule