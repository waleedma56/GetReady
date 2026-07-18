#!/usr/bin/env bash
#
# menu.sh
# Interactive front-end for the GetReady scripts.
#   * Scans the system to see which components are already installed.
#   * Shows a colored checklist (GREEN = installed, RED = missing).
#   * Lets you check / uncheck what you want, then installs the selection.
#
# Run as root, straight from the web:
#   curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/menu.sh | sudo bash
#

set -uo pipefail

RAW_BASE="https://raw.githubusercontent.com/waleedma56/GetReady/main"

# --- Colors ---------------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'
    RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; CYAN=$'\033[0;36m'
    RESET=$'\033[0m'
else
    BOLD=''; DIM=''; RED=''; GREEN=''; YELLOW=''; CYAN=''; RESET=''
fi

# --- Component catalog ----------------------------------------------------
# Parallel arrays: name / human label / remote script file.
COMPONENTS=("essentials" "docker")
LABELS=("Essential CLI & networking tools" "Docker Engine + Docker Compose")
SCRIPTS=("essentials.sh"                    "docker.sh")

# Filled in by scan_all():
declare -a INSTALLED    # 1 = installed, 0 = missing
declare -a DETAILS      # short status detail string
declare -a SEL          # 1 = selected for install, 0 = not

STATUS_DETAIL=""

# --- Detection ------------------------------------------------------------
is_installed() {
    STATUS_DETAIL=""
    case "$1" in
        essentials)
            local tools="curl wget git nano vim htop zip unzip nmap traceroute iftop tcpdump dig ifconfig ping gpg sudo lsb_release"
            local total=0 have=0 t
            for t in $tools; do
                total=$((total + 1))
                if command -v "$t" >/dev/null 2>&1; then
                    have=$((have + 1))
                fi
            done
            STATUS_DETAIL="${have}/${total} tools present"
            if [ "$have" -eq "$total" ]; then return 0; else return 1; fi
            ;;
        docker)
            if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
                if docker info >/dev/null 2>&1; then
                    STATUS_DETAIL="engine + compose, daemon running"
                else
                    STATUS_DETAIL="installed, daemon not running"
                fi
                return 0
            fi
            STATUS_DETAIL="not installed"
            return 1
            ;;
        *)
            STATUS_DETAIL="unknown component"
            return 1
            ;;
    esac
}

scan_all() {
    local i
    for i in "${!COMPONENTS[@]}"; do
        if is_installed "${COMPONENTS[$i]}"; then
            INSTALLED[$i]=1
        else
            INSTALLED[$i]=0
        fi
        DETAILS[$i]="$STATUS_DETAIL"
    done
}

# Pre-select everything that is NOT yet installed.
init_selection() {
    local i
    for i in "${!COMPONENTS[@]}"; do
        if [ "${INSTALLED[$i]}" -eq 0 ]; then SEL[$i]=1; else SEL[$i]=0; fi
    done
}

# --- Rendering ------------------------------------------------------------
clear_screen() { clear 2>/dev/null || printf '\033[2J\033[H'; }

render() {
    clear_screen
    printf "%b" "$BOLD$CYAN"
    echo "=========================================================="
    echo "                  GetReady  -  Setup Menu"
    echo "=========================================================="
    printf "%b" "$RESET"
    printf "  Legend:  %bINSTALLED%b   %bNOT INSTALLED%b   [x] selected  [ ] not\n" \
        "$GREEN" "$RESET" "$RED" "$RESET"
    echo "----------------------------------------------------------"

    local i box status_txt status_col
    for i in "${!COMPONENTS[@]}"; do
        if [ "${SEL[$i]}" -eq 1 ]; then box="[x]"; else box="[ ]"; fi
        if [ "${INSTALLED[$i]}" -eq 1 ]; then
            status_col="$GREEN"; status_txt="INSTALLED    "
        else
            status_col="$RED";   status_txt="NOT INSTALLED"
        fi
        printf "  %b%d)%b %s  %b%s%b  %-32s %b%s%b\n" \
            "$BOLD" "$((i + 1))" "$RESET" \
            "$box" \
            "$status_col" "$status_txt" "$RESET" \
            "${LABELS[$i]}" \
            "$DIM" "(${DETAILS[$i]})" "$RESET"
    done

    echo "----------------------------------------------------------"
    printf "  %b1-%d%b toggle item    %ba%b all missing    %bn%b none\n" \
        "$BOLD" "${#COMPONENTS[@]}" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET"
    printf "  %bi%b install selected    %br%b re-scan    %bq%b quit\n" \
        "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET"
    echo "----------------------------------------------------------"
}

# --- Actions --------------------------------------------------------------
do_install() {
    local label="$1" script="$2"
    echo ""
    printf "%b>> Installing: %s%b\n" "$BOLD$CYAN" "$label" "$RESET"
    echo "----------------------------------------------------------"

    # Prefer a local copy (when the repo is cloned) else fetch from the web.
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || echo .)"
    if [ -f "$dir/$script" ]; then
        bash "$dir/$script"
    else
        curl -fsSL "$RAW_BASE/$script" | bash
    fi
}

run_selected() {
    local any=0 i
    for i in "${!COMPONENTS[@]}"; do
        if [ "${SEL[$i]}" -eq 1 ]; then
            any=1
            if do_install "${LABELS[$i]}" "${SCRIPTS[$i]}"; then
                printf "%b   Done: %s%b\n" "$GREEN" "${COMPONENTS[$i]}" "$RESET"
                SEL[$i]=0
            else
                printf "%b   Errors while installing %s (see output above).%b\n" \
                    "$RED" "${COMPONENTS[$i]}" "$RESET"
            fi
        fi
    done

    if [ "$any" -eq 0 ]; then
        printf "%bNothing selected. Toggle an item by its number first.%b\n" "$YELLOW" "$RESET"
    fi

    printf "\nPress Enter to return to the menu..." > /dev/tty
    IFS= read -r _ < /dev/tty || true
    scan_all
}

# --- Guards ---------------------------------------------------------------
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This menu needs root to install packages. Re-run it as:"
    echo "   curl -fsSL ${RAW_BASE}/menu.sh | sudo bash"
    exit 1
fi

if [ ! -e /dev/tty ] || ! (exec < /dev/tty) 2>/dev/null; then
    # No interactive terminal: just report status and exit.
    scan_all
    echo "No interactive terminal detected - showing status only:"
    for i in "${!COMPONENTS[@]}"; do
        if [ "${INSTALLED[$i]}" -eq 1 ]; then s="INSTALLED"; else s="NOT INSTALLED"; fi
        printf "  - %-34s %s (%s)\n" "${LABELS[$i]}" "$s" "${DETAILS[$i]}"
    done
    echo ""
    echo "Run in an interactive shell to select and install components."
    exit 0
fi

# --- Main loop ------------------------------------------------------------
scan_all
init_selection

while true; do
    render
    printf "%b Choose: %b" "$BOLD" "$RESET" > /dev/tty
    if ! IFS= read -r choice < /dev/tty; then
        echo ""
        break
    fi

    case "$choice" in
        [0-9]|[0-9][0-9])
            idx=$((choice - 1))
            if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#COMPONENTS[@]}" ]; then
                SEL[$idx]=$((1 - ${SEL[$idx]}))
            fi
            ;;
        a|A)
            for i in "${!COMPONENTS[@]}"; do
                if [ "${INSTALLED[$i]}" -eq 0 ]; then SEL[$i]=1; fi
            done
            ;;
        n|N)
            for i in "${!COMPONENTS[@]}"; do SEL[$i]=0; done
            ;;
        r|R)
            scan_all
            ;;
        i|I)
            run_selected
            ;;
        q|Q)
            break
            ;;
        *)
            : # ignore unknown input
            ;;
    esac
done

echo ""
echo "Bye."
