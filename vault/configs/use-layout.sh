#!/bin/sh
# use-layout.sh — switch the MDS vault's Obsidian layout.
#
# Usage: use-layout.sh <producer-console|researcher-graph|agent-ops>
#
# Backs up the vault's current .obsidian/ to .obsidian.bak.<timestamp>/ and copies the
# chosen config set in. POSIX sh; no bashisms.

set -eu

usage() {
    echo "Usage: $0 <producer-console|researcher-graph|agent-ops>" >&2
    exit 2
}

[ "$#" -eq 1 ] || usage

LAYOUT=$1
case "$LAYOUT" in
    producer-console|researcher-graph|agent-ops) ;;
    *)
        echo "error: unknown layout '$LAYOUT'" >&2
        usage
        ;;
esac

# Resolve paths relative to this script: configs/<layout> -> ../.obsidian
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
VAULT_DIR=$(dirname -- "$SCRIPT_DIR")
SRC="$SCRIPT_DIR/$LAYOUT"
DEST="$VAULT_DIR/.obsidian"

[ -d "$SRC" ] || { echo "error: config set not found: $SRC" >&2; exit 1; }

if [ -d "$DEST" ]; then
    BACKUP="$VAULT_DIR/.obsidian.bak.$(date +%Y%m%d%H%M%S)"
    mv -- "$DEST" "$BACKUP"
    echo "backed up current config to $BACKUP"
fi

mkdir -p -- "$DEST"
cp -R -- "$SRC"/. "$DEST"/

echo "installed layout '$LAYOUT' into $DEST"
echo "restart Obsidian (or reload the vault) to apply"
