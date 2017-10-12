`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/09/20 20:15:10
// Design Name: 
// Module Name: ioread
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


module ioread(reset,clk,ior,dispctrl,keyctrl,ctcctl,pwmctrl,uartctrl,wdtctrl,ledctrl,switchctrl,vgactrl,
        ioread_data,ioread_data_disp,ioread_data_key,ioread_data_ctc,ioread_data_pwm,ioread_data_uart,
        ioread_data_wdt,ioread_data_led,ioread_data_sw);
    input reset,clk;
    input ior,dispctrl,keyctrl,ctcctl,pwmctrl,uartctrl,wdtctrl,ledctrl,switchctrl,vgactrl;
    input [15:0] ioread_data_disp,ioread_data_key,ioread_data_ctc,ioread_data_pwm,ioread_data_uart,
                ioread_data_wdt,ioread_data_led,ioread_data_sw;
    output [15:0] ioread_data;
    
    reg [15:0] ioread_data;
    
    always @* begin //@(negedge clk)
        if(reset == 0)
            ioread_data = 16'hZZZZ;
        else 
        if(ior) begin
            if(dispctrl)
                ioread_data = ioread_data_disp;
            else if (keyctrl)
                ioread_data = ioread_data_key;
            else if (ctcctl)
                ioread_data = ioread_data_ctc;
            else if (pwmctrl)
                ioread_data = ioread_data_pwm;
            else if (uartctrl)
                ioread_data = ioread_data_uart;
            else if (wdtctrl)
                ioread_data = ioread_data_wdt; 
            else if (ledctrl)
                ioread_data = ioread_data_led;
            else if (switchctrl)
                ioread_data = ioread_data_sw;                                                                                                  
        end
    end
endmodule
