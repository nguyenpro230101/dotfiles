# Getting the data and initializing an array.
# Formatting helpers

IFS=',' read -ra BATTERY_INFO <<< "$(acpi)"

CHARGE=${BATTERY_INFO[1]::-1}
ICON=""
FORMAT=""
CHARGED=${BATTERY_INFO[0]:10:99}

# Format battery icon, depending on the status.
if [[ "$CHARGED" == *"Charging"* ]]; then
    ICON1="" # Plug icon, font awesome. # Car Battery icon, font awesome
fi
if [[ "$CHARGED" == *"Unknown"* ]]; then
    ICON1="" # Plug icon, font awesome. # Car Battery icon, font awesome
fi
if [[ "$CHARGED" == *"Full"* ]]; then
    ICON1="" # Plug icon, font awesome. # Car Battery icon, font awesome
fi
if [[ $CHARGE -lt 10 ]]; then
    # Red-ish
    ICON=" "
    FORMAT="%{F#B33D43} "
elif [[ $CHARGE -lt 30 ]]; then
    # Orange-ish
    ICON=" "
    FORMAT="%{F#F27F24} "
elif [[ $CHARGE -lt 60 ]]; then
    # Orange-ish
    ICON=" "
    FORMAT="%{F#E5C167} "
elif [[ $CHARGE -lt 80 ]]; then
    # Yellow-ish
    ICON=" "
    FORMAT="%{F#E5C167} "
else
    # Green-ish
    ICON=" "
    FORMAT="%{F#6FB379}"
fi
# Format charge & color depending on the status.
FORMAT="$FORMAT$CHARGE $ICON $ICON1 %{F-}"

# Final formatted output.
echo $FORMAT
