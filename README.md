# `haddock-hyperlink-test`

An experiment that records how Haddock, as bundled with each major version of
GHC, hyperlinks references to identifiers, and whether each link leads to the
identifier's definition.

## 🔬 Method

The documentation of module [`Demo`](src/Demo.hs) contains several Haddock
references to identifiers, each imported in a different way, or not at all.

This experiment checks whether (or not) Haddock transforms each of these
references into a working hyperlink in the generated documentation.

## 📄 Results

Generated documentation and results for every major version of GHC since 8.0,
and for specific commits of Haddock, are published here:

https://jonathanknowles.github.io/haddock-hyperlink-test/

For each reference, the results show the target of its link, and one of the
following:

| Result                            | Meaning                                                        |
|-----------------------------------|----------------------------------------------------------------|
| ✅ `working link`                 | The link leads to the documentation of the referenced entity.  |
| ❌ `wrong link (another page)`    | The page exists and defines the anchor, but is the wrong page. |
| ❌ `broken link (no such page)`   | The page does not exist.                                       |
| ❌ `broken link (no such anchor)` | The page exists, but does not define the anchor.               |
| ❌ `no link`                      | Haddock produced no link.                                      |

## 💻 Running locally

```sh
./check-links.sh
```

This builds the documentation with `cabal haddock`, using the `ghc` on the
path, then shows, for each reference, the target of its link, and whether
that link leads to the documentation of the referenced entity.

To use a specific build of Haddock, set `HADDOCK` to its path:

```sh
HADDOCK=/path/to/haddock ./check-links.sh
```
