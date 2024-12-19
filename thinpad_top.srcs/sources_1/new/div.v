`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 15:50:11
// Design Name: 
// Module Name: div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module div(
    input wire div_clk,            
    input wire resetn,             
    input wire div,                
    input wire [31:0] x,           
    input wire [31:0] y,           
    input wire div_signed,         
    output reg [31:0] s,           
    output reg [31:0] r,           
    output reg complete            
);

    // Internal signals
    reg [63:0] remainder_quotient;  // hige 32 bit is remainder, low 32 bit is quotient
    reg [31:0] divisor;
    reg [5:0] bit;                  // bit count
    reg [1:0] state;

    localparam IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;

    // sign process
    reg dividend_sign;
    reg divisor_sign;
    reg result_sign;
    reg div_signed_reg;
    
    always @(posedge div_clk or posedge resetn) begin
        if (!resetn) begin
            s <= 32'b0;
            r <= 32'b0;
            complete <= 1'b0;
            remainder_quotient <= 64'b0;
            divisor <= 32'b0;
            bit <= 6'b0;
            state <= IDLE;
            div_signed_reg <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            result_sign <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (div && !complete) begin
                        complete <= 1'b0;
                        bit <= 6'd32;
                        s <= 32'b0;
                        r <= 32'b0;
                        div_signed_reg <= div_signed;
                        if (div_signed) begin
                            dividend_sign <= x[31];
                            divisor_sign <= y[31];
                            result_sign <= y[31] ^ x[31]; // result sign non-blocking assignment
                            
                            // convert dividend to positive and put it into low 32 bit
                            remainder_quotient <= {32'b0, x[31] ? (~x + 1) : x};
                            // convert divisor to positive and put it into high 32 bit
                            divisor <= y[31] ? (~y + 1) : y;
                        end else begin
                            remainder_quotient <= {32'b0, x};
                            divisor <= y;
                        end
                        state <= DIVIDE;
                    end
                end

                DIVIDE: begin
                    if (bit > 0) begin
                        // dividend left shift 4 bit, use concat instead of shift operation
                        
                        if({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd255) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd255, remainder_quotient[23:0], 8'd255};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd254) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd254, remainder_quotient[23:0], 8'd254};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd253) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd253, remainder_quotient[23:0], 8'd253};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd252) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd252, remainder_quotient[23:0], 8'd252};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd251) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd251, remainder_quotient[23:0], 8'd251};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd250) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd250, remainder_quotient[23:0], 8'd250};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd249) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd249, remainder_quotient[23:0], 8'd249};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd248) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd248, remainder_quotient[23:0], 8'd248};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd247) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd247, remainder_quotient[23:0], 8'd247};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd246) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd246, remainder_quotient[23:0], 8'd246};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd245) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd245, remainder_quotient[23:0], 8'd245};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd244) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd244, remainder_quotient[23:0], 8'd244};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd243) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd243, remainder_quotient[23:0], 8'd243};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd242) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd242, remainder_quotient[23:0], 8'd242};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd241) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd241, remainder_quotient[23:0], 8'd241};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd240) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd240, remainder_quotient[23:0], 8'd240};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd239) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd239, remainder_quotient[23:0], 8'd239};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd238) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd238, remainder_quotient[23:0], 8'd238};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd237) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd237, remainder_quotient[23:0], 8'd237};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd236) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd236, remainder_quotient[23:0], 8'd236};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd235) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd235, remainder_quotient[23:0], 8'd235};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd234) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd234, remainder_quotient[23:0], 8'd234};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd233) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd233, remainder_quotient[23:0], 8'd233};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd232) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd232, remainder_quotient[23:0], 8'd232};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd231) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd231, remainder_quotient[23:0], 8'd231};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd230) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd230, remainder_quotient[23:0], 8'd230};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd229) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd229, remainder_quotient[23:0], 8'd229};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd228) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd228, remainder_quotient[23:0], 8'd228};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd227) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd227, remainder_quotient[23:0], 8'd227};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd226) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd226, remainder_quotient[23:0], 8'd226};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd225) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd225, remainder_quotient[23:0], 8'd225};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd224) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd224, remainder_quotient[23:0], 8'd224};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd223) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd223, remainder_quotient[23:0], 8'd223};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd222) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd222, remainder_quotient[23:0], 8'd222};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd221) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd221, remainder_quotient[23:0], 8'd221};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd220) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd220, remainder_quotient[23:0], 8'd220};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd219) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd219, remainder_quotient[23:0], 8'd219};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd218) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd218, remainder_quotient[23:0], 8'd218};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd217) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd217, remainder_quotient[23:0], 8'd217};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd216) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd216, remainder_quotient[23:0], 8'd216};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd215) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd215, remainder_quotient[23:0], 8'd215};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd214) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd214, remainder_quotient[23:0], 8'd214};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd213) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd213, remainder_quotient[23:0], 8'd213};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd212) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd212, remainder_quotient[23:0], 8'd212};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd211) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd211, remainder_quotient[23:0], 8'd211};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd210) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd210, remainder_quotient[23:0], 8'd210};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd209) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd209, remainder_quotient[23:0], 8'd209};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd208) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd208, remainder_quotient[23:0], 8'd208};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd207) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd207, remainder_quotient[23:0], 8'd207};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd206) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd206, remainder_quotient[23:0], 8'd206};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd205) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd205, remainder_quotient[23:0], 8'd205};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd204) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd204, remainder_quotient[23:0], 8'd204};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd203) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd203, remainder_quotient[23:0], 8'd203};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd202) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd202, remainder_quotient[23:0], 8'd202};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd201) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd201, remainder_quotient[23:0], 8'd201};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd200) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd200, remainder_quotient[23:0], 8'd200};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd199) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd199, remainder_quotient[23:0], 8'd199};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd198) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd198, remainder_quotient[23:0], 8'd198};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd197) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd197, remainder_quotient[23:0], 8'd197};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd196) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd196, remainder_quotient[23:0], 8'd196};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd195) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd195, remainder_quotient[23:0], 8'd195};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd194) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd194, remainder_quotient[23:0], 8'd194};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd193) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd193, remainder_quotient[23:0], 8'd193};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd192) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd192, remainder_quotient[23:0], 8'd192};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd191) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd191, remainder_quotient[23:0], 8'd191};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd190) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd190, remainder_quotient[23:0], 8'd190};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd189) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd189, remainder_quotient[23:0], 8'd189};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd188) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd188, remainder_quotient[23:0], 8'd188};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd187) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd187, remainder_quotient[23:0], 8'd187};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd186) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd186, remainder_quotient[23:0], 8'd186};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd185) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd185, remainder_quotient[23:0], 8'd185};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd184) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd184, remainder_quotient[23:0], 8'd184};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd183) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd183, remainder_quotient[23:0], 8'd183};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd182) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd182, remainder_quotient[23:0], 8'd182};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd181) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd181, remainder_quotient[23:0], 8'd181};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd180) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd180, remainder_quotient[23:0], 8'd180};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd179) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd179, remainder_quotient[23:0], 8'd179};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd178) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd178, remainder_quotient[23:0], 8'd178};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd177) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd177, remainder_quotient[23:0], 8'd177};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd176) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd176, remainder_quotient[23:0], 8'd176};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd175) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd175, remainder_quotient[23:0], 8'd175};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd174) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd174, remainder_quotient[23:0], 8'd174};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd173) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd173, remainder_quotient[23:0], 8'd173};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd172) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd172, remainder_quotient[23:0], 8'd172};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd171) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd171, remainder_quotient[23:0], 8'd171};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd170) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd170, remainder_quotient[23:0], 8'd170};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd169) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd169, remainder_quotient[23:0], 8'd169};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd168) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd168, remainder_quotient[23:0], 8'd168};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd167) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd167, remainder_quotient[23:0], 8'd167};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd166) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd166, remainder_quotient[23:0], 8'd166};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd165) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd165, remainder_quotient[23:0], 8'd165};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd164) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd164, remainder_quotient[23:0], 8'd164};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd163) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd163, remainder_quotient[23:0], 8'd163};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd162) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd162, remainder_quotient[23:0], 8'd162};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd161) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd161, remainder_quotient[23:0], 8'd161};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd160) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd160, remainder_quotient[23:0], 8'd160};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd159) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd159, remainder_quotient[23:0], 8'd159};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd158) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd158, remainder_quotient[23:0], 8'd158};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd157) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd157, remainder_quotient[23:0], 8'd157};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd156) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd156, remainder_quotient[23:0], 8'd156};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd155) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd155, remainder_quotient[23:0], 8'd155};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd154) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd154, remainder_quotient[23:0], 8'd154};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd153) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd153, remainder_quotient[23:0], 8'd153};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd152) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd152, remainder_quotient[23:0], 8'd152};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd151) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd151, remainder_quotient[23:0], 8'd151};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd150) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd150, remainder_quotient[23:0], 8'd150};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd149) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd149, remainder_quotient[23:0], 8'd149};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd148) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd148, remainder_quotient[23:0], 8'd148};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd147) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd147, remainder_quotient[23:0], 8'd147};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd146) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd146, remainder_quotient[23:0], 8'd146};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd145) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd145, remainder_quotient[23:0], 8'd145};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd144) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd144, remainder_quotient[23:0], 8'd144};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd143) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd143, remainder_quotient[23:0], 8'd143};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd142) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd142, remainder_quotient[23:0], 8'd142};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd141) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd141, remainder_quotient[23:0], 8'd141};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd140) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd140, remainder_quotient[23:0], 8'd140};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd139) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd139, remainder_quotient[23:0], 8'd139};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd138) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd138, remainder_quotient[23:0], 8'd138};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd137) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd137, remainder_quotient[23:0], 8'd137};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd136) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd136, remainder_quotient[23:0], 8'd136};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd135) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd135, remainder_quotient[23:0], 8'd135};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd134) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd134, remainder_quotient[23:0], 8'd134};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd133) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd133, remainder_quotient[23:0], 8'd133};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd132) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd132, remainder_quotient[23:0], 8'd132};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd131) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd131, remainder_quotient[23:0], 8'd131};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd130) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd130, remainder_quotient[23:0], 8'd130};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd129) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd129, remainder_quotient[23:0], 8'd129};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd128) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd128, remainder_quotient[23:0], 8'd128};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd127) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd127, remainder_quotient[23:0], 8'd127};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd126) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd126, remainder_quotient[23:0], 8'd126};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd125) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd125, remainder_quotient[23:0], 8'd125};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd124) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd124, remainder_quotient[23:0], 8'd124};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd123) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd123, remainder_quotient[23:0], 8'd123};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd122) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd122, remainder_quotient[23:0], 8'd122};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd121) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd121, remainder_quotient[23:0], 8'd121};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd120) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd120, remainder_quotient[23:0], 8'd120};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd119) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd119, remainder_quotient[23:0], 8'd119};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd118) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd118, remainder_quotient[23:0], 8'd118};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd117) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd117, remainder_quotient[23:0], 8'd117};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd116) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd116, remainder_quotient[23:0], 8'd116};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd115) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd115, remainder_quotient[23:0], 8'd115};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd114) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd114, remainder_quotient[23:0], 8'd114};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd113) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd113, remainder_quotient[23:0], 8'd113};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd112) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd112, remainder_quotient[23:0], 8'd112};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd111) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd111, remainder_quotient[23:0], 8'd111};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd110) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd110, remainder_quotient[23:0], 8'd110};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd109) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd109, remainder_quotient[23:0], 8'd109};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd108) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd108, remainder_quotient[23:0], 8'd108};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd107) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd107, remainder_quotient[23:0], 8'd107};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd106) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd106, remainder_quotient[23:0], 8'd106};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd105) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd105, remainder_quotient[23:0], 8'd105};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd104) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd104, remainder_quotient[23:0], 8'd104};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd103) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd103, remainder_quotient[23:0], 8'd103};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd102) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd102, remainder_quotient[23:0], 8'd102};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd101) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd101, remainder_quotient[23:0], 8'd101};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd100) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd100, remainder_quotient[23:0], 8'd100};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd99) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd99, remainder_quotient[23:0], 8'd99};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd98) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd98, remainder_quotient[23:0], 8'd98};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd97) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd97, remainder_quotient[23:0], 8'd97};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd96) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd96, remainder_quotient[23:0], 8'd96};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd95) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd95, remainder_quotient[23:0], 8'd95};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd94) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd94, remainder_quotient[23:0], 8'd94};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd93) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd93, remainder_quotient[23:0], 8'd93};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd92) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd92, remainder_quotient[23:0], 8'd92};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd91) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd91, remainder_quotient[23:0], 8'd91};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd90) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd90, remainder_quotient[23:0], 8'd90};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd89) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd89, remainder_quotient[23:0], 8'd89};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd88) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd88, remainder_quotient[23:0], 8'd88};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd87) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd87, remainder_quotient[23:0], 8'd87};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd86) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd86, remainder_quotient[23:0], 8'd86};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd85) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd85, remainder_quotient[23:0], 8'd85};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd84) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd84, remainder_quotient[23:0], 8'd84};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd83) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd83, remainder_quotient[23:0], 8'd83};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd82) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd82, remainder_quotient[23:0], 8'd82};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd81) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd81, remainder_quotient[23:0], 8'd81};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd80) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd80, remainder_quotient[23:0], 8'd80};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd79) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd79, remainder_quotient[23:0], 8'd79};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd78) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd78, remainder_quotient[23:0], 8'd78};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd77) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd77, remainder_quotient[23:0], 8'd77};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd76) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd76, remainder_quotient[23:0], 8'd76};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd75) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd75, remainder_quotient[23:0], 8'd75};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd74) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd74, remainder_quotient[23:0], 8'd74};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd73) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd73, remainder_quotient[23:0], 8'd73};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd72) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd72, remainder_quotient[23:0], 8'd72};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd71) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd71, remainder_quotient[23:0], 8'd71};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd70) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd70, remainder_quotient[23:0], 8'd70};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd69) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd69, remainder_quotient[23:0], 8'd69};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd68) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd68, remainder_quotient[23:0], 8'd68};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd67) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd67, remainder_quotient[23:0], 8'd67};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd66) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd66, remainder_quotient[23:0], 8'd66};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd65) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd65, remainder_quotient[23:0], 8'd65};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd64) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd64, remainder_quotient[23:0], 8'd64};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd63) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd63, remainder_quotient[23:0], 8'd63};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd62) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd62, remainder_quotient[23:0], 8'd62};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd61) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd61, remainder_quotient[23:0], 8'd61};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd60) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd60, remainder_quotient[23:0], 8'd60};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd59) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd59, remainder_quotient[23:0], 8'd59};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd58) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd58, remainder_quotient[23:0], 8'd58};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd57) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd57, remainder_quotient[23:0], 8'd57};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd56) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd56, remainder_quotient[23:0], 8'd56};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd55) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd55, remainder_quotient[23:0], 8'd55};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd54) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd54, remainder_quotient[23:0], 8'd54};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd53) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd53, remainder_quotient[23:0], 8'd53};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd52) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd52, remainder_quotient[23:0], 8'd52};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd51) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd51, remainder_quotient[23:0], 8'd51};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd50) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd50, remainder_quotient[23:0], 8'd50};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd49) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd49, remainder_quotient[23:0], 8'd49};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd48) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd48, remainder_quotient[23:0], 8'd48};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd47) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd47, remainder_quotient[23:0], 8'd47};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd46) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd46, remainder_quotient[23:0], 8'd46};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd45) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd45, remainder_quotient[23:0], 8'd45};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd44) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd44, remainder_quotient[23:0], 8'd44};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd43) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd43, remainder_quotient[23:0], 8'd43};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd42) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd42, remainder_quotient[23:0], 8'd42};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd41) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd41, remainder_quotient[23:0], 8'd41};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd40) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd40, remainder_quotient[23:0], 8'd40};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd39) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd39, remainder_quotient[23:0], 8'd39};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd38) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd38, remainder_quotient[23:0], 8'd38};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd37) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd37, remainder_quotient[23:0], 8'd37};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd36) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd36, remainder_quotient[23:0], 8'd36};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd35) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd35, remainder_quotient[23:0], 8'd35};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd34) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd34, remainder_quotient[23:0], 8'd34};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd33) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd33, remainder_quotient[23:0], 8'd33};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd32) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd32, remainder_quotient[23:0], 8'd32};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd31) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd31, remainder_quotient[23:0], 8'd31};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd30) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd30, remainder_quotient[23:0], 8'd30};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd29) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd29, remainder_quotient[23:0], 8'd29};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd28) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd28, remainder_quotient[23:0], 8'd28};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd27) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd27, remainder_quotient[23:0], 8'd27};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd26) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd26, remainder_quotient[23:0], 8'd26};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd25) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd25, remainder_quotient[23:0], 8'd25};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd24) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd24, remainder_quotient[23:0], 8'd24};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd23) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd23, remainder_quotient[23:0], 8'd23};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd22) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd22, remainder_quotient[23:0], 8'd22};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd21) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd21, remainder_quotient[23:0], 8'd21};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd20) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd20, remainder_quotient[23:0], 8'd20};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd19) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd19, remainder_quotient[23:0], 8'd19};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd18) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd18, remainder_quotient[23:0], 8'd18};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd17) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd17, remainder_quotient[23:0], 8'd17};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd16) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd16, remainder_quotient[23:0], 8'd16};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd15) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd15, remainder_quotient[23:0], 8'd15};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd14) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd14, remainder_quotient[23:0], 8'd14};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd13) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd13, remainder_quotient[23:0], 8'd13};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd12) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd12, remainder_quotient[23:0], 8'd12};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd11) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd11, remainder_quotient[23:0], 8'd11};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd10) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd10, remainder_quotient[23:0], 8'd10};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd9) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd9, remainder_quotient[23:0], 8'd9};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd8) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd8, remainder_quotient[23:0], 8'd8};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd7) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd7, remainder_quotient[23:0], 8'd7};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd6) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd6, remainder_quotient[23:0], 8'd6};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd5) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd5, remainder_quotient[23:0], 8'd5};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd4) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd4, remainder_quotient[23:0], 8'd4};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd3) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd3, remainder_quotient[23:0], 8'd3};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd2) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd2, remainder_quotient[23:0], 8'd2};
                        end else if ({8'b0, remainder_quotient[55:24]} >= {8'b0, divisor}*8'd1) begin
                            remainder_quotient <= {remainder_quotient[55:24] - divisor*8'd1, remainder_quotient[23:0], 8'd1};
                        end else begin
                            remainder_quotient <= {remainder_quotient[55:24], remainder_quotient[23:0], 8'd0};
                        end
                        
                        bit <= bit - 8;
                        if (bit == 8) begin
                            state <= DONE;
                        end
                    end
                end

                DONE: begin
                    // process final result sign
                    if (div_signed_reg) begin
                        s <= result_sign ? (~remainder_quotient[31:0] + 1) : remainder_quotient[31:0];
                        r <= dividend_sign ? (~remainder_quotient[63:32] + 1) : remainder_quotient[63:32];
                    end else begin
                        s <= remainder_quotient[31:0];
                        r <= remainder_quotient[63:32];
                    end
                    complete <= 1'b1;
                    state <= IDLE;
                    // bit <= 6'd0;
                    // divisor <= 32'b0;
                    // remainder_quotient <= 64'b0;    
                end

            endcase
            if (complete) begin
                complete <= 1'b0;
            end
        end
    end
endmodule
