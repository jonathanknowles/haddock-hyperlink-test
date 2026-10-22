#!/bin/sh
#
# Builds the documentation with the `ghc` on the path, then shows where each
# reference in the documentation of module "Demo" links to, and whether that
# link works.
#
# Usage: ./check-links.sh

set -eu
cd "$(dirname "$0")"

ghc_version=$(ghc --numeric-version)

cabal haddock >/dev/null

html=$(find dist-newstyle -path "*/ghc-$ghc_version/*" -name Demo.html)
dir=$(dirname "$html")

# The version of Haddock that generated the page, as stated in its footer.
haddock_version=$(sed -n 's/.*Haddock<\/a> version \([0-9.]*\).*/\1/p' "$html")

echo "GHC $ghc_version, Haddock $haddock_version:"

# The names of the entities that "Demo" refers to.
names="foo bar baz qux"

for name in $names; do
    # The link for a reference to entity `x` has a target ending in `#v:x`.
    href=$(grep -o "href=\"[^\"]*#v:$name\"" "$html" \
        | head -n 1 | sed 's/^href="\(.*\)"$/\1/')
    if [ -z "$href" ]; then
        result="❌ no link"
    elif [ ! -f "$dir/${href%%#*}" ]; then
        result="❌ broken link (no such page)"
    elif ! grep -q "id=\"${href#*#}\"" "$dir/${href%%#*}"; then
        result="❌ broken link (no such anchor)"
    else
        result="✅ working link"
    fi
    printf '  %-4s %-25s %s\n' "$name" "${href:--}" "$result"
done
