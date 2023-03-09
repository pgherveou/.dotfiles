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
  // secrets
  KC_SECRET_1,
  KC_SECRET_2,
  KC_SECRET_3,
};

// Aliases for readability
#define SYM MO(_SYM)
#define NAV MO(_NAV)
#define FKEYS MO(_FUNCTION)

#define HYP_A MT(MOD_HYPR, KC_A)
#define CTL_TAB MT(MOD_LCTL, KC_TAB)
#define SFT_PIP MT(MOD_LSFT, KC_PIPE)
#define SFT_MIN MT(MOD_RSFT, KC_MINUS)
#define GUI_DEL MT(MOD_LGUI, KC_DEL)
#define CTL_BSP MT(MOD_RCTL, KC_BSPC)
#define SPC_NAV LT(_NAV, KC_SPC)

#define SFT_COL MT(MOD_LSFT, KC_COLN)

#define ENT_SYM LT(_SYM, KC_ENT)

// alias WORD_RIGHT to ctrl+right on linux and  alt+right on mac
#ifdef __APPLE__
#define CMD G
#define WORD_RIGHT LALT(KC_RIGHT)
#define WORD_LEFT LALT(KC_LEFT)
#define PASTE G(KC_V)
#define TERM_PASTE G(KC_V)
#define COPY G(KC_C)
#define CUT G(KC_X)
#define UNDO G(KC_Z)
#define SELECT_ALL G(KC_A)
#else
#define CMD C
#define WORD_RIGHT C(KC_RIGHT)
#define WORD_LEFT C(KC_LEFT)
#define PASTE C(KC_V)
#define TERM_PASTE S(PASTE)
#define COPY C(KC_C)
#define CUT C(KC_X)
#define UNDO C(KC_Z)
#define SELECT_ALL C(KC_A)

#endif
