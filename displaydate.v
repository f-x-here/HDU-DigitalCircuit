module Head(
    input wire clk,//H4
    input wire [1:0] sw,//T3 U3
    output [2:0] which,//(0 N22) (1 M21) (2 M22)
    output [7:0] seg,//(7 H19)(6 G20)(5 J22)(4 K22)(3 K21)(2 H20)(1 H22)(0 J21)
    output wire enable//L21
);
wire [31:0] data;
wire [31:0] curdate;
ChooseData chooseData(.clk(clk),.sw(sw),.data(data),.enable(enable));
SelectLight selectLight(.clk(clk),.which(which));
Display display(.data(data),.which(which),.seg(seg));
endmodule

module SelectLight(
    output reg [2:0]which,
    input clk
);
reg [31:0]count=0;  
always @(posedge clk)count <= (count>2000? 32'b0 : count+1);
always @(negedge clk)begin
    if(count == 2000)begin
        which <= which+1;
    end
end
endmodule;

module ChooseData(
    input clk,
    input [1:0] sw,
    input wire [31:0] curdate,
    output reg [31:0] data= 32'h2024_1204,
    output reg enable=1
);

reg [31:0]count=0;  
always @(posedge clk) begin
    count <= (count>20000000? 32'b0 : count+1);
    if(count == 20000000)begin
        if(data[7:0]<30)begin
            data <= data + 1'h1;
        end  
        else if(data[15:8]<12)begin
            data[15:8] <= data[15:8] +1'h1; 
            data[7:0]<=2'h01;
        end
        else begin
            data[31:16]<=data[31:16] + 1'h1;
            data[15:0]<=16'h0101;
        end
    end
end
endmodule

module Display(
    input wire [31:0]data,
    input wire [2:0]which,
    output reg [7:0]seg
);
reg [3:0]digit;
always @(*) case(which)
    3'b000:  digit <= data[31:28];
    3'b001:  digit <= data[27:24];
    3'b010:  digit <= data[23:20];
    3'b011:  digit <= data[19:16];
    3'b100:  digit <= data[15:12];
    3'b101:  digit <= data[11:8];
    3'b110:  digit <= data[7:4];
    3'b111:  digit <= data[3:0];
endcase

always @(*) case(digit)
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