#include "encoder.h"

void zoom(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(C(KC_PLUS));
    break;
  case ENC_CCW:
    tap_code16(C(KC_MINUS));
    break;
  case ENC_DOWN:
    tap_code16(C(KC_0));
    break;
  default:
    return;
  }
}

void volume(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(KC_AUDIO_VOL_UP);
    break;
  case ENC_CCW:
    tap_code16(KC_AUDIO_VOL_DOWN);
    break;
  case ENC_DOWN:
    tap_code16(KC_AUDIO_MUTE);
    break;
  default:
    return;
  }
}

void media(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(KC_MEDIA_NEXT_TRACK);
    break;
  case ENC_CCW:
    tap_code16(KC_MEDIA_PREV_TRACK);
    break;
  case ENC_DOWN:
    tap_code16(KC_MEDIA_PLAY_PAUSE);
    break;
  default:
    return;
  }
}

void tab(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(C(KC_TAB));
    break;
  case ENC_CCW:
    tap_code16(S(C(KC_TAB)));
    break;
  default:
    return;
  }
}
bool is_gui_time_active = false;
uint16_t gui_tab_timer = 0; // we will be using them soon.

enum custom_keycodes { // Make sure have the awesome keycode ready
  GUI_TAB = SAFE_RANGE,
};

bool process_record_encoder(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) { // This will do most of the grunt work with the keycodes.
  case GUI_TAB:
    if (record->event.pressed) {
      if (!is_gui_time_active) {
        is_gui_time_active = true;
        register_code(KC_LGUI);
      }
      gui_tab_timer = timer_read();
      register_code(KC_TAB);
    } else {
      unregister_code(KC_TAB);
    }
    break;
  }
  return true;
}

void matrix_scan_encoder(void) { // The very important timer.
  if (is_gui_time_active) {
    if (timer_elapsed(gui_tab_timer) > 1000) {
      unregister_code(KC_LGUI);
      is_gui_time_active = false;
    }
  }
}
