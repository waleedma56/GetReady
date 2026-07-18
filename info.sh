#!/usr/bin/env bash
#
# info.sh
# A colorful, read-only system dashboard for Linux (Proxmox / Ubuntu / Debian).
# Shows hostname, OS/kernel, uptime, CPU, memory, storage, network (IPs,
# gateway, DNS, public IP) and more, with tidy colored bars.
#
# No changes are made to the system and root is NOT required.
#
# Run it in one line:
#   curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/info.sh | bash
#

set -uo pipefail

# --- Colors ---------------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'
    RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
    BLUE=$'\033[0;34m'; MAGENTA=$'\033[0;35m'; CYAN=$'\033[0;36m'
    RESET=$'\033[0m'
else
    BOLD=''; DIM=''; RED=''; GREEN=''; YELLOW=''
    BLUE=''; MAGENTA=''; CYAN=''; RESET=''
fi

WIDTH=64

# --- Small helpers --------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }

# repeat CHAR N  ->  prints CHAR N times (portable, no seq needed)
repeat() {
    local ch="$1" n="$2" out=''
    while [ "$n" -gt 0 ]; do out="$out$ch"; n=$((n - 1)); done
    printf '%s' "$out"
}

rule() { printf "%b%s%b\n" "$DIM" "$(repeat '-' "$WIDTH")" "$RESET"; }

# section ICON TITLE
section() {
    printf "\n%b%s  %s%b\n" "$BOLD$CYAN" "$1" "$2" "$RESET"
    rule
}

# row LABEL VALUE [VALUE_COLOR]
row() {
    local color="${3:-}"
    printf "  %b%-13s%b %b%s%b\n" "$BOLD" "$1" "$RESET" "$color" "$2" "$RESET"
}

# bar PERCENT  ->  colored usage bar + "NN%"
bar() {
    local pct="$1" width=22 filled empty color
    [ -z "$pct" ] && pct=0
    filled=$(( pct * width / 100 ))
    [ "$filled" -gt "$width" ] && filled=$width
    [ "$filled" -lt 0 ] && filled=0
    empty=$(( width - filled ))
    if   [ "$pct" -ge 90 ]; then color="$RED"
    elif [ "$pct" -ge 70 ]; then color="$YELLOW"
    else color="$GREEN"; fi
    printf "%b%s%b%s%b %b%3s%%%b" \
        "$color" "$(repeat '#' "$filled")" \
        "$DIM"   "$(repeat '.' "$empty")" "$RESET" \
        "$color$BOLD" "$pct" "$RESET"
}

# --- Gather: identity -----------------------------------------------------
HOST="$(hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo unknown)"
FQDN="$(hostname -f 2>/dev/null || echo "$HOST")"

# --- Banner ---------------------------------------------------------------
printf "%b" "$BOLD$MAGENTA"
echo ""
echo "  ###########################################################"
printf  "  #  %bSystem Information%b%b   -   %s\n" "$RESET$BOLD$CYAN" "$RESET" "$BOLD$MAGENTA" "$HOST"
echo "  ###########################################################"
printf "%b" "$RESET"

# --- SYSTEM ---------------------------------------------------------------
section "[*]" "SYSTEM"

OS_NAME="unknown"
if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS_NAME="${PRETTY_NAME:-${NAME:-unknown}}"
fi
row "Hostname"  "$HOST"                                      "$GREEN"
[ "$FQDN" != "$HOST" ] && row "FQDN" "$FQDN" "$GREEN"
row "OS"        "$OS_NAME"                                   "$GREEN"
row "Kernel"    "$(uname -r 2>/dev/null) ($(uname -m 2>/dev/null))" "$GREEN"

if have systemd-detect-virt; then
    VIRT="$(systemd-detect-virt 2>/dev/null || true)"
    [ -n "$VIRT" ] && [ "$VIRT" != "none" ] && row "Virtualization" "$VIRT" "$YELLOW"
fi

if have uptime && uptime -p >/dev/null 2>&1; then
    row "Uptime" "$(uptime -p 2>/dev/null | sed 's/^up //')" "$GREEN"
elif [ -r /proc/uptime ]; then
    UPSEC="$(cut -d. -f1 /proc/uptime 2>/dev/null)"
    if [ -n "${UPSEC:-}" ]; then
        row "Uptime" "$((UPSEC/86400))d $((UPSEC%86400/3600))h $((UPSEC%3600/60))m" "$GREEN"
    fi
fi
row "Date"      "$(date '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null)" "$GREEN"

# --- CPU / LOAD -----------------------------------------------------------
section "[#]" "CPU & LOAD"

CPU_MODEL="$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2- | sed 's/^ *//')"
[ -z "$CPU_MODEL" ] && CPU_MODEL="$(uname -p 2>/dev/null || echo unknown)"
CORES="$(nproc 2>/dev/null || grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo '?')"
row "Model"  "$CPU_MODEL" "$GREEN"
row "Cores"  "$CORES"     "$GREEN"

if [ -r /proc/loadavg ]; then
    read -r L1 L5 L15 _ < /proc/loadavg
    row "Load avg"  "$L1 (1m)   $L5 (5m)   $L15 (15m)" "$GREEN"
fi

# CPU temperature, if the kernel exposes it
for tz in /sys/class/thermal/thermal_zone*/temp; do
    [ -r "$tz" ] || continue
    TRAW="$(cat "$tz" 2>/dev/null)"
    case "$TRAW" in ''|*[!0-9]*) continue ;; esac
    row "Temp" "$((TRAW/1000)) C" "$YELLOW"
    break
done

# --- MEMORY ---------------------------------------------------------------
section "[=]" "MEMORY"

if have free; then
    # Bytes for accurate percentages; free -h for pretty totals.
    read -r _ MT MU _ < <(free -b 2>/dev/null | awk '/^Mem:/{print $1, $2, $3, $4}')
    if [ -n "${MT:-}" ] && [ "$MT" -gt 0 ] 2>/dev/null; then
        MPCT=$(( MU * 100 / MT ))
        MH="$(free -h 2>/dev/null | awk '/^Mem:/{print $3" / "$2}')"
        printf "  %b%-13s%b %s   %b%s%b\n" "$BOLD" "RAM" "$RESET" "$(bar "$MPCT")" "$DIM" "$MH" "$RESET"
    fi
    read -r _ ST SU _ < <(free -b 2>/dev/null | awk '/^Swap:/{print $1, $2, $3, $4}')
    if [ -n "${ST:-}" ] && [ "$ST" -gt 0 ] 2>/dev/null; then
        SPCT=$(( SU * 100 / ST ))
        SH="$(free -h 2>/dev/null | awk '/^Swap:/{print $3" / "$2}')"
        printf "  %b%-13s%b %s   %b%s%b\n" "$BOLD" "Swap" "$RESET" "$(bar "$SPCT")" "$DIM" "$SH" "$RESET"
    fi
else
    row "RAM" "(free not available)" "$DIM"
fi

# --- STORAGE --------------------------------------------------------------
section "[/]" "STORAGE"

DF_OUT="$(df -hP -x tmpfs -x devtmpfs -x overlay -x squashfs -x iso9660 2>/dev/null \
          || df -hP 2>/dev/null)"
if [ -n "$DF_OUT" ]; then
    printf "%s\n" "$DF_OUT" | tail -n +2 | while read -r fs size used avail cap mount; do
        case "$mount" in /dev|/dev/*|/run|/run/*|/sys/*|/proc/*|/snap/*) continue ;; esac
        case "$fs"    in tmpfs|devtmpfs|udev|none|overlay) continue ;; esac
        pct="${cap%\%}"; case "$pct" in ''|*[!0-9]*) pct=0 ;; esac
        printf "  %b%-13s%b %s   %b%s used of %s%b\n" \
            "$BOLD" "$mount" "$RESET" "$(bar "$pct")" "$DIM" "$used" "$size" "$RESET"
    done
else
    row "Disk" "(df not available)" "$DIM"
fi

# --- NETWORK --------------------------------------------------------------
section "[@]" "NETWORK"

# IPv4 addresses per interface (skip loopback)
if have ip; then
    ip -o -4 addr show 2>/dev/null | awk '$2 != "lo" {print $2, $4}' | \
    while read -r iface cidr; do
        row "$iface" "$cidr" "$GREEN"
    done
    GW="$(ip route show default 2>/dev/null | awk '/default/{print $3; exit}')"
    [ -n "${GW:-}" ] && row "Gateway" "$GW" "$GREEN"
elif have hostname; then
    IPS="$(hostname -I 2>/dev/null)"
    [ -n "$IPS" ] && row "IP address" "$IPS" "$GREEN"
fi

# DNS servers
if [ -r /etc/resolv.conf ]; then
    DNS="$(awk '/^nameserver/{print $2}' /etc/resolv.conf 2>/dev/null | paste -sd ' ' - 2>/dev/null)"
    [ -z "$DNS" ] && DNS="$(awk '/^nameserver/{printf "%s ", $2}' /etc/resolv.conf 2>/dev/null)"
    [ -n "$DNS" ] && row "DNS" "$DNS" "$GREEN"
fi

# Public IP (best effort, short timeout, never blocks for long)
PUBIP=""
if have curl; then
    PUBIP="$(curl -fsS --max-time 4 https://api.ipify.org 2>/dev/null)"
elif have wget; then
    PUBIP="$(wget -qO- --timeout=4 https://api.ipify.org 2>/dev/null)"
fi
if [ -n "$PUBIP" ]; then
    row "Public IP" "$PUBIP" "$MAGENTA"
else
    row "Public IP" "(offline or lookup failed)" "$DIM"
fi

# --- SERVICES / SESSIONS --------------------------------------------------
section "[+]" "SERVICES & SESSIONS"

if have docker; then
    if docker info >/dev/null 2>&1; then
        RUN="$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')"
        ALL="$(docker ps -aq 2>/dev/null | wc -l | tr -d ' ')"
        row "Docker" "$RUN running / $ALL total containers" "$GREEN"
    else
        row "Docker" "installed (daemon not reachable)" "$YELLOW"
    fi
fi

if have who; then
    NUSERS="$(who 2>/dev/null | wc -l | tr -d ' ')"
    WHOLIST="$(who 2>/dev/null | awk '{print $1}' | sort -u | paste -sd ' ' - 2>/dev/null)"
    row "Users online" "${NUSERS:-0}${WHOLIST:+  ($WHOLIST)}" "$GREEN"
fi

if have systemctl; then
    FAILED="$(systemctl --failed --no-legend 2>/dev/null | wc -l | tr -d ' ')"
    if [ "${FAILED:-0}" -gt 0 ] 2>/dev/null; then
        row "Failed units" "$FAILED" "$RED"
    else
        row "Failed units" "0" "$GREEN"
    fi
fi

echo ""
rule
printf "%b  Report generated %s%b\n\n" "$DIM" "$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null)" "$RESET"
