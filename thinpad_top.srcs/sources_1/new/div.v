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
    reg [63:0] remainder_quotient;  // 低32位为被除数/商,高32位为余数
    reg [31:0] divisor;
    reg [5:0] bit;                  // 计数器
    reg [1:0] state;

    localparam IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;

    // 符号处理
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
                            result_sign <= y[31] ^ x[31]; // 结果符号位非阻塞赋值
                            
                            // 将被除数转为正数并放入低32位
                            remainder_quotient <= {32'b0, x[31] ? (~x + 1) : x};
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
                        // 被除数左移2位  尽可能使用拼接而非移位操作
                        if ({2'b0,remainder_quotient[61:30]} >= {2'b0,divisor} + {1'b0,divisor,1'b0}) begin
                            remainder_quotient <= {remainder_quotient[61:30] - divisor - {divisor[30:0],1'b0}, remainder_quotient[29:0], 2'b11};
                        end 
                        else if ({1'b0,remainder_quotient[61:30]} >= {divisor,1'b0}) begin
                            remainder_quotient <= {remainder_quotient[61:30] - {divisor[30:0],1'b0}, remainder_quotient[29:0], 2'b10};
                        end
                        else if (remainder_quotient[61:30] >= divisor) begin
                            remainder_quotient <= {remainder_quotient[61:30] - divisor, remainder_quotient[29:0], 2'b01};
                        end
                        else begin
                            remainder_quotient <= {remainder_quotient[61:30], remainder_quotient[29:0], 2'b00};
                        end
                        bit <= bit - 2;
                        if (bit == 2) begin
                            state <= DONE;
                        end
                    end
                end

                DONE: begin
                    // 处理最终结果的符号
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
