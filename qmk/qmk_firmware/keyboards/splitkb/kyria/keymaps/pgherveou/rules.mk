OLED_ENABLE = yes
OLED_DRIVER = SSD1306
ENCODER_ENABLE = yes

TAP_DANCE_ENABLE = no
COMBO_ENABLE = yes
MOUSEKEY_ENABLE = no
RAW_ENABLE = no
WPM_ENABLE = no
CONSOLE_ENABLE = no

DEBOUNCE_TYPE = sym_eager_pk

# https://github.com/qmk/qmk_firmware/issues/5585
NO_USB_STARTUP_CHECK = yes
SRC += encoder.c

ifeq ($(strip $(WITH_SECRETS)), yes)
    OPT_DEFS += -DWITH_SECRETS
endif

# kyria v1 board
ifeq ($(strip $(KYRIA_V1)), yes)
    OPT_DEFS += -DKYRIA_V1
    RGBLIGHT_ENABLE = yes
# kyria v2 board
else
RGBLIGHT_ENABLE = false
endif

SRC += secrets.c
