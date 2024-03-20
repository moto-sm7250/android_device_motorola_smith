#!/vendor/bin/sh

# Add custom multisim boot config management for smith.
scriptname=${0##*/}
carrier=$(getprop ro.carrier)
bootmode=$(getprop ro.bootmode)
hw_dualsim=$(getprop ro.vendor.hw.dualsim)

# Android property to configure multisim.
vnd_simconfig_prop=persist.vendor.radio.multisim.config

# Persistant MMI Property to configure dual sim state
vnd_dualsim_prop=persist.vendor.radio.dualsim

vnd_simconfig=$(getprop $vnd_simconfig_prop)
vnd_dualsim=$(getprop $vnd_dualsim_prop)

set_dualsim=$vnd_dualsim

notice()
{
    echo "$*"
    echo "$scriptname: $*" > /dev/kmsg
}

notice "carrier \"$carrier\" bootmode \"$bootmode\" hw_dualsim \"$hw_dualsim\" vnd_dualsim \"$set_dualsim\" sim_config \"$vnd_simconfig\""

# Configure custom behavior for Soft config
# Workaround to force ATT & TMO to behave in Soft Config
if [[ ($carrier == "att" || $carrier == "tmo" || $carrier == "retus") || $hw_dualsim == "soft" ]]; then
    #Force dual-sim in factory mode, and reset when out of factory
    if [[ $bootmode == "mot-factory" ]]; then
        set_dualsim="factory"
    elif [[ $set_dualsim != "true" || $set_dualsim == "factory" ]]; then
        set_dualsim="false"
    fi

    #MMI_TODO product_smith: Add force Erasing modemst1 & modemst2 on this WARNING
    if [[ $hw_dualsim == "soft" ]] && \
       [[ ($set_dualsim == "factory" && $vnd_simconfig != "dsds") || \
          ($set_dualsim == "true" && $vnd_simconfig != "dsds") || \
          ($set_dualsim == "false" && $vnd_simconfig != "") ]]; then
        notice "WARNING: Dual SIM Config appears to have changed : Ensure modemst1 & 2 are erased"
    fi
else
    set_dualsim=$hw_dualsim
fi

notice "setting $vnd_dualsim_prop \"$set_dualsim\""
setprop $vnd_dualsim_prop "$set_dualsim"

if [[ $set_dualsim == "true" || $set_dualsim == "factory" ]]; then
    setprop $vnd_simconfig_prop "dsds"
else
    setprop $vnd_simconfig_prop ""
fi

