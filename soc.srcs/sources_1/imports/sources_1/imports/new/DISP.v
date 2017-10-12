`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/09/22 22:34:39
// Design Name: 
// Module Name: DISP
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


module DISP(reset,Pclk,Clock,address,data,cs,iow,
            seg, an, count);
    input reset,Pclk,Clock;//��λ�źţ�ϵͳʱ�ӽ��͵�1000HZ ��CPUʱ��ͬ����д
    input [3:0] address;//��4λ���˿ڵ�ַ   8��16λ�˿ڵ�ַ
    input [15:0] data;//д���16λ����
    input cs,iow;//cs Ƭѡ�źţ�iow IOд�ź�
    output reg [7:0] seg;//�������ʾ������
    output reg [7:0] an;//8�����ĸ��������
    
    output reg[2:0] count;//������
    reg[15:0] disp3_0;//�����3~0�ŵļĴ�������ַΪ0XFFFFFC00
    reg[15:0] disp7_4;//�����7~4�ŵļĴ�������ַΪ0XFFFFFC02
    reg[15:0] dispsp;//���������Ĵ�������8λ��ʾ8�������1��ʾ����
                     //��8λΪ8��С���� 1Ϊ�� 
                     
    always @(posedge cs or negedge reset or posedge Clock)
    begin
    if (reset == 0) begin
        disp3_0 <= 16'h0000;
        disp7_4 <= 16'h0000;
        dispsp <= 16'h0000;
    end else if (cs == 1 && iow == 1) begin
        case (address[3:0])
            4'b0000:disp3_0 <= data;
            4'b0010:disp7_4 <= data;
            4'b0100:dispsp <= data;
        endcase
    end
    end
    
    always @(posedge Pclk or negedge reset)
    begin
        //8������������ѭ����8������ܵ���ʾ
        if (reset == 0) begin
            count = 0;
        end else begin
            if(count == 0)
                count <= 7;
            else begin
                count <= count - 3'b1;
            end
        //end
        
        if (count == 0) begin
            case(disp3_0[3:0])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {7'b1111111,~dispsp[8]};
        end else if (count == 1) begin
            case(disp3_0[7:4])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {6'b111111,~dispsp[9],1'b1};            
        end else if (count == 2) begin
            case(disp3_0[11:8])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {5'b11111,~dispsp[10],2'b11};           
        end else if (count == 3) begin
            case(disp3_0[15:12])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {4'b1111,~dispsp[11],3'b111};          
        end else if (count == 4) begin
            case(disp7_4[3:0])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {3'b111,~dispsp[12],4'b1111};      
        end else if (count == 5) begin
            case(disp7_4[7:4])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {2'b11,~dispsp[13],5'b11111};          
        end else if (count == 6) begin
            case(disp7_4[11:8])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {1'b1,~dispsp[14],6'b111111};            
        end else if (count == 7) begin
            case(disp7_4[15:12])
                4'b0000:seg <= 8'b11000000; 
                4'b0001:seg <= 8'b11111001; 
                4'b0010:seg <= 8'b10100100; 
                4'b0011:seg <= 8'b10110000; 
                4'b0100:seg <= 8'b10011001; 
                4'b0101:seg <= 8'b10010010;
                4'b0110:seg <= 8'b10000010; 
                4'b0111:seg <= 8'b11111000; 
                4'b1000:seg <= 8'b10000000; 
                4'b1001:seg <= 8'b10010000; 
                4'b1010:seg <= 8'b10001000; 
                4'b1011:seg <= 8'b10000011; 
                4'b1100:seg <= 8'b11000110; 
                4'b1101:seg <= 8'b10100001; 
                4'b1110:seg <= 8'b10000110; 
                4'b1111:seg <= 8'b10001110; 
                default:seg <= 8'b11111111;                
            endcase
            an <= {~dispsp[15],7'b1111111};       
        end
        end   
    end
         
endmodule
