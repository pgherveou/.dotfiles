#include QMK_KEYBOARD_H
#include "pgherveou.h"

#if (__has_include("secrets.h") && !defined(NO_SECRETS))
#include "secrets.h"
#else
static const char *const secrets[] = {"test"};
#endif

#ifndef MACRO_TIMER
#define MACRO_TIMER 5
#endif

bool process_record_secrets(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
  case KC_SECRET_1:
    if (record->event.pressed) {
      clear_mods();
      clear_oneshot_mods();
      send_string_with_delay(secrets[keycode - KC_SECRET_1], MACRO_TIMER);
    }
    return false;
    break;
  }
  return true;
}
