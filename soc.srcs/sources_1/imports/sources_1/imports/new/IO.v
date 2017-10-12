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
       
       input[9:0] address;//执行单元的alu_result
       input e;//读写使能
       output DISPCtrl;//数码管
       output KEYCtrl;//键盘
       output CTCCtrl;//计数器、定时器
       output PWMCtrl;//pwm脉冲调制
       output UARTCtrl;//UART异步串行通信
       output WDTCtrl;//看门狗
       output LEDCtrl;//led灯
       output SWCtrl;//开关
       output VGACtrl;//VGA
       
       // OXFFFFFC00 开始
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
