#!/bin/sh
#
# Builds the documentation with the `ghc` on the path, then shows where each
# reference in the documentation of module "Demo" links to, and whether that
# link works.
#
# Usage: ./check-links.sh
#
# To use a specific build of Haddock, rather than the one that `cabal` would
# choose, set the `HADDOCK` environment variable to its path.

set -eu
cd "$(dirname "$0")"

ghc_version=$(ghc --numeric-version)

# Shows the output of `cabal haddock` only if it fails.
if ! output=$(cabal haddock ${HADDOCK:+"--with-haddock=$HADDOCK"} 2>&1); then
    printf '%s\n' "$output" >&2
    exit 1
fi

html=$(find dist-newstyle -path "*/ghc-$ghc_version/*" -name Demo.html)
dir=$(dirname "$html")

# The version of Haddock that generated the page, as stated in its footer.
haddock_version=$(sed -n 's/.*Haddock<\/a> version \([0-9.]*\).*/\1/p' "$html")

echo "GHC $ghc_version, Haddock $haddock_version:"

# The references in the documentation of module "Demo", read from the
# "Link" column of the table in its source, without quotes.
references=$(awk -F '|' '/^-- [|] @/ { print $4 }' src/Demo.hs | tr -d "'")

if [ -z "$references" ]; then
    echo "No references found in the table in src/Demo.hs." >&2
    exit 1
fi

printf '%s\n' "$references" | while read -r reference; do
    # The name of the referenced entity, without any qualifier.
    name=${reference##*.}
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
    printf '  %-16s %-25s %s\n' "$reference" "${href:--}" "$result"
done
