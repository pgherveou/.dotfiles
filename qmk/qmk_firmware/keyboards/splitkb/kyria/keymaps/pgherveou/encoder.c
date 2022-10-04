#pragma GCC diagnostic ignored "-Wattributes"

#include "encoder.h"
#include "keycode.h"
#include "pgherveou.h"

enum enc_mode_t {
  SCROLL,
  CHROME,
  ZOOM,
  SLACK,
  VOLUME,
  BRIGHTNESS,
  VIM_QF,
  TAB,
  AFTER_LAST_MODE
};

enum enc_mode_t enc_current_mode = 0;
bool scroll_fast = true;

const char *get_enc_str(void) {
  switch (enc_current_mode) {
  case TAB:
    return "TAB";
  case ZOOM:
    return "Zoom";
  case SCROLL:
    if (scroll_fast) {
      return "Scroll page";
    } else {
      return "Scroll";
    }
  case SLACK:
    return "Slack";
  case CHROME:
    return "Chrome";
  case VOLUME:
    return "Volume";
  case BRIGHTNESS:
    return "Brightness";
  case VIM_QF:
    return "Vim Quickfix";
  case AFTER_LAST_MODE:
    return "-";
  }
  return "";
}

void switch_mode(enc_action_t action) {
  int i = (int)enc_current_mode;

  switch (action & ENC_MSK) {
  case ENC_CW:
    if (++i == AFTER_LAST_MODE) {
      i = 0;
    }
    break;
  case ENC_CCW:
    if (--i < 0) {
      i = AFTER_LAST_MODE - 1;
    }
    break;
  case ENC_DOWN:
    i = 0;
  }

  enc_current_mode = i;
}

void brightness(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(KC_BRIGHTNESS_UP);
    break;
  case ENC_CCW:
    tap_code16(KC_BRIGHTNESS_DOWN);
    break;
  case ENC_DOWN:
    tap_code16(KC_SYSTEM_POWER);
  default:
    return;
  }
}

void slack(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(G(KC_RBRC));
    break;
  case ENC_CCW:
    tap_code16(G(KC_LBRC));
    break;
  case ENC_DOWN:
    tap_code16(LSG(KC_T)); // go to thread
    break;
  default:
    return;
  }
}

void chrome(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(LAG(KC_RIGHT));
    break;
  case ENC_CCW:
    tap_code16(LAG(KC_LEFT));
    break;
  default:
    break;
    ;
  }
}

void scroll(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    if (scroll_fast) {
      tap_code16(KC_PGDN);
    } else {
      tap_code16(KC_DOWN);
      tap_code16_delay(KC_DOWN, 10);
      tap_code16_delay(KC_DOWN, 10);
    }
    break;
  case ENC_CCW:
    if (scroll_fast) {
      tap_code16(KC_PGUP);
    } else {
      tap_code16(KC_UP);
      tap_code16_delay(KC_UP, 10);
      tap_code16_delay(KC_UP, 10);
    }

    break;
  case ENC_DOWN:
    scroll_fast = !scroll_fast;
  default:
    break;
    ;
  }
}

void vim_quickfix(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    SEND_STRING(":cnext");
    tap_code16(KC_ENTER);
    break;
  case ENC_CCW:
    SEND_STRING(":cprev");
    tap_code16(KC_ENTER);
    break;
  case ENC_DOWN:
    SEND_STRING(":copen");
    tap_code16(KC_ENTER);
    break;
  default:
    break;
  }
}

void zoom(enc_action_t action) {
  switch (action & ENC_MSK) {
  case ENC_CW:
    tap_code16(G(KC_EQUAL));
    break;
  case ENC_CCW:
    tap_code16(G(KC_MINUS));
    break;
  case ENC_DOWN:
    tap_code16(G(KC_0));
    break;
  default:
    break;
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

bool is_alt_tab_active = false;
uint16_t alt_tab_timer = 0;
const uint16_t alt_tab_timeout = 500;
void window(enc_action_t action) {
  uint16_t kc;
  switch (action & ENC_MSK) {
  case ENC_TICK:
    if (is_alt_tab_active && timer_elapsed(alt_tab_timer) > alt_tab_timeout) {
      unregister_code(KC_LGUI);
      is_alt_tab_active = false;
    }
    return;
  case ENC_CW:
    kc = KC_TAB;
    break;
  case ENC_CCW:
    kc = S(KC_TAB);
    break;
  default:
    return;
  }
  if (!is_alt_tab_active) {
    register_code(KC_LGUI);
  }
  tap_code16(kc);
  is_alt_tab_active = true;
  alt_tab_timer = timer_read();
}

void exec_mode(enc_action_t action) {
  switch (enc_current_mode) {
  case TAB:
    window(action);
    break;
  case ZOOM:
    zoom(action);
    break;
  case SCROLL:
    scroll(action);
    break;
  case SLACK:
    slack(action);
    break;
  case CHROME:
    chrome(action);
    break;
  case VOLUME:
    volume(action);
    break;
  case BRIGHTNESS:
    brightness(action);
    break;
  case VIM_QF:
    vim_quickfix(action);
    break;
  case AFTER_LAST_MODE:
    break;
  }
}

void encoder_execute(uint8_t index, enc_action_t action) {
  if (index == 0) { // Left encoder
    switch_mode(action);
  } else if (index == 1) { // Right encoder
    exec_mode(action);
  }

  // We use one-shot layers, but that doesn't work well when
  // the oneshot is an encoder action.
  // So we need to ensure that oneshot is reset
  clear_oneshot_layer_state(ONESHOT_OTHER_KEY_PRESSED);
}

// Some actions have a timeout, so they
// need to get a tick every so often
void matrix_scan_enc(void) { window(ENC_TICK); }

bool pressed[2];
bool encoder_update_user(uint8_t index, bool clockwise) {
  enc_action_t action;
  if (clockwise) {
    action = ENC_CW;
  } else {
    action = ENC_CCW;
  }
  if (pressed[index]) {
    action |= ENC_PRESSED;
  }

  encoder_execute(index, action);
  return false;
}

void matrix_init_enc(void) {
  pressed[0] = false;
  pressed[1] = false;
}

bool process_record_encoder(uint16_t keycode, keyrecord_t *record) {
  uint8_t idx = 0; // 0 for left, 1 for right
  switch (keycode) {
  case ENC_R:
    idx++;
  case ENC_L:
    if (record->event.pressed) {
      pressed[idx] = true;
      encoder_execute(idx, ENC_DOWN | ENC_PRESSED);
    } else {
      pressed[idx] = false;
      encoder_execute(idx, ENC_UP);
    };
    return false;
  default:
    return true;
  }
}
