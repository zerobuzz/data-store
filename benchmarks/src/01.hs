{-# LANGUAGE GADTs #-}
{-# LANGUAGE CPP   #-}

module Main
( main
) where

-- #define BENCH_SMALL
-- #define BENCH_ESSENTIALS

--------------------------------------------------------------------------------
import           Control.DeepSeq (NFData(..))
import           Control.Exception.Base (evaluate)
import           Control.Monad.Trans (liftIO)
--------------------------------------------------------------------------------
import           Data.List
import qualified Data.Map.Strict as Data.Map
--------------------------------------------------------------------------------
import qualified Criterion.Config as C
import qualified Criterion.Main   as C
--------------------------------------------------------------------------------
import qualified DS.B01
import qualified TS.B01
import qualified IS.B01
--------------------------------------------------------------------------------
import Common
--------------------------------------------------------------------------------

data RNF where
    RNF :: NFData a => a -> RNF

instance NFData RNF where
    rnf (RNF x) = rnf x

main :: IO ()
main = C.defaultMainWith C.defaultConfig (liftIO . evaluate $ rnf
  [
    RNF elems200000
  , RNF map200000
  , RNF ds200000
  , RNF is200000
  , RNF ts200000

#ifdef BENCH_SMALL
  , RNF elems50000
  , RNF elems100000
  
  , RNF ds50000
  , RNF ds100000

  , RNF map50000
  , RNF map100000
  
  , RNF is50000
  , RNF is100000
 
  , RNF ts50000
  , RNF ts100000
#endif

  , RNF elem9999999
  , RNF elem2500
  ])
  -- Insert 1 element into a store of size N. No collisions.
  [
#ifdef BENCH_SMALL
    C.bgroup "insertLookup (Int) 01 100000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.insertLookup 9999999 9999999 9999999) ds100000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.insertLookup 9999999 9999999 9999999) is100000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.insertLookup 9999999 9999999 9999999) ts100000
#endif
      ]
    ] ,
#endif
    C.bgroup "insertLookup (Int) 01 200000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.insertLookup 9999999 9999999 9999999) ds200000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.insertLookup 9999999 9999999 9999999) is200000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.insertLookup 9999999 9999999 9999999) ts200000
#endif
      ]
    ]
#ifdef BENCH_SMALL
  , C.bgroup "insertLookup-collision(1) (Int) 01 100000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.insertLookup 20000 9999999 9999999) ds100000
#ifndef BENCH_DS
      , C.bench "TS" $ C.whnf (forceList . TS.B01.insertLookup 20000 9999999 9999999) ts100000
#endif
      ]
    ]
#endif
  , C.bgroup "insertLookup-collision(1) (Int) 01 200000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.insertLookup 20000 9999999 9999999) ds200000
#ifndef BENCH_DS
      , C.bench "TS" $ C.whnf (forceList . TS.B01.insertLookup 20000 9999999 9999999) ts200000
#endif
      ]
    ]
#ifdef BENCH_SMALL
  , C.bgroup "insert (Int) 01 100000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (DS.B01.insert elem9999999) ds100000
#ifndef BENCH_DS
      , C.bench "Map" $ C.whnf (insertMap elem9999999) map100000
#endif
      ]
    ]
#endif
  , C.bgroup "insert (Int) 01 200000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (DS.B01.insert elem9999999) ds200000
#ifndef BENCH_DS
      , C.bench "Map" $ C.whnf (insertMap elem9999999) map200000
#endif
      ]
    ]
#ifdef BENCH_SMALL
  , C.bgroup "lookup OO EQ (Int) 01 50000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOOEQ 10000) ds50000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOOEQLens 10000) ds50000
#ifndef BENCH_DS
      , C.bench "Map" $ C.nf (Data.Map.lookup 10000) map50000
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOOEQ 10000) is50000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOOEQ 10000) ts50000
#endif
      ]
    ]
  , C.bgroup "lookup OO GE (Int) 01 50000 (500)"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOOGE 49500) ds50000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOOGELens 99500) ds50000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOOGE 49500) is50000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOOGE 49500) ts50000
#endif
      ]
    ]
  , C.bgroup "lookup OM EQ (Int) 01 50000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOMEQ 200) ds50000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOMEQLens 200) ds50000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOMEQ 200) is50000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOMEQ 200) ts50000
#endif
      ]
    ]
  , C.bgroup "lookup OM GE (Int) 01 50000 (500)"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOMGE 9900) ds50000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOMGELens 9900) ds50000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOMGE 9900) is50000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOMGE 9900) ts50000
#endif
      ]
    ]
  , C.bgroup "lookup MM EQ (Int) 01 50000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupMMEQ 200) ds50000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupMMEQLens 200) ds50000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupMMEQ 200) is50000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupMMEQ 200) ts50000
#endif
      ]
    ]
  , C.bgroup "lookup OO EQ (Int) 01 100000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOOEQ 10000) ds100000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOOEQLens 10000) ds100000
#ifndef BENCH_DS
      , C.bench "Map" $ C.nf (Data.Map.lookup 10000) map100000
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOOEQ 10000) is100000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOOEQ 10000) ts100000
#endif
      ]
    ]
  , C.bgroup "lookup OO GE (Int) 01 100000 (500)"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOOGE 99500) ds100000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOOGELens 99500) ds100000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOOGE 99500) is100000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOOGE 99500) ts100000
#endif
      ]
    ]
  , C.bgroup "lookup OM EQ (Int) 01 100000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOMEQ 200) ds100000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOMEQLens 200) ds100000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOMEQ 200) is100000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOMEQ 200) ts100000
#endif
      ]
    ]
  , C.bgroup "lookup OM GE (Int) 01 100000 (500)"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOMGE 19900) ds100000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOMGELens 19900) ds100000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOMGE 19900) is100000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOMGE 19900) ts100000
#endif
      ]
    ]
  , C.bgroup "lookup MM EQ (Int) 01 100000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupMMEQ 200) ds100000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupMMEQLens 200) ds100000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupMMEQ 200) is100000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupMMEQ 200) ts100000
#endif
      ]
    ]
#endif
  , C.bgroup "lookup OO EQ (Int) 01 200000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOOEQ 10000) ds200000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOOEQLens 10000) ds200000
#ifndef BENCH_DS
      , C.bench "Map" $ C.nf (Data.Map.lookup 10000) map200000
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOOEQ 10000) is200000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOOEQ 10000) ts200000
#endif
      ]
    ]
  , C.bgroup "lookup OO GE (Int) 01 200000 (500)"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOOGE 199500) ds200000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOOGELens 199500) ds200000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOOGE 199500) is200000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOOGE 199500) ts200000
#endif
      ]
    ]
  , C.bgroup "lookup OM EQ (Int) 01 200000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOMEQ 200) ds200000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOMEQLens 200) ds200000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOMEQ 200) is200000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOMEQ 200) ts200000
#endif
      ]
    ]
  , C.bgroup "lookup OM GE (Int) 01 200000 (500)"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupOMGE 39900) ds200000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupOMGELens 39900) ds200000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupOMGE 39900) is200000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupOMGE 39900) ts200000
#endif
      ]
    ]
  , C.bgroup "lookup MM EQ (Int) 01 200000"
    [ C.bcompare
      [ C.bench "DS" $ C.whnf (forceList . DS.B01.lookupMMEQ 200) ds200000
      --, C.bench "DS (Lens)" $ C.whnf (forceList . DS.B01.lookupMMEQLens 200) ds200000
#ifndef BENCH_DS
      , C.bench "IS" $ C.whnf (forceList . IS.B01.lookupMMEQ 200) is200000
      , C.bench "TS" $ C.whnf (forceList . TS.B01.lookupMMEQ 200) ts200000
#endif
      ]
    ]
  ]


---

insertListDS :: [C01] -> DS.B01.DS -> DS.B01.DS
insertListDS xs s0 = foldl' (flip DS.B01.insert) s0 xs

insertListTS :: [C01] -> TS.B01.TS -> TS.B01.TS
insertListTS xs s0 = snd $!
  foldl' (\(n, acc) x -> if n == t
                           then rnf acc `seq` (0, TS.B01.insert x acc)
                           else (n + 1, TS.B01.insert x acc)
         ) (0 :: Int, s0) xs
  where t = 10000

insertListIS :: [C01] -> IS.B01.IS -> IS.B01.IS
insertListIS xs s0 = snd $! 
  foldl' (\(n, acc) x -> if n == t
                           then rnf acc `seq` (0, IS.B01.insert x acc)
                           else (n + 1, IS.B01.insert x acc)
         ) (0 :: Int, s0) xs
  where t = 10000

insertListMap :: [C01] -> Data.Map.Map Int C01 -> Data.Map.Map Int C01
insertListMap xs s0 = foldl' (flip insertMap) s0 xs

insertMap :: C01 -> Data.Map.Map Int C01 -> Data.Map.Map Int C01
insertMap x@(C01 oo _ _) = Data.Map.insert oo x

-- MAP

#ifdef BENCH_SMALL
map50000 :: Data.Map.Map Int C01
map50000 = insertListMap elems50000 Data.Map.empty

map100000 :: Data.Map.Map Int C01
map100000 = insertListMap elems100000 Data.Map.empty
#endif

map200000 :: Data.Map.Map Int C01
map200000 = insertListMap elems200000 Data.Map.empty

-- IS

#ifdef BENCH_SMALL
is50000 :: IS.B01.IS
is50000 = insertListIS elems50000 IS.B01.empty

is100000 :: IS.B01.IS
is100000 = insertListIS elems100000 IS.B01.empty
#endif

is200000 :: IS.B01.IS
is200000 = insertListIS elems200000 IS.B01.empty

-- DS

#ifdef BENCH_SMALL
ds50000 :: DS.B01.DS
ds50000 = insertListDS elems50000 DS.B01.empty

ds100000 :: DS.B01.DS
ds100000 = insertListDS elems100000 DS.B01.empty
#endif

ds200000 :: DS.B01.DS
ds200000 = insertListDS elems200000 DS.B01.empty

-- TS

#ifdef BENCH_SMALL
ts50000 :: TS.B01.TS
ts50000 = insertListTS elems50000 TS.B01.empty

ts100000 :: TS.B01.TS
ts100000 = insertListTS elems100000 TS.B01.empty
#endif

ts200000 :: TS.B01.TS
ts200000 = insertListTS elems200000 TS.B01.empty

