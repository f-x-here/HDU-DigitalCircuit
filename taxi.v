module Taxi(
    input wire start,
    input wire CLR,
    input wire clk,
    input wire waiting,
    input [1:0]speedup,
    input pause=0, //为0行驶，为1暂停
    output [7:0]seg,
    output wire enable,//L21
);
wire [15:0]dataPrice;
wire [15:0]dataDistance;
reg [31:0]waittingTime;
wire which[2:0];
wire error = 1;
assign enable = ~pause & error;
always @(posedge start)begin
    dataPrice = 60;
    dataDistance = 0;
    waittingTime = 0;
end

endmodule

module Logic(
    input wire clk,
    input reg[31:0]waittingTime,
    input waiting,
    input [1:0]speedup,
    input [3:0]curPrice,
    input [3:0]curDisatance,
    output [3:0]nextPrice,
    output [3:0]nextDistance,
    input [31:0]count,
    input pause,
);
always @(posedge cls)begin
    if(count == 2000000)begin
        if(!waiting)begin
            case(speedup):
                2b'00:nextDistance = curDisatance + 1;
                2b'01:nextDistance = curDisatance + 2;
                2b'10:nextDistance = curDisatance + 4;
                2b'11:nextDistance = curDisatance + 6;               
            endcase
        end
        else begin
            waittingTime=waittingTime+1;
        end
        if(curDistance<=30)begin
            nextPrice=30;
        end
        else if(curPrice<=200)begin
            nextPrice = 
        end 
    end
end
endmodule

module Display(
    input wire [2:0]which,
    input wire [15:0]dataPrice,
    input wire [15:0]dataDistance,
    output reg [7:0]seg
);
reg digit[7:0];
always @(*) case(which):
    3b'000: digit <= dataPrice[15:12]
    3b'001: digit <= dataPrice[11:8]
    3b'010: digit <= dataPrice[7:4]
    3b'011: digit <= dataPrice[3:0]
    3b'100: digit <= dataDistance[15:12]
    3b'101: digit <= dataDistance[11:8]
    3b'110: digit <= dataDistance[7:4]
    3b'111: digit <= dataDistance[3:0]
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

module SelectLight(
    output reg [2:0]which,
    input clk,
    output reg [31:0]count=0
);
always @(posedge clk)if(~pause)count <= count+1;
always @(negedge clk)begin
if(~pause and count == 2000000)begin
    which <= which+1;
    count = 0;
    end
end
endmodule;