#!/bin/sh
#
# Builds the documentation with the `ghc` on the path, then shows where each
# reference in the documentation of module "Demo" links to, and whether that
# link leads to the documentation of the referenced entity.
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

# The references in the documentation of module "Demo", each followed by the
# module that its link is expected to target, read from the "Link" and
# "Expected Target Module" columns of the table in its source, without quotes.
references=$(awk -F '|' '/^-- [|] @/ { print $4, $5 }' src/Demo.hs | tr -d "'\"")

if [ -z "$references" ]; then
    echo "No references found in the table in src/Demo.hs." >&2
    exit 1
fi

# The length of the longest reference, so that the results line up.
width=$(printf '%s\n' "$references" \
    | awk '{ if (length($1) > w) w = length($1) } END { print w }')

# The names referred to so far, one per line.
seen=

printf '%s\n' "$references" | while read -r reference module; do
    # The name of the referenced entity, without any qualifier.
    name=${reference##*.}
    # The page that the link is expected to target.
    page=$(printf '%s' "$module" | tr . -).html
    # References to the same name appear in the documentation in the same
    # order as in the table, so the nth reference to a name is the nth link
    # to that name.
    seen="$seen
$name"
    n=$(printf '%s\n' "$seen" | grep -cx "$name")
    # The link for a reference to entity `x` has a target ending in `#v:x`.
    href=$(grep -o "href=\"[^\"]*#v:$name\"" "$html" \
        | sed -n "${n}p" | sed 's/^href="\(.*\)"$/\1/')
    if [ -z "$href" ]; then
        result="❌ fail (no link generated)"
    elif [ ! -f "$dir/${href%%#*}" ]; then
        result="❌ fail (no such page)"
    elif ! grep -q "id=\"${href#*#}\"" "$dir/${href%%#*}"; then
        result="❌ fail (no such anchor)"
    elif [ "${href%%#*}" != "$page" ]; then
        result="❌ fail (wrong page)"
    else
        result="✅ pass"
    fi
    printf '  %-*s %-25s %s\n' "$width" "$reference" "${href:--}" "$result"
done
