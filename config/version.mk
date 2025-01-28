PRODUCT_VERSION_MAJOR = 15
PRODUCT_VERSION_MINOR = 0

# Increase MATRIXX Version with each major release.
MATRIXX_VERSION := 11.1.0

MATRIXX_BUILD_TYPE ?= Unofficial

ifeq ($(WITH_GMS), true)
  MATRIXX_BUILD_VARIANT := Gapps
else
  MATRIXX_BUILD_VARIANT := Vanilla
endif

ifeq ($(MATRIXX_BUILD_TYPE), Official)
-include vendor/lineage-priv/keys/keys.mk
endif

# Internal version
LINEAGE_VERSION := Matrixx$(MATRIXX_VARIANT)-v$(MATRIXX_VERSION)-$(MATRIXX_BUILD_TYPE)-$(LINEAGE_BUILD)-$(MATRIXX_BUILD_VARIANT)-$(shell date +%Y%m%d)

# Display version
LINEAGE_DISPLAY_VERSION := Matrixx-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LINEAGE_BUILD)-v$(MATRIXX_VERSION)

# Build info
MATRIXX_BUILD_INFO := $(LINEAGE_VERSION)

# Matrixx properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.matrixx.battery?=$(MATRIXX_BATTERY) \
    ro.matrixx.build.variant=$(MATRIXX_BUILD_VARIANT) \
    ro.matrixx.build.version=$(LINEAGE_VERSION) \
    ro.matrixx.chipset?=$(MATRIXX_CHIPSET) \
    ro.matrixx.display_resolution?=$(MATRIXX_DISPLAY) \
    ro.matrixx.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.matrixx.maintainer=$(MATRIXX_MAINTAINER) \
    ro.matrixx.release.type=$(MATRIXX_BUILD_TYPE) \
    ro.matrixx.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(MATRIXX_VERSION)
