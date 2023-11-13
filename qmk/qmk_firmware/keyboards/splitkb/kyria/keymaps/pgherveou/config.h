/* Copyright 2019 Thomas Baart <thomas@splitkb.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once
#define TAPPING_TERM_PER_KEY
#define RETRO_TAPPING_PER_KEY
// #define HOLD_ON_OTHER_KEY_PRESS
// #define PERMISSIVE_HOLD_PER_KEY
// #define IGNORE_MOD_TAP_INTERRUPT

#undef DEBOUNCE
#define DEBOUNCE 20

// see https://github.com/qmk/qmk_firmware/blob/master/docs/feature_debounce_type.md
#define DEBOUNCE_TYPE sym_eager_pr

#ifdef RGBLIGHT_ENABLE
#define RGBLIGHT_LIMIT_VAL 128
#define RGBLIGHT_SLEEP
#define RGBLIGHT_LAYERS
#define RGBLIGHT_MAX_LAYERS 16
#define RGBLIGHT_HUE_STEP 8
#define RGBLIGHT_SAT_STEP 8
#define RGBLIGHT_VAL_STEP 8
#endif

#ifdef ENCODER_ENABLE
#define ENCODER_RESOLUTION 2
#endif

#ifdef KYRIA_V1
#define ENCODER_DIRECTION_FLIP
#endif
