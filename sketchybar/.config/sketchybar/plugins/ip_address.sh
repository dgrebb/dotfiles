#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)

# ProtonVPN (and other modern macOS VPNs) use Network Extension services,
# not the legacy ipsec0 interface the old check relied on.
is_vpn_connected() {
  # System VPN / Network Extension services: ProtonVPN, etc.
  if scutil --nc list 2>/dev/null | grep -qiE '\(Connected\).*VPN:'; then
    return 0
  fi

  # Named ProtonVPN service (registered as "ProtonVPN" / ch.protonvpn.mac)
  local proton_status
  proton_status="$(scutil --nc status "ProtonVPN" 2>/dev/null | head -1)"
  if [[ "$proton_status" == "Connected" ]]; then
    return 0
  fi

  # Legacy IPsec
  if ifconfig ipsec0 2>/dev/null | grep -q 'inet '; then
    return 0
  fi

  # WireGuard / tunnel with an assigned IPv4 (Apple's idle utuns are IPv6-only)
  if ifconfig 2>/dev/null | awk '
    /^[a-z]/ { iface=$1; sub(/:$/, "", iface) }
    iface ~ /^(utun|ipsec|ppp|tun)/ && $1 == "inet" { found=1; exit }
    END { exit !found }
  '; then
    return 0
  fi

  return 1
}

if is_vpn_connected; then
  COLOR=$LIGHT_BLUE
  ICON=
elif [[ -n $IP_ADDRESS ]]; then
  COLOR=$BLUE
  ICON=
else
  COLOR=$WHITE
  ICON=
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR"
