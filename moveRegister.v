module moveRegister(
        input CP,
        input CR_,
        input [1:0] S,
        input Sr,
        input Sl,
        input [7:0] D,
        output reg [7:0]Q
    );
    always @(posedge CP or negedge CR_) begin
        if( !CR_ )begin
            Q <= 8'b00000000;
        end
        else begin
            case (S)
                2'b00: begin
                    Q<=Q;
                end
                2'b01: begin
                    Q[6:0]<=Q[7:1];
                    Q[7]<=Sr;
                end
                2'b10: begin
                    Q[7:1]<=Q[6:0];
                    Q[0]<=Sl;
                end
                2'b11: begin
                    Q<=D;
                end
            endcase
        end
    end
endmodule
