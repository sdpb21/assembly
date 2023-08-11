
;*****************************************************************************
;                                                                            *
;    Files Required: P12F675.INC                                             *
;                                                                            *
;*****************************************************************************
;                             REQUIREMENTS                                   *
;																			 *
; The software controls the temperature of an incubator using a PID algorithm*
; and a zero crossing Triac switch.  The temperature sensor is an NTC therm- *
; -istor.		     													 	 *
;																			 *
; Proportional control is implemented by refering the half bridge thermistor *
; voltage to a linear ramp (staircase).  The ramp has n-steps, each step 	 *
; being of the AC mains period.  Thus for 50Hz mains the ramp is n x 20mS    *
; duration.  This ramp is raised on a pedestal such that the centre 		 *
; is exactly in the centre of the ADC input range, corresponding to the most *
; sensitive part of the thermistor network voltage/temperature curve.  Comp- *
; -aring the ramp plus pedestal with the thermistor voltage produces a pulse *
; width modulated power burst with zero voltage switching.	 				 *
;																			 *
; The Derivative part of the control algorithm is implimented by calculating *
; difference between successive thermistor voltages at y-second intervals.	 *
; This difference is scaled and added to the latest measured thermistor 	 *
; voltage to trick the control loop into thinking the temperature is higher  *
; or lower than it actually is.  The controller will adjust the heat 		 *
; accordingly and prevent an overshoot of the Desired temperature setpoint.  *
;																			 *
; Integral control is required because proportional plus derivative alone 	 *
; cannot reduce the temperature error to zero. The power burst will always 	 *
; settle to a value exactly equal to the heat loss from the incubator. By	 *
; adjusting the height of the pedestal according to the measured error 		 *
; between the setpoint and the steady state temperatures of the incubator,   *
; the temperature error can be reduced closeer to zero.						 *
;*****************************************************************************
;						PIC 12F675 PIN ASSIGNMENT									 
;
;	GP0								; Serial Data					 
;	GP1								; Serial Clock
;	GP2								; Zero crossing clock 
;	GP3								; Memory clear
;	GP4								; Temperature sensor (mV/Celsius)
;	GP5								; Triac gate
;-----------------------------------------------------------------------------
	list
	#include 	<p12f675.inc>     	; Processor specific variable definitions
	list
						         	; List directive to define processor
 	list  	p=12f675, c=80, n=60, r=Hex, st=On, t=Off, mm=On 

	errorlevel  -302              	; suppress message 302 from list file

; Development version configuration IS NOT code protected
; __CONFIG _CP_OFF & _WDT_ON & _MCLRE_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _BODEN_ON
 
; Production version configuration IS code protected
 __CONFIG _CP_ON & _WDT_ON & _MCLRE_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _BODEN_ON
;-----------------------------------------------------------------------------
		ORG     0x000             	; Reset vector

 goto    	Start             		; Go to beginning of program
;-----------------------------------------------------------------------------
;                         VARIABLE DEFINITIONS
;
 	CBLOCK		20h					; Start of ram block (20h to 7Fh bytes)

    W_Temp            				; Saved current W register contents
	Status_Temp       				; Saved contents of STATUS register
	
	Flag							; Flags

	ACCa_Hi							; Arithmetic accumulator 
	ACCa_Lo							; Arithmetic accumulator 
	ACCb_Hi							; Arithmetic accumulator 
	ACCb_Lo							; Arithmetic accumulator 
	
	Pedest_Lo						; Pedestal low byte
	Pedest_Hi						; Pedestal high byte

	Integ_Time_Lo					; Integration registers
	Integ_Time_Hi					;
	
	Ramp_Lo							; Ramp counter
	Ramp_Hi							;
	
	ADC_Prev_Lo						; Previous ADC values
	ADC_Prev_Hi						;	

	ENDC
;-----------------------------------------------------------------------------
;                           	FLAG BITS

Tick		equ		0h				; A 20mS interrupt occured
Integ_Ena	equ		03h				; Integrator enabled
Triac		equ		05h				; Set = Triac on
;-----------------------------------------------------------------------------
;					GPIO Bits
;
;	GP0								; Serial data 			(INPUT)					 
;	GP1								; Serial clock 			(INPUT)	
;	GP2								; Zero crossing 		(INPUT)	
;	GP3								; MCLR 					(INPUT)	
;	GP4								; Temperature sensor 	(INPUT)	
;	GP5								; Triac gate (low true) (OUTPUT)	
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
ISR_Code							; Interrupt on TMR0 overflow
								
		ORG     0x004             	; Interrupt vector location
 movwf   	W_Temp            		; Save current W register contents
 movf		STATUS,w          		; Move status register into W register
 movwf		Status_Temp       		; Save contents of STATUS register


 clrf		INTCON					; Kill all interrupts and flags
 
 bsf		Flag,Tick				; Set the pass enabled
 bsf		GPIO,0					; Test point

 bsf		INTCON,INTE				; Enable INT pin interrupts again
 
 movf    	Status_Temp,w     		; Retrieve copy of STATUS register
 movwf		STATUS            		; Restore pre-isr STATUS register contents
 swapf   	W_Temp,f				;
 swapf   	W_Temp,w          		; Restore pre-isr W register contents
 
 retfie								; Done interrupt
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; 			Double Precision Subtraction ( ACCb - ACCa -> ACCb )

D_Sub 								; At first negate ACCa; Then add one
									; for 2's compliment		
 comf 		ACCa_Lo,1				; negate ACCa ( -ACCa -> ACCa )
 incf 		ACCa_Lo,1				; Add one				
 btfsc 		STATUS,Z				; Test for zero
 decf 		ACCa_Hi,1				; Zero so borrow
 comf 		ACCa_Hi,1				; ACCa now has -ve value
 
									;-----------------------------------------
; 			Double Precision Addition ( ACCb + ACCa -> ACCb ) 
D_Add 								; Add low and high bytes with carry
	
 movf 		ACCa_Lo,w				; Add low bytes
 addwf 		ACCb_Lo,1 				;
 btfsc 		STATUS,C 				; Adjust if Carry
 incf 		ACCb_Hi,1				; C=1 so carry
 movf 		ACCa_Hi,w				; Add high bytes
 addwf 		ACCb_Hi,1 				; add msb

 return
;-----------------------------------------------------------------------------
;=============================================================================
Start								; Start of program

 bsf 		STATUS, RP0 			; Bank-1
 call 		3FFh 					; Get the RC oscillator calibration value
 movwf 		OSCCAL 					; Calibrate
 bcf 		STATUS,RP0 				; Bank-0
;-----------------------------------------------------------------------------
 clrwdt								; Keep the dog alive

 banksel	GPIO					; Select bank
 clrf		GPIO					; Clear GPIO
 
 bsf		GPIO,5  				; Triac is off
 bcf		Flag,Triac				; Triac will turn on at zero crossing Tick

 banksel	CMCON					; Select bank
 movlw		B'00011111'				; Set GP<5:0> to digital I/0
 movwf		CMCON					; No comparator

 banksel	VRCON					; Select bank
 clrf		VRCON					; or Vref
;-----------------------------------------------------------------------------
 banksel	TRISIO					; Select bank
 movlw		B'00011100'				; Set GP<4:2> input, GP0, GP1, GP5 output	
 movwf		TRISIO					; 		

 banksel	ANSEL					; Select bank
 movlw		B'00111000'				; GP4/AN3 is only analog, Frc 
 movwf		ANSEL					;	
;-----------------------------------------------------------------------------
 banksel	PIE1					; Select bank
 clrf		PIE1					; Kill ADC interrupts

 banksel	OPTION_REG				; Select bank
 movlw		B'10001111'				; Prescaler to wdt
									; Low to high edge on T0CKI pin
 movwf		OPTION_REG				; Pull-ups off
;-----------------------------------------------------------------------------
 banksel	ADCON0					; Select bank
 movlw		B'10001101'				; ADC is on, GO_DONE is off, AN3 selected
 movwf		ADCON0					; Right justified

 banksel	PIR1					; Select bank
 bcf		PIR1,ADIF				; Clear ADC interrupt flag
									; Ready for first conversion (10-bits RJ)
;-----------------------------------------------------------------------------
 banksel	FSR						; Select bank
 movlw		20h						; Preset FSR to first ram location 20h
 movwf		FSR						; Last ram is 5F.  64 bytes total

Ram_Clear_Lp						; Clear all RAM loop

 clrf		INDF					; Clear the ram file pointed to by FSR
 incf		FSR,1					; Next ram
 btfss		FSR,6					; Overflow ram?
 goto		Ram_Clear_Lp			;

 btfss		FSR,5					; Overflow ram?
 goto		Ram_Clear_Lp			;
									; All ram is clear
;-----------------------------------------------------------------------------
;                           	Presets

 banksel	ADRESH					; Select bank
 clrf		ADRESH					; Clear the ADC

 banksel	ADRESL					; Select bank
 clrf		ADRESL					;

 movlw		01h						; Start of ramp
 movwf		Ramp_Lo					;
 movwf		Ramp_Hi					;

 clrf		ADC_Prev_Hi				; Clear the previous ADC value
 clrf		ADC_Prev_Lo				;
 
 movlw		01h						; Preset pedestal to 01F0h***************
 movwf		Pedest_Hi				; 
 movlw		0E0h					; See notes above
 movwf		Pedest_Lo				;

 movlw		.1						; Reset integration time
 movwf		Integ_Time_Hi			; 
 movwf		Integ_Time_Lo			; 
;-----------------------------------------------------------------------------
 movlw		B'10010000'				; Enable INT pin interrupts only
 movwf		INTCON					; 
;=============================================================================									
Top									; Top of execution loop

 clrwdt								; Keep the dog alive

 btfss		Flag,Tick				; Test for a 20mS interrupt
 goto		$-1						; Loop here until set
 									;
 bcf		Flag,Tick				; Set by next interrupt

 banksel	GPIO					; Select bank
 bcf		GPIO,0					; Test point goes low
;----------------------------------------------------------------------------- 
 btfsc		Flag,Triac				; Test for Triac-on request
 bcf		GPIO,5  				; Turn Triac on
 									;
 btfss		Flag,Triac				; Test for Triac off request
 bsf		GPIO,5  				; Turn Triac off
 									;-----------------------------------------
 banksel	ADCON0					; Select bank
 bsf		ADCON0,1				; Do an ADC on AN3
 btfsc		ADCON0,1				; Set the GODONE bit to start conversion
 goto		$-1						; Loop until done 
									; (Result ADRESH, ADRESL)
;-----------------------------------------------------------------------------
;	Subtract ADRES from minimum operating temperature or OPEN CIRCUIT SENSOR

 movlw		0EBh					; Charge (10C = .235 = 0EBh)
 movwf		ACCb_Lo					;
 movlw		00h						;
 movwf		ACCb_Hi					;
									; Get the current temperature
 banksel	ADRESL					; Select bank
 movf		ADRESL,w				; Preset the temperature for subtraction
 movwf		ACCa_Lo					;

 banksel	ADRESH					; Select bank
 movf		ADRESH,w				;
 movwf		ACCa_Hi					;

 call		D_Sub					; Result in ACCb = -ve = Too cold!.

 btfsc		ACCb_Hi,7				; If -ve clear Triac flag and loop
 goto		Rock_Roll				; Ok
									; Too cold!
 bcf		Flag,Triac				; Make sure the heater is off
 goto		Top						; Loop until warmer	or sensor repaired								;
;-----------------------------------------------------------------------------
Rock_Roll							; Not too cold or faulty

;			Make the temperature differential term (New - Old values)

									; Get the new values
 banksel	ADRESL					; Select bank
 movf		ADRESL,w				;
 movwf		ACCb_Lo					;

 banksel	ADRESH					; Select bank
 movf		ADRESH,w				;
 movwf		ACCb_Hi					;
									; New values in ACCb
 movf		ADC_Prev_Lo,w			;
 movwf		ACCa_Lo					;
 movf		ADC_Prev_Hi,w			;
 movwf		ACCa_Hi					;
									; Old values to ACCa
 call		D_Sub					; Diference in ACCb (+ve = temp increase)
;-----------------------------------------------------------------------------
; 			Make a ramp 

 clrf		Ramp_Hi					; Always zero

 decfsz		Ramp_Lo,1				; Make the ramp	32 passes high
 goto		Ramping					;
									;
 movlw		.32						; Recharge Lo Ramp height to .32*********
 movwf		Ramp_Lo					;

;	Test for within proportional zone and flag(Triac off at recharge)

 btfsc		Flag,Triac				;
 bcf		Flag,Integ_Ena			; Not in proportional zone (Heating mode)
									;
 btfss		Flag,Triac				;
 bsf		Flag,Integ_Ena			; In proportional zone (Pulsing mode)
									;
;-----------------------------------------------------------------------------
Ramping								; ACCb has Delta-T (+ve = increasing)

;			Add Delta-T to Temperature

 banksel	ADRESL					; Select bank
 movf		ADRESL,w				;
 movwf		ACCa_Lo					;

 banksel	ADRESH					; Select bank
 movf		ADRESH,w				;
 movwf		ACCa_Hi					;

 call		D_Add					; ACCb has Temperature + Delta-T  (T+dT)
									;-----------------------------------------
;           Subtract Pedestal from T+dT	 (T+dT-P)								

 movf		Pedest_Lo,w				; 
 movwf		ACCa_Lo					;
 movf		Pedest_Hi,w				; 
 movwf		ACCa_Hi					; 

 call		D_Sub					; ACCb has result  (T+dT-P)
									;-----------------------------------------
;           Subtract Ramp from T+dT-P	 (T+dT-P-R)

 movf		Ramp_Lo,w				;
 movwf		ACCa_Lo					;
 movf		Ramp_Hi,w				;
 movwf		ACCa_Hi					;

 call		D_Sub					; ACCb has result  (T+dT-P-R)
									;-----------------------------------------
 bcf		Flag,Triac				; Set the flag first

 btfsc		ACCb_Hi,7				; Turn it on if Subtract result is -ve
 bsf		Flag,Triac				;
									;
;-----------------------------------------------------------------------------
; Save the new temperature to the Old temperature for next pass

 banksel	ADRESL					; Select bank
 movf		ADRESL,w				;
 movwf		ADC_Prev_Lo				;

 banksel	ADRESH					; Select bank
 movf		ADRESH,w				;
 movwf		ADC_Prev_Hi				; Saved
;-----------------------------------------------------------------------------
; Integration error	compute	
; Adjust the Pedestal height every 2.0-minutes to zero the steady state error
; Setpoint = 200h = .512; Current temperature in ADRES 
; Integration increment size = 1

;			Integrate error if enabled

 btfsc		Flag,Integ_Ena			; Test for enabled
 goto		Integrating				; Enabled!
									; else
 movlw		01H						; Remove integration components by reset
 movwf		Pedest_Hi				; 
 movlw		0E0h					; 
 movwf		Pedest_Lo				;
									;
Integrating							; Enabled!

 decfsz		Integ_Time_Lo,1			; Decrement timer
 goto		Top						; Loop - not ready for integration
									;
 decfsz		Integ_Time_Hi,1			;
 goto		Top						; Loop - not ready for integration
									;*****************************************
 movlw		17h						; Recharge integration registers to 
 movwf		Integ_Time_Hi			; 2EE0h = .12000= 4.0 mins
 movlw		70h		     			; 1770h = .6000 = 2.0 mins
 movwf		Integ_Time_Lo			; 0BB8h = .3000 = 1.0 mins							;
;-----------------------------------------------------------------------------
;           Subtract Setpoint from Temperature  

 movlw		02h						; Setpoint to ACCa
 movwf		ACCa_Hi					;
 clrf		ACCa_Lo					;

 banksel	ADRESL					; Select bank
 movf		ADRESL,w				; Preset the temperature for subtraction
 movwf		ACCb_Lo					;

 banksel	ADRESH					; Select bank
 movf		ADRESH,w				;
 movwf		ACCb_Hi					;

 call		D_Sub					; Subtract 
									;-----------------------------------------
 btfss		ACCb_Hi,7				; (-ve = temperature too low)
 goto		Test_Hi_C				; Go test high temperature. 
									; We know temp is not too low
 movlw		.1						; Temperature is too low so increment 
									; pedestal by one
 addwf		Pedest_Lo,1				;
 btfsc		STATUS,C				; Test for carry
 incf		Pedest_Hi,1				;
									;
 goto		Top						; Proportional range raised
									;-----------------------------------------
Test_Hi_C							; Test for non-zero (high temperature)
									;
 movf		ACCb_Hi,1				; Test ACCb for zero
 btfss		STATUS,Z				;
 goto		Non_Z					; ACCb is not zero!
									; 
 movf		ACCb_Lo,1				;
 btfss		STATUS,Z				;
 goto		Non_Z					; ACCb is not zero!
									;
 goto		Top						; Temperature is exactly on setpoint! 
									;-----------------------------------------									
Non_Z								; Temperature is too high! 	

 movlw		.1						; Temperature is too high so decrement
 subwf		Pedest_Lo,1				; pedestal by one
 btfss		STATUS,C				; Test for carry
 decf		Pedest_Hi,1				;
									;
 goto		Top						; Proportional range lowered
;-----------------------------------------------------------------------------

 end








