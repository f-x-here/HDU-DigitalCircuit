module Head(
    input wire clk,//H4
    input wire [1:0] sw,//T3 U3
    output [2:0] which,//(0 N22) (1 M21) (2 M22)
    output [7:0] seg,//(7 H19)(6 G20)(5 J22)(4 K22)(3 K21)(2 H20)(1 H22)(0 J21)
    output reg enable = 1//L21
);
[31:0] data;
ChooseData chooseData(.sw(sw),.data(data),.enable(enable));
SelectLight selectLight(.clk(clk),.which(which));
Display display(.data(data),.which(which),.seg(seg));
endmodule

module SelectLight(
    output reg [2:0]which,
    input clk
);
reg [31:0]count=0;
always @(posedge clk)count <= count+1b'1;
always @(negedge clk)begin
    if(count == 20000000)begin
        which <= which+1b'1;
        count = 0;
    end
end
endmodule;

module ChooseData(
    input [1:0] sw,
    output reg [31:0] data,
    output enable
);
always @(*) begin
    case (sw):
    2'b00: begin
        enable = 0;
        data <= 32'h0000_0000;
    end;
    2'b01: begin
        enable = 1;
        data <= 32'h89ab_cdef;
    end
    2'b10: begin
        enable = 1;
        data <= 32'habcd_0234;
    end
    2'b11: begin
        enable = 1;
        data <= 32'hefab_2cab;
    end
    endcase
end
endmodule

module Display(
    input wire [31:0]data,
    input wire [2:0]which,
    output reg [7:0]seg
);
reg digit[3:0];
always @(*) case(which):
    3b'000: digit <= data[31:28]
    3b'001: digit <= data[27:24]
    3b'010: digit <= data[23:20]
    3b'011: digit <= data[19:16]
    3b'100: digit <= data[15:12]
    3b'101: digit <= data[11:8]
    3b'110: digit <= data[7:4]
    3b'111: digit <= data[3:0]
endcase

always @(*) case(digit):
    4'h0: seg <= 8'b0000_0011;
    4'h1: seg <= 8'b1001_1111;
    4'h2: seg <= 8'b0010_0101;
    4'h3: seg <= 8'b0000_1101;
    4'h4: seg <= 8'b1001_1001;
    4'h5: seg <= 8'b0100_1001;
    4'h6: seg <= 8'b0100_0001;
    4'h7: seg <= 8'b0001_1111;
    4'h8: seg <= 8'b0000_0001;
    4'h9: seg <= 8'b0000_1001;
    4'hA: seg <= 8'b0001_0001;
    4'hB: seg <= 8'b1100_0001;
    4'hC: seg <= 8'b0110_0011;
    4'hD: seg <= 8'b1000_0101;
    4'hE: seg <= 8'b0110_0001;
    4'hF: seg <= 8'b0111_0001;
endcase
endmodule