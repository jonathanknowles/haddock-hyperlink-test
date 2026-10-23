-- | Each row below shows an import, a reference to the entity exported by the
--   imported module, the link that Haddock generates for that reference, and
--   the module that this link is expected to target.
--
-- +--------------------------------------+------------------------+--------------------+------------------------+
-- | Import                               | Reference              | Link               | Expected Target Module |
-- +======================================+========================+====================+========================+
-- | @import Demo.ModuleA (foo)@          | @\'foo\'@              | 'foo'              | "Demo.ModuleA"         |
-- +--------------------------------------+------------------------+--------------------+------------------------+
-- | @import qualified Demo.ModuleB@      | @\'Demo.ModuleB.bar\'@ | 'Demo.ModuleB.bar' | "Demo.ModuleB"         |
-- +--------------------------------------+------------------------+--------------------+------------------------+
-- | @import qualified Demo.ModuleC as C@ | @\'C.baz\'@            | 'C.baz'            | "Demo.ModuleC"         |
-- +--------------------------------------+------------------------+--------------------+------------------------+
-- | @(none)@                             | @\'Demo.ModuleD.qux\'@ | 'Demo.ModuleD.qux' | "Demo.ModuleD"         |
-- +--------------------------------------+------------------------+--------------------+------------------------+
--
module Demo (examples) where

import Demo.ModuleA (foo)
import qualified Demo.ModuleB
import qualified Demo.ModuleC as C

-- | Uses each import, so that none of them are redundant.
examples :: [Int]
examples = [foo, Demo.ModuleB.bar, C.baz]
