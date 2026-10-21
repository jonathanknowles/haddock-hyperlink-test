{-# LANGUAGE ImportQualifiedPost #-}

-- | Each row below shows an import, a reference to the entity exported by the
--   imported module, and the link that Haddock generates for that reference.
--
-- +--------------------------------------+------------------------+--------------------+
-- | Import                               | Reference              | Link               |
-- +======================================+========================+====================+
-- | @import Demo.ModuleA (foo)@          | @\'foo\'@              | 'foo'              |
-- +--------------------------------------+------------------------+--------------------+
-- | @import Demo.ModuleB qualified@      | @\'Demo.ModuleB.bar\'@ | 'Demo.ModuleB.bar' |
-- +--------------------------------------+------------------------+--------------------+
-- | @import Demo.ModuleC qualified as C@ | @\'C.baz\'@            | 'C.baz'            |
-- +--------------------------------------+------------------------+--------------------+
-- | @(none)@                             | @\'Demo.ModuleD.qux\'@ | 'Demo.ModuleD.qux' |
-- +--------------------------------------+------------------------+--------------------+
--
module Demo (examples) where

import Demo.ModuleA (foo)
import Demo.ModuleB qualified
import Demo.ModuleC qualified as C

-- | Uses each import, so that none of them are redundant.
examples :: [Int]
examples = [foo, Demo.ModuleB.bar, C.baz]
