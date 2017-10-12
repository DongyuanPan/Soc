`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/09/25 16:43:54
// Design Name: 
// Module Name: IOCtrl
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


module IOCtrl (clk, reset, io_addr, io_read, io_write, mread_data,
              rdata, out_seg, out_sel,count ,pclk);
    input clk,reset;
    input [15:0] mread_data;//д������
    input [9:0] io_addr;//��ַ
    input io_read, io_write;//ʹ��
    
    output [15:0] rdata;//IO������
    output [7:0] out_seg, out_sel;
    output [2:0] count;
    
    wire DISPCtrl;//�����
    wire KEYCtrl;//����
    wire CTTCtrl;//����������ʱ��
    wire PWMCtrl;//pwm�������
    wire UARTCtrl;//UART�첽����ͨ��
    wire WDTCtrl;//���Ź�
    wire LEDCtrl;//led��
    wire SWCtrl;//����
    wire VGACtrl;//VGA
    
    wire [15:0] ioread_data_disp,ioread_data_key,ioread_data_ctc,ioread_data_pwm,ioread_data_uart,
                ioread_data_wdt,ioread_data_led,ioread_data_sw;
    
    IO decode(
        .address(io_addr),
        .e(io_read | io_write),
        .DISPCtrl(DISPCtrl),
        .KEYCtrl(KEYCtrl),
        .CTCCtrl(CTCCtrl),
        .PWMCtrl(PWMCtrl),
        .UARTCtrl(UARTCtrl),
        .WDTCtrl(WDTCtrl),
        .LEDCtrl(LEDCtrl),
        .SWCtrl(SWCtrl),
        .VGACtrl(VGACtrl)
    );   
    
    ioread data_mux (
        .reset(reset),
        .clk(clk),
        .ior(io_read),
        .dispctrl(DISPCtrl),
        .keyctrl(KEYCtrl),
        .ctcctl(CTCCtrl),
        .pwmctrl(PWMCtrl),
        .uartctrl(UARTCtrl),
        .wdtctrl(WDTCtrl),
        .ledctrl(LEDCtrl),
        .switchctrl(SWCtrl),
        .vgactrl(VGACtrl),
        .ioread_data(rdata),
        .ioread_data_disp(ioread_data_disp),
        .ioread_data_key(ioread_data_key),
        .ioread_data_ctc(ioread_data_ctc),
        .ioread_data_pwm(ioread_data_pwm),
        .ioread_data_uart(ioread_data_uart),
        .ioread_data_wdt(ioread_data_wdt),
        .ioread_data_led(ioread_data_led),
        .ioread_data_sw(ioread_data_sw)
    );
   
    //wire pclk;
    output pclk;
    clock_div clock16(
        .clk(clk),
        .clk_sys(pclk)
    );
 
    wire [2:0] count;
    
    DISP disp16(
        .reset(reset),
        .Pclk(pclk),
        .Clock(clk),
        .address(io_addr[3:0]),
        .data(mread_data),
        .cs(DISPCtrl),
        .iow(io_write),
        .seg(out_seg),
        .an(out_sel),
        .count(count)
    );
    
    
endmodule
