/*-------------------------------------------------------------------------------
## LEO_V1.0 CPLD Verilog Source Code
## Chip: Lattice ispMACH4128V
## Package: TQFP144 
## Author: Jerry Yu
## Date: 2007-03-19
## Revsion: 1.0
## Description: First Version
## Creat by: Lattice ispLEVER
## Compile By: Lattice ispLEVER
## Ingenic Semiconductor Corp. 
## System Technology Dept.
---------------------------------------------------------------------------------*/

module LEO(
	//system
	BOOT_SEL0,BOOT_SEL1,BOOT_SEL2,BOOT_SEL3,RESET,

	//emi
	CS1_N,CS2_N,CS3_N,CS4_N,NOR_CS_N,ROM_CS_N,CPLD_CS0,CPLD_CS1,CPLD_CS2,
	N_CS1_N,N_CS2_N,N_CS3_N,N_CS4_N,FRB1_N,FRB2_N,FRB3_N,FRB4_N,
	FRE_N,FWE_N,FRB_N,BRD_N,BWE_N,BEN_N,
	ADDR,DATA,

	//lcd
	DISP_OFF_N,LCD_PWM, 

	//sd&mmc card
	SD_CD_N,SD_WP_N,SD_VCC_3V_EN_N,

	//uart
	JZUART_TXD,JZUART_RXD,IR_RXD,IR_TXD,//JZUART_CTS_N,JZUART_RTS_N,JZ_TDI,JZ_TDO,

	//cpld
	CPLD_T1,CPLD_T2,CPLD_LED1,CPLD_LED2,

	//other
	UART_CS_N,UART_INT,RTL8019_CS_N,RTL8019_INT,//PENIRQ_N,USB_OVCR,KEY_WR,KEY_RD_N,
	PWM2,PWM3,PWM6,PWM7,

	//cim
	GPD0,GPD1,GPD2,GPD3,GPD4,GPD5,GPD6,GPD7,GPD14,GPD15,GPD17,//GPD16,

	//digital led
	LED_1A,LED_1B,LED_1C,LED_1D,LED_1E,LED_1F,LED_1G,
	LED_2A,LED_2B,LED_2C,LED_2D,LED_2E,LED_2F,LED_2G);

//system
//   input		RESETP_N;
   input		BOOT_SEL0,BOOT_SEL1,BOOT_SEL2,BOOT_SEL3;
   output		RESET;
//emi
   input		CS1_N,CS2_N,CS3_N,CS4_N;
   input   [7:0]	DATA;
   input   [22:17]	ADDR;
   input		BRD_N,BWE_N;
   input		FRE_N,FWE_N,FRB1_N,FRB2_N,FRB3_N,FRB4_N;
   output		FRB_N;
   output 		ROM_CS_N,NOR_CS_N;
   output		N_CS1_N,N_CS2_N,N_CS3_N,N_CS4_N;
   output		BEN_N;
   output		CPLD_CS0,CPLD_CS1,CPLD_CS2;

//cpld
   output		CPLD_T1,CPLD_T2,CPLD_LED1,CPLD_LED2;

//lcd
   output		DISP_OFF_N,LCD_PWM;

//mmc&sd card signal
   input  		SD_CD_N,SD_WP_N;
   output		SD_VCC_3V_EN_N;

//uart
   input		JZUART_RXD,IR_RXD,PWM2,PWM6,PWM7;//JZ_TDO,
   output		JZUART_TXD,IR_TXD,PWM3;//JZ_TDI,

//other
   input		UART_INT,RTL8019_INT;
   output		UART_CS_N,RTL8019_CS_N;//KEY_WR,KEY_RD_N;

//cim
   input		GPD0,GPD1,GPD2,GPD3,GPD4,GPD5,GPD6;
   output		GPD14,GPD15,GPD17,GPD7;//GPD16,

//led
   output		LED_1A,LED_1B,LED_1C,LED_1D,LED_1E,LED_1F,LED_1G;
   output		LED_2A,LED_2B,LED_2C,LED_2D,LED_2E,LED_2F,LED_2G;



//The definition of variables

//system
   assign		RESET=GPD6;

//emi
   wire			FLASH_CS_N=CS3_N | ADDR[22] | ADDR[21];
   assign		ROM_CS_N=BOOT_SEL3 ? FLASH_CS_N : CS4_N;
   assign		NOR_CS_N=BOOT_SEL3 ? CS4_N : FLASH_CS_N;
   assign		N_CS1_N=CS1_N;
   assign		N_CS2_N=CS2_N;
   assign		BEN_N=CS3_N & CS4_N & FRE_N & FWE_N;
   assign		FRB_N=FRB1_N & FRB2_N;

//lcd
   assign		DISP_OFF_N=GPD4;
   assign		LCD_PWM=GPD4;
//   assign		LCD_GP1=GP101;
//   assign		LCD_GP2=GP102;

//cpld
   assign		CPLD_LED1=PWM6;//GPD30
   assign		CPLD_LED2=PWM7;//GPD31

//sd&mmc card
   assign		GPD14=SD_CD_N;
   assign		GPD15=SD_WP_N;
   assign		SD_VCC_3V_EN_N=GPD5;

//uart
   assign		PWM3=JZUART_RXD;
   assign		JZUART_TXD=PWM2;

//other
//   assign		KEY_WR=!(CS3_N|BWE_N|ADDR[22]|!ADDR[21]);
//   assign		KEY_RD_N=(CS3_N|BRD_N|ADDR[22]|!ADDR[21]);
   assign		UART_CS_N=CS3_N | !ADDR[22] | ADDR[21];
   assign		RTL8019_CS_N=CS3_N | !ADDR[22] | !ADDR[21];
   assign		GPD7=UART_INT;
   assign		GPD17=RTL8019_INT;


//digital led
reg	[7:0]	led={8{'b0}};
wire		led_en;
assign		led_en =!(CS3_N | BWE_N | ADDR[22] | !ADDR[21]);

always@ (led_en or DATA)
	begin
	if (led_en) begin
		led = {DATA[7],DATA[6],DATA[5],DATA[4],DATA[3],DATA[2],DATA[1],DATA[0]}; end
	end

assign	LED_1A=!((led[0]&led[1]&!led[2]&led[3])|(led[0]&!led[1]&led[2]&led[3])|(led[0]&!led[1]&!led[2]&!led[3])|(!led[0]&!led[1]&led[2]&!led[3]));
assign	LED_1B=!((led[0]&led[1]&led[3])|(led[0]&!led[1]&led[2]&!led[3])|(!led[0]&led[1]&led[2])|(!led[0]&led[2]&led[3]));
assign	LED_1C=!((led[1]&led[2]&led[3])|(!led[0]&led[1]&!led[2]&!led[3])|(!led[0]&led[2]&led[3]));
assign	LED_1D=!((led[0]&led[1]&led[2])|(led[0]&!led[1]&!led[2]&!led[3])|(!led[0]&led[1]&!led[2]&led[3])|(!led[0]&!led[1]&led[2]&!led[3]));
assign	LED_1E=!((led[0]&!led[3])|(!led[1]&led[2]&!led[3])|(led[0]&!led[1]&!led[2]));
assign	LED_1F=!((led[0]&led[1]&!led[3])|(led[1]&!led[2]&!led[3])|(led[0]&!led[1]&led[2]&led[3])|(led[0]&!led[2]&!led[3]));
assign	LED_1G=!((led[0]&led[1]&led[2]&!led[3])|(!led[1]&!led[2]&!led[3])|(!led[0]&!led[1]&led[2]&led[3]));

assign	LED_2A=!((led[4]&led[5]&!led[6]&led[7])|(led[4]&!led[5]&led[6]&led[7])|(led[4]&!led[5]&!led[6]&!led[7])|(!led[4]&!led[5]&led[6]&!led[7]));
assign	LED_2B=!((led[4]&led[5]&led[7])|(led[4]&!led[5]&led[6]&!led[7])|(!led[4]&led[5]&led[6])|(!led[4]&led[6]&led[7]));
assign	LED_2C=!((led[5]&led[6]&led[7])|(!led[4]&led[5]&!led[6]&!led[7])|(!led[4]&led[6]&led[7]));
assign	LED_2D=!((led[4]&led[5]&led[6])|(led[4]&!led[5]&!led[6]&!led[7])|(!led[4]&led[5]&!led[6]&led[7])|(!led[4]&!led[5]&led[6]&!led[7]));
assign	LED_2E=!((led[4]&!led[7])|(!led[5]&led[6]&!led[7])|(led[4]&!led[5]&!led[6]));
assign	LED_2F=!((led[4]&led[5]&!led[7])|(led[5]&!led[6]&!led[7])|(led[4]&!led[5]&led[6]&led[7])|(led[4]&!led[6]&!led[7]));
assign	LED_2G=!((led[4]&led[5]&led[6]&!led[7])|(!led[5]&!led[6]&!led[7])|(!led[4]&!led[5]&led[6]&led[7]));


endmodule

