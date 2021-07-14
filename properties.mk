#
# Properties for smith
#

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.sf.color_mode=9

# Sensor
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.vendor.sensors.dual_als=1 \
    ro.vendor.sensors.mot_ltv=true \
    persist.vendor.sensors.hal_trigger_ssr=false \
    persist.vendor.sensors.odl.adsp=true
