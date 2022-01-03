#pragma once
#include QMK_KEYBOARD_H

enum layers {
  _QWERTY = 0,
  _NAV,
  _SYM,
  _FUNCTION,
};

enum custom_keycodes {
  // dummy placeholder for the start value
  DUMMY = SAFE_RANGE,
  // select a full line of text when pressing V in the nav layer
  NAV_V,
  // go to the previous or next line
  NAV_O,
  // shift caps lock in the nav layer
  NAV_CAPS,
  // Encoder keys
  ENC_L,
  ENC_R,
};
