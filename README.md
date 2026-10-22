# `haddock-hyperlink-test`

An experiment that records how Haddock, as bundled with each major version of
GHC, hyperlinks references to identifiers, and whether each link leads to the
identifier's definition.

## 🔬 Method

The documentation of module [`Demo`](src/Demo.hs) contains several Haddock
references to identifiers, each imported in a different way, or not at all.

A table in that documentation shows each import, each reference, and the link
that Haddock produces.

## 📄 Results

Documentation and results for each version of GHC are published here:

https://jonathanknowles.github.io/haddock-hyperlink-test/

For each reference, the results show the target of its link, and one of the
following:

| Result                            | Meaning                                          |
|-----------------------------------|--------------------------------------------------|
| ✅ `working link`                 | The page exists, and defines the anchor.         |
| ❌ `broken link (no such page)`   | The page does not exist.                         |
| ❌ `broken link (no such anchor)` | The page exists, but does not define the anchor. |
| ❌ `no link`                      | Haddock produced no link.                        |

## 💻 Running locally

```sh
./check-links.sh
```

This builds the documentation with `cabal haddock`, using the `ghc` on the
path, then shows, for each reference, the target of its link, and whether
that link works.

To use a specific build of Haddock, set `HADDOCK` to its path:

```sh
HADDOCK=/path/to/haddock ./check-links.sh
```
