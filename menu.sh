#!/usr/bin/env bash
#
# menu.sh
# Interactive front-end for the GetReady scripts.
#   * Scans the system to see which components are already installed.
#   * Shows a navigable checklist (GREEN = installed, RED = missing).
#   * Move with Up/Down arrows, toggle with SPACE, activate with ENTER.
#   * Selectable [ Install selected ], [ System info ] and [ Exit ] buttons.
#
# Run as root, straight from the web:
#   curl -fsSL https://raw.githubusercontent.com/waleedma56/GetReady/main/menu.sh | sudo bash
#

set -uo pipefail

RAW_BASE="https://raw.githubusercontent.com/waleedma56/GetReady/main"

# --- Colors ---------------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    BOLD=$'\033[1m'; DIM=$'\033[2m'; REV=$'\033[7m'
    RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; CYAN=$'\033[0;36m'
    RESET=$'\033[0m'
else
    BOLD=''; DIM=''; REV=''; RED=''; GREEN=''; YELLOW=''; CYAN=''; RESET=''
fi

# --- Component catalog ----------------------------------------------------
# Parallel arrays: name / human label / remote script file.
COMPONENTS=("essentials" "docker")
LABELS=("Essential CLI & networking tools" "Docker Engine + Docker Compose")
SCRIPTS=("essentials.sh"                    "docker.sh")

declare -a INSTALLED    # 1 = installed, 0 = missing
declare -a DETAILS      # short status detail string
declare -a SEL          # 1 = selected for install, 0 = not
declare -a ROW_KIND     # "comp" | "action"
declare -a ROW_REF      # component index, or "install" / "exit"

STATUS_DETAIL=""
STTY_SAVE=""

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

build_rows() {
    ROW_KIND=(); ROW_REF=()
    local i
    for i in "${!COMPONENTS[@]}"; do
        ROW_KIND+=("comp");   ROW_REF+=("$i")
    done
    ROW_KIND+=("action"); ROW_REF+=("install")
    ROW_KIND+=("action"); ROW_REF+=("info")
    ROW_KIND+=("action"); ROW_REF+=("exit")
}

# --- Rendering ------------------------------------------------------------
render() {
    local cur="$1" r kind ref box stat statcol label
    printf '\033[H\033[J'   # cursor home + clear to end of screen

    printf "%b" "$BOLD$CYAN"
    echo "=========================================================="
    echo "                  GetReady  -  Setup Menu"
    echo "=========================================================="
    printf "%b" "$RESET"
    printf "  %bUp/Down%b move   %bSPACE%b check/uncheck   %bENTER%b select   %bq%b quit\n" \
        "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET"
    echo "----------------------------------------------------------"

    for r in "${!ROW_KIND[@]}"; do
        kind="${ROW_KIND[$r]}"
        ref="${ROW_REF[$r]}"

        if [ "$kind" = "comp" ]; then
            if [ "${SEL[$ref]}" -eq 1 ]; then box="[x]"; else box="[ ]"; fi
            if [ "${INSTALLED[$ref]}" -eq 1 ]; then
                stat="INSTALLED"; statcol="$GREEN"
            else
                stat="NOT INSTALLED"; statcol="$RED"
            fi
            label="${LABELS[$ref]}"
            if [ "$r" -eq "$cur" ]; then
                printf "%b> %s %-13s %-31s (%s)%b\n" \
                    "$BOLD$REV" "$box" "$stat" "$label" "${DETAILS[$ref]}" "$RESET"
            else
                printf "  %s %b%-13s%b %-31s %b(%s)%b\n" \
                    "$box" "$statcol" "$stat" "$RESET" "$label" "$DIM" "${DETAILS[$ref]}" "$RESET"
            fi
        else
            case "$ref" in
                install) label="[ Install selected ]" ;;
                info)    label="[ System info ]" ;;
                *)       label="[ Exit ]" ;;
            esac
            echo "----------------------------------------------------------"
            if [ "$r" -eq "$cur" ]; then
                printf "%b>  %s%b\n" "$BOLD$REV" "$label" "$RESET"
            else
                printf "   %s\n" "$label"
            fi
        fi
    done
    echo "----------------------------------------------------------"
}

# --- Key input ------------------------------------------------------------
KEY=""
read_key() {
    local k rest
    IFS= read -rsn1 k < /dev/tty || { KEY="quit"; return; }
    case "$k" in
        $'\x1b')
            IFS= read -rsn2 -t 0.05 rest < /dev/tty || rest=""
            case "$rest" in
                '[A') KEY="up" ;;
                '[B') KEY="down" ;;
                *)    KEY="quit" ;;   # bare ESC = quit
            esac
            ;;
        '' ) KEY="enter" ;;
        $'\r'|$'\n') KEY="enter" ;;
        ' ') KEY="space" ;;
        k|K) KEY="up" ;;
        j|J) KEY="down" ;;
        q|Q) KEY="quit" ;;
        *) KEY="other" ;;
    esac
}

enter_raw()  { stty -echo -icanon min 1 time 0 < /dev/tty 2>/dev/null; printf '\033[?25l'; }
leave_raw()  { [ -n "$STTY_SAVE" ] && stty "$STTY_SAVE" < /dev/tty 2>/dev/null; printf '\033[?25h'; }
cleanup()    { leave_raw; printf '\033[0m\n'; }

# --- Actions --------------------------------------------------------------
do_install() {
    local label="$1" script="$2"
    echo ""
    printf "%b>> Installing: %s%b\n" "$BOLD$CYAN" "$label" "$RESET"
    echo "----------------------------------------------------------"
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
    leave_raw
    printf '\033[H\033[J'
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
        printf "%bNothing selected. Highlight an item and press SPACE to check it first.%b\n" \
            "$YELLOW" "$RESET"
    fi
    printf "\nPress Enter to return to the menu..."
    IFS= read -r _ < /dev/tty || true
    scan_all
    enter_raw
}

# Run the read-only system dashboard, then return to the menu.
show_info() {
    leave_raw
    printf '\033[H\033[J'
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || echo .)"
    if [ -f "$dir/info.sh" ]; then
        bash "$dir/info.sh"
    else
        curl -fsSL "$RAW_BASE/info.sh" | bash
    fi
    printf "\nPress Enter to return to the menu..."
    IFS= read -r _ < /dev/tty || true
    enter_raw
}

# --- Guards ---------------------------------------------------------------
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This menu needs root to install packages. Re-run it as:"
    echo "   curl -fsSL ${RAW_BASE}/menu.sh | sudo bash"
    exit 1
fi

if [ ! -e /dev/tty ] || ! (exec < /dev/tty) 2>/dev/null; then
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
build_rows

STTY_SAVE="$(stty -g < /dev/tty 2>/dev/null)"
trap cleanup EXIT INT TERM
enter_raw

cur=0
nrows=${#ROW_KIND[@]}

while true; do
    render "$cur"
    read_key

    case "$KEY" in
        up)    cur=$(( (cur - 1 + nrows) % nrows )) ;;
        down)  cur=$(( (cur + 1) % nrows )) ;;
        space)
            if [ "${ROW_KIND[$cur]}" = "comp" ]; then
                ref="${ROW_REF[$cur]}"
                SEL[$ref]=$(( 1 - SEL[$ref] ))
            fi
            ;;
        enter)
            kind="${ROW_KIND[$cur]}"; ref="${ROW_REF[$cur]}"
            if [ "$kind" = "comp" ]; then
                SEL[$ref]=$(( 1 - SEL[$ref] ))
            elif [ "$ref" = "install" ]; then
                run_selected
            elif [ "$ref" = "info" ]; then
                show_info
            elif [ "$ref" = "exit" ]; then
                break
            fi
            ;;
        quit)  break ;;
        *)     : ;;
    esac
done

cleanup
trap - EXIT INT TERM
echo "Bye."
