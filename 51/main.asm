
; 单个计数器，数码管一位显示，中断清零
; lizy14@mails.tsinghua.edu.cn
; 2016-12-16

ORG  0000H
    LJMP MAIN

ORG 0003H
    MOV  B, #0
    RETI

INIT:
    SETB EA
    SETB EX0
    CLR  IT0
    RET

MAIN:
    CALL INIT
    MOV  B,  0
    MOV  P2,  #0007h    ; display mask
    MOV  DPTR, #DIGITS_TABLE

LOOP_BEGIN:

    MOV  A, B
    MOVC A, @A+DPTR
    MOV  P0, A

    INC  B
    ANL  B, #15
    call DELAY

    SJMP LOOP_BEGIN

DELAY:
    MOV R5, #20
    D1: MOV R6, #20
    D2: MOV R7, #248
    DJNZ R7, $
    DJNZ R6, D2
    DJNZ R5, D1
    RET

DIGITS_TABLE:
    DB 0C0H,0F9H,0A4H,0B0H,099H,092H,082H,0F8H
    DB 080H,090H,088H,083H,0C6H,0A1H,086H,08EH,089H,08CH


END
