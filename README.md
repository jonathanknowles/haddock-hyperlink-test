# `haddock-hyperlink-test`

An experiment that records how Haddock, as bundled with each major version of
GHC, hyperlinks references to identifiers, and whether each link leads to the
identifier's definition.

## 🔗 References

The references are listed in a table in the documentation of module
[`Demo`](src/Demo.hs).

## 📄 Results

Documentation and results for each version of GHC are published here:

https://jonathanknowles.github.io/haddock-hyperlink-test/

## 💻 Running locally

```sh
./check-links.sh
```

This builds the documentation with `cabal haddock`, using the `ghc` on the
path, then shows, for each reference, the target of its link, and whether
that target exists:

| Result           | Meaning                                          |
|------------------|--------------------------------------------------|
| `found`          | The page exists, and defines the anchor.         |
| `anchor missing` | The page exists, but does not define the anchor. |
| `page missing`   | The page does not exist.                         |
| `no link`        | Haddock produced no link.                        |
