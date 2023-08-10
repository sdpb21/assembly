; main.asm - 17th of September 2020 - Aroub Abbas
; An example assembly language program
; Insert in properties box
;    pic-as Global Options -> Additional options: 
;    -Wl,-Map=test.map -Wa,-a -Wl,-presetVec=0h
#include "ECE332_assembly_includes_00.inc"	  
#include <xc.inc>
	    
	    PSECT resetVec,class=CODE,reloc=2
resetVec:   goto    main      ; goto entry
    
            PSECT   udata_acs
	        GLOBAL  resx     
resx:       DS      1         ; place for value
    
    
            PSECT   code
main:       clrf   resx,a      ; clear result 
            movlw  0x06    ; number of numbers
	    
top:        addwf resx,f,a  ; add to result
            decf   WREG,w,a ; next number
	    bnz    top      ; back for more
	    
done:       goto    done      ; back for more
            END     resetVec  ; start address



