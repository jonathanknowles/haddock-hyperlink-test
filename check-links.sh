#!/bin/sh
#
# Builds the documentation with the `ghc` on the path, then shows where each
# reference in the documentation of module "Demo" links to, and whether that
# target exists.
#
# Usage: ./check-links.sh

set -eu
cd "$(dirname "$0")"

version=$(ghc --numeric-version)
echo "GHC $version:"

cabal haddock >/dev/null

html=$(find dist-newstyle -path "*/ghc-$version/*" -name Demo.html)
dir=$(dirname "$html")

# The names of the entities that "Demo" refers to.
names="foo bar baz qux"

for name in $names; do
    # The link for a reference to entity `x` has a target ending in `#v:x`.
    href=$(grep -o "href=\"[^\"]*#v:$name\"" "$html" \
        | head -n 1 | sed 's/^href="\(.*\)"$/\1/')
    if [ -z "$href" ]; then
        result="no link"
    elif [ ! -f "$dir/${href%%#*}" ]; then
        result="page missing"
    elif ! grep -q "id=\"${href#*#}\"" "$dir/${href%%#*}"; then
        result="anchor missing"
    else
        result="found"
    fi
    printf '  %-4s %-25s %s\n' "$name" "${href:--}" "$result"
done
