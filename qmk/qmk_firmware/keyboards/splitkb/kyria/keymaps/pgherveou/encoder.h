#pragma once
#include "quantum.h"

typedef enum {
  ENC_CW = 0b000,
  ENC_CCW = 0b001,
  ENC_DOWN = 0b010,
  ENC_UP = 0b011,
  ENC_TICK = 0b100,
} enc_action_t;

#define ENC_MSK 0b111
#define ENC_PRESSED 0b1000
#define ENC_KEYS ENC_L, ENC_R,

void matrix_init_enc(void);
void matrix_scan_enc(void);
bool process_record_encoder(uint16_t keycode, keyrecord_t *record);
const char *get_enc_str(void);
