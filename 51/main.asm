
; 两个计数器，两位数码管显示，分别由定时器、按键控制
; lizy14@mails.tsinghua.edu.cn
; 2016-12-21

BUTTONDOWN EQU 05H ; time till the next button press to be able to be responded
COUNTERX EQU 00H   ; low digit controlled by timer
COUNTERY EQU 01H   ; digit controlled by button
COUNTERT EQU 03H   ; time since last increase of timer counter

ORG  0000H
    LJMP MAIN

ORG 0003H
    LJMP EXINT

ORG 000BH
    LJMP TMINT

ORG 0013H
    LJMP EXINT


TMINT:
    ; timer overflow interrupt handler
    ; increse counter X
    PUSH PSW
    PUSH ACC

    MOV A, BUTTONDOWN
    CJNE A, #00H, DODEC
        DONTDEC:
        SJMP DONEDEC
        DODEC:
        DEC A
        DONEDEC:
    MOV BUTTONDOWN, A

    MOV A, COUNTERT
    INC A
    CJNE A, #020H, DONOTINCRESE
        DOINCREASE:
        MOV A, COUNTERX
        INC A
        CJNE A, #0AH, NOCARRYX
            CARRYX:
            MOV A, #0H
            NOCARRYX:
        MOV COUNTERX, A
        DONOTINCRESE:
    MOV COUNTERT, A

    POP ACC
    POP PSW
    RETI

EXINT:
    ; external interrupt handler
    ; increase counter Y
    PUSH PSW
    PUSH ACC
    CLR EA
    MOV A, BUTTONDOWN
    CJNE A, #0H, DONOTINCREASEY
        DOINCREASEY:
        MOV A, #010H
        MOV BUTTONDOWN, A
        MOV A, COUNTERY
        INC A
        CJNE A, #0AH, NOCARRYY
            CARRYY:
            MOV A, #0
            NOCARRYY:
        MOV COUNTERY, A
        DONOTINCREASEY:

    SETB EA
    POP ACC
    POP PSW
    RETI

INIT:

    ; set up external interrupt
    SETB EX0
    SETB IT0
    SETB EX1
    SETB IT1

    ; set up timer interrupt
    SETB ET0
    MOV TH0, #0FFH
    MOV TL0, #0FFH
    SETB TR0

    SETB EA ; enable interrupt

    MOV DPTR, #DIGITS_TABLE  ; digit translation
    MOV SP, #30H ; set up stack pointer

    MOV COUNTERX, #2H
    MOV COUNTERY, #4H
    MOV COUNTERT, #0H
    MOV BUTTONDOWN, #0H

    RET

DRAW:  ; display counters
    MOV A, COUNTERX
    MOVC A, @A+DPTR
    MOV P0, A

    CLR P2.3
    CALL SMALLDELAY
    SETB P2.3

    MOV A, COUNTERY
    MOVC A, @A+DPTR
    MOV P0, A

    CLR P2.2
    CALL SMALLDELAY
    SETB P2.2

    RET


SMALLDELAY:
    MOV R7, #0FFH
    D0: DJNZ R7, D0
    RET


MAIN:
    CALL INIT
    LOOP_BEGIN: CALL DRAW
    SJMP LOOP_BEGIN


DIGITS_TABLE:
    DB 0C0H,0F9H,0A4H,0B0H,099H,092H,082H,0F8H
    DB 080H,090H,088H,083H,0C6H,0A1H,086H,08EH,089H,08CH


END
