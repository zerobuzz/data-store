{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -fno-warn-orphans #-} 

module Common
( C01(..)
) where

--------------------------------------------------------------------------------
import           Control.DeepSeq (NFData(..))
--------------------------------------------------------------------------------
import qualified Data.Table as TS
import qualified Data.Store.Internal.Type as DS
import qualified Data.IntSet
import qualified Data.Set
import qualified Data.HashSet

data C01 = C01 
    {-# UNPACK #-} !Int
    {-# UNPACK #-} !Int
                   ![Int]
    deriving Show

instance NFData C01 where
    rnf (C01 x y z) = rnf x `seq` rnf y `seq` rnf z

-- TABLE NFDATA

instance (TS.Tabular a, NFData a, NFData (TS.Tab a (TS.AnIndex a))) => NFData (TS.Table a) where
    rnf (TS.Table tab)  = rnf tab
    rnf (TS.EmptyTable) = rnf () 

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.Primary a) where
    rnf (TS.PrimaryMap m) = rnf m

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.Supplemental a) where
    rnf (TS.SupplementalMap m) = rnf m

instance (NFData t, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.SupplementalInt Int) where
    rnf (TS.SupplementalIntMap m) = rnf m

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.SupplementalHash a) where
    rnf (TS.SupplementalHashMap m) = rnf m

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.Candidate a) where
    rnf (TS.CandidateMap m) = rnf m

instance (NFData t, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.CandidateInt Int) where
    rnf (TS.CandidateIntMap m) = rnf m

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.CandidateHash a) where
    rnf (TS.CandidateHashMap m) = rnf m

instance (NFData t, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.InvertedInt Data.IntSet.IntSet) where
    rnf (TS.InvertedIntMap m) = rnf m

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.Inverted (Data.Set.Set a)) where
    rnf (TS.InvertedMap m) = rnf m

instance (NFData t, NFData a, NFData (TS.PKT t)) => NFData (TS.AnIndex t TS.InvertedHash (Data.HashSet.HashSet a)) where
    rnf (TS.InvertedHashMap m) = rnf m

-- DATA.STORE NFDATA

instance (NFData e, NFData (DS.IKey krs ts), NFData (DS.Index irs ts)) => NFData (DS.Store tag krs irs ts e) where
    rnf (DS.Store ke ix nid) = rnf ke `seq` rnf ix `seq` rnf nid

instance NFData t => NFData (DS.IndexDimension r t) where
    rnf (DS.IndexDimensionO m) = rnf m
    rnf (DS.IndexDimensionM m) = rnf m

instance NFData t => NFData (DS.Index DS.O t) where
    rnf (DS.I1 kd) = rnf kd
     
instance NFData t => NFData (DS.Index DS.M t) where
    rnf (DS.I1 kd) = rnf kd

instance (NFData t, NFData (DS.Index rt tt)) => NFData (DS.Index (r DS.:. rt) (t DS.:. tt)) where
    rnf (DS.IN kd kt) = rnf kd `seq` rnf kt
    rnf (DS.I1 _) = error "Impossible! (Index NFData)"

instance NFData t => NFData (DS.IKeyDimension r t) where
    rnf (DS.IKeyDimensionO x) = rnf x
    rnf (DS.IKeyDimensionM x) = rnf x

instance NFData t => NFData (DS.IKey DS.O t) where
    rnf (DS.K1 kd) = rnf kd
     
instance NFData t => NFData (DS.IKey DS.M t) where
    rnf (DS.K1 kd) = rnf kd

instance (NFData t, NFData (DS.IKey rt tt)) => NFData (DS.IKey (r DS.:. rt) (t DS.:. tt)) where
    rnf (DS.KN kd kt) = rnf kd `seq` rnf kt
    rnf (DS.K1 _) = error "Impossible! (IKey NFData)"
