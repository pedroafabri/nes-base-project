.include "constants.inc"
.include "header.inc"

.segment "CODE"
.import irq_handler
.import nmi_handler
.import reset_handler

.export main
.proc main
  ; write the palette
  JSR write_palette

  ; write sprite data
  LDA #$70
  STA $0200 ; Y-coord of first sprite
  LDA #$05
  STA $0201 ; tile number of first sprite
  LDA #$00
  STA $0202 ; attributes of first sprite
  LDA #$80
  STA $0203 ; X-coord of first sprite


vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

;====================================== 
; Forever Loop
;====================================== 
forever:
  JSR read_controller
  LDA BUTTONS1
  CMP #$08
  BNE NotGoingUp
  LDA #$01
  JMP EndRoutine
NotGoingUp:
  LDA #%00
EndRoutine:
  STA $0001

  JMP forever

.endproc

;====================================== 
; Palette SubRoutine
;====================================== 
.proc write_palette

; Start palette addr at $3F00
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR

; Palette Loop start
  LDX #$00 
  
PaletteLoop:
  LDA Palette, x
  STA PPUDATA
  INX
  CPX #$04  ; Inserts 4 colors to the palette. Change based on "Palette" bytes.
  BNE PaletteLoop

  RTS

Palette:
  .byte $0F,$19,$09,$1C ; Sprite Palette 1

.endproc

;======================================  
; Controller Reader SubRoutine
;====================================== 
.proc read_controller
  ; Latch $2016
  LDA #$01
  STA JOYPAD1 
  STA BUTTONS1
  LSR A
  STA JOYPAD1
  
; Reads the controller and stores buttons at RAM $0000
ControllerReadLoop:
  LDA JOYPAD1
  LSR A
  ROL BUTTONS1
  BCC ControllerReadLoop

  RTS
.endproc



.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics.chr"