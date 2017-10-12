`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/09/25 16:20:12
// Design Name: 
// Module Name: IO
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


module IO(address,e,DISPCtrl,KEYCtrl,CTCCtrl,
       PWMCtrl,UARTCtrl,WDTCtrl,LEDCtrl,SWCtrl,VGACtrl);
       
       input[9:0] address;//ִ�е�Ԫ��alu_result
       input e;//��дʹ��
       output DISPCtrl;//�����
       output KEYCtrl;//����
       output CTCCtrl;//����������ʱ��
       output PWMCtrl;//pwm�������
       output UARTCtrl;//UART�첽����ͨ��
       output WDTCtrl;//���Ź�
       output LEDCtrl;//led��
       output SWCtrl;//����
       output VGACtrl;//VGA
       
       // OXFFFFFC00 ��ʼ
       wire ioe = ~address[9] & ~address[8] & e;
       assign DISPCtrl = (ioe&&(address[7:4] == 4'h0));
       assign KEYCtrl = (ioe&&(address[7:4] == 4'h1));
       assign CTCCtrl = (ioe&&(address[7:4] == 4'h2));
       assign PWMCtrl = (ioe&&(address[7:4] == 4'h3));
       assign UARTCtrl = (ioe&&(address[7:4] == 4'h4));
       assign WDTCtrl = (ioe&&(address[7:4] == 4'h5));
       assign LEDCtrl = (ioe&&(address[7:4] == 4'h6));
       assign SWCtrl = (ioe&&(address[7:4] == 4'h7));
       assign VGACtrl = (ioe&&(address[7:4] == 4'h8));    
                  
endmodule
