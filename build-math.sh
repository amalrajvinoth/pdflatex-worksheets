#!/usr/bin/env bash
# Build math-under-100 with type, pages, and optional carry/borrow presets.
# Usage:
#   ./build-math.sh add <pages> [carry_preset] [title]
#   ./build-math.sh sub <pages> [borrow_preset] [title]
#   ./build-math.sh mixed <pages> [carry_preset] [borrow_preset] [title]
#
# Types: add (addition only), sub (subtraction only), mixed (addition + subtraction)
# Carry presets: no_carry, light_carry, full_carry
# Borrow presets: no_borrow, light_borrow, full_borrow
#
# Examples:
#   ./build-math.sh add 5
#   ./build-math.sh add 5 full_carry "Full Carry"
#   ./build-math.sh sub 5 light_borrow "Light Borrow"
#   ./build-math.sh sub 5 full_borrow "Full Borrow"
#   ./build-math.sh mixed 9 light_carry light_borrow "Light Mixed"

set -e
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="${SELF_DIR}/src"
PDF_DIR="${SELF_DIR}/pdf"
TYPE="${1:-add}"
PAGES="${2:-5}"

add_opts_for_carry() {
  case "$1" in
    no_carry)   echo "tens min=1, tens max=4, ones min=0, ones max=9, carry=0" ;;
    light_carry) echo "tens min=1, tens max=5, ones min=5, ones max=9, carry=1" ;;
    full_carry) echo "tens min=2, tens max=5, ones min=5, ones max=9, carry=1" ;;
    *)          echo "tens min=1, tens max=5, ones min=5, ones max=9, carry=1" ;; # default light_carry
  esac
}

sub_opts_for_borrow() {
  case "$1" in
    no_borrow)   echo "tens min=2, tens max=9, ones min=0, ones max=9, borrow=0" ;;
    light_borrow) echo "tens min=3, tens max=9, ones min=0, ones max=4, borrow=1" ;;
    full_borrow) echo "tens min=5, tens max=9, ones min=0, ones max=3, borrow=1" ;;
    *)           echo "tens min=2, tens max=9, ones min=0, ones max=9, borrow=0" ;; # default no_borrow
  esac
}

case "$TYPE" in
  add)
    CARRY_PRESET="${3:-light_carry}"
    TITLE="${4:-Light Carry}"
    ADD_OPTS=$(add_opts_for_carry "$CARRY_PRESET")
    SUB_OPTS=""
    ;;
  sub)
    BORROW_PRESET="${3:-light_borrow}"
    TITLE="${4:-Light Borrow}"
    ADD_OPTS=""
    SUB_OPTS=$(sub_opts_for_borrow "$BORROW_PRESET")
    ;;
  mixed)
    CARRY_PRESET="${3:-no_carry}"
    BORROW_PRESET="${4:-no_borrow}"
    TITLE="${5:-Mixed}"
    ADD_OPTS=$(add_opts_for_carry "$CARRY_PRESET")
    SUB_OPTS=$(sub_opts_for_borrow "$BORROW_PRESET")
    ;;
  *)
    echo "Unknown type: $TYPE (use 'add', 'sub', or 'mixed')" >&2
    echo "Carry presets: no_carry, light_carry, full_carry" >&2
    echo "Borrow presets: no_borrow, light_borrow, full_borrow" >&2
    exit 1
    ;;
esac

CFG="${SRC_DIR}/math-build.cfg"
cat > "$CFG" << EOF
\\MakeMathSheet{$TYPE}{$ADD_OPTS}{$SUB_OPTS}{$PAGES}{$TITLE}%
EOF

cd "$SRC_DIR"
pdflatex -interaction=nonstopmode -jobname=math-under-100-run math-under-100-run.tex

OUTPUT="$SRC_DIR/math-under-100-run.pdf"
if [ -f "$OUTPUT" ]; then
  cp "$OUTPUT" "$PDF_DIR/math-under-100-run.pdf"
  if [ "$TYPE" = "mixed" ]; then
    echo "Written: pdf/math-under-100-run.pdf (type=$TYPE, pages=$PAGES, carry=$CARRY_PRESET, borrow=$BORROW_PRESET)"
  elif [ "$TYPE" = "sub" ]; then
    echo "Written: pdf/math-under-100-run.pdf (type=$TYPE, pages=$PAGES, borrow=$BORROW_PRESET)"
  else
    echo "Written: pdf/math-under-100-run.pdf (type=$TYPE, pages=$PAGES, carry=$CARRY_PRESET)"
  fi
fi
