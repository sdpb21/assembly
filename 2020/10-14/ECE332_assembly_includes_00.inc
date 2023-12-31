/**************************************************************
* ECE332_assembly_includes_00.inc
*************************************************************/
	PROCESSOR	18F452
// CONFIG1H
	//config  OSC=RCIO	// Oscillator Selection bits (RC oscillator w/ OSC2 configured as RA6)
	config  OSC=XT	// Oscillator Selection bits (RC oscillator w/ OSC2 configured as RA6)
	config  OSCS=OFF	// Oscillator System Clock Switch Enable bit (Oscillator system clock switch option is disabled (main oscillator is source))
// CONFIG2L
	config  PWRT=OFF	// Power-up Timer Enable bit (PWRT disabled)
	config  BOR=ON	// Brown-out Reset Enable bit (Brown-out Reset enabled)
	config  BORV=20	// Brown-out Reset Voltage bits (VBOR set to 2.0V)
// CONFIG2H
	config  WDT=OFF	// Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
	config  WDTPS=128	// Watchdog Timer Postscale Select bits (1:128)
// CONFIG3H
	config  CCP2MUX=ON	// CCP2 Mux bit (CCP2 input/output is multiplexed with RC1)
// CONFIG4L
	config  STVR=ON	// Stack Full/Underflow Reset Enable bit (Stack Full/Underflow will cause RESET)
	config  LVP=ON	// Low Voltage ICSP Enable bit (Low Voltage ICSP enabled)
// CONFIG5L
	config  CP0=OFF	// Code Protection bit (Block 0 (000200-001FFFh) not code protected)
	config  CP1=OFF	// Code Protection bit (Block 1 (002000-003FFFh) not code protected)
	config  CP2=OFF	// Code Protection bit (Block 2 (004000-005FFFh) not code protected)
	config  CP3=OFF	// Code Protection bit (Block 3 (006000-007FFFh) not code protected)
// CONFIG5H
	config  CPB=OFF	// Boot Block Code Protection bit (Boot Block (000000-0001FFh) not code protected
	config  CPD=OFF	// Data EEPROM Code Protection bit (Data EEPROM not code protected)
// CONFIG6L
	config  WRT0=OFF	// Write Protection bit (Block 0 (000200-001FFFh) not write protected)
	config  WRT1=OFF	// Write Protection bit (Block 1 (002000-003FFFh) not write protected)
	config  WRT2=OFF	// Write Protection bit (Block 2 (004000-005FFFh) not write protected)
	config  WRT3=OFF	// Write Protection bit (Block 3 (006000-007FFFh) not write protected)
// CONFIG6H
	config  WRTC=OFF	// Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write protected)
	config  WRTB=OFF	// Boot Block Write Protection bit (Boot Block (000000-0001FFh) not write protected)
	config  WRTD=OFF	// Data EEPROM Write Protection bit (Data EEPROM not write protected)
// CONFIG7L
	config  EBTR0=OFF	// Table Read Protection bit (Block 0 (000200-001FFFh) not protected from Table Reads executed in other blocks)
	config  EBTR1=OFF	// Table Read Protection bit (Block 1 (002000-003FFFh) not protected from Table Reads executed in other blocks)
	config  EBTR2=OFF	// Table Read Protection bit (Block 2 (004000-005FFFh) not protected from Table Reads executed in other blocks)
	config  EBTR3=OFF	// Table Read Protection bit (Block 3 (006000-007FFFh) not protected from Table Reads executed in other blocks)
// CONFIG7H
	config  EBTRB=OFF	// Boot Block Table Read Protection bit (Boot Block (000000-0001FFh) not protected from Table Reads executed in other blocks)
//       config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.
