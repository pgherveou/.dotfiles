OLED_ENABLE = no
TAP_DANCE_ENABLE = no
COMBO_ENABLE = yes
MOUSEKEY_ENABLE = no
RAW_ENABLE = no
WPM_ENABLE = no
CONSOLE_ENABLE = no

DEBOUNCE_TYPE = sym_eager_pk
# https://github.com/qmk/qmk_firmware/issues/5585
# NO_USB_STARTUP_CHECK = yes

ifeq ($(strip $(WITH_SECRETS)), yes)
    OPT_DEFS += -DWITH_SECRETS
endif

ifeq ($(strip $(APPLE)), yes)
    OPT_DEFS += -D__APPLE__
endif

SRC += secrets.c
