; Vector Table Mapped to Address 0 at Reset

                PRESERVE8
                THUMB

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors        DCD     0x00003FFC          ; Initial SP
                DCD     Reset_Handler
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0

                ; External Interrupts
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0
                DCD     0

;-------------------------------------------------
                AREA |.text|, CODE, READONLY
;-------------------------------------------------

Reset_Handler   PROC
                GLOBAL  Reset_Handler
                ENTRY

                LDR     R0, =0x56000000

; ===============================
; N = 5
; ===============================
                MOVS    R1, #5
                STR     R1, [R0, #0x08]

; ===============================
; K = 3
; ===============================
                MOVS    R1, #3
                STR     R1, [R0, #0x0C]

; ===============================
; base_in = 0
; ===============================
                MOVS     R1, #0
                STR     R1, [R0, #0x10]

; ===============================
; base_k = 25
; ===============================
                MOVS     R1, #25
                STR     R1, [R0, #0x14]

; ===============================
; base_out = 34
; ===============================
                MOVS     R1, #50
                STR     R1, [R0, #0x18]

; ===============================
; start = 1
; ===============================
                MOVS    R1, #1
                STR     R1, [R0, #0x00]

; ===============================
; wait until done == 1
; ===============================
WAIT_DONE
                LDR     R1, [R0, #0x04]
                CMP     R1, #1
                BNE     WAIT_DONE

; ===============================
; finished - stay here
; ===============================
DONE
                B       DONE

                ENDP

                ALIGN   4
                END
