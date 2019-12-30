.include "constants.inc"

.segment "CODE"
.import main
.export nmi_handler
.proc nmi_handler
  ; Starts OAM copy
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
  RTI
.endproc