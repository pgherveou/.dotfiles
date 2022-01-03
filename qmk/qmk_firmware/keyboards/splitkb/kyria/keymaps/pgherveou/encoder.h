
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
