module MoteRunner.Options where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Validation.Semigroup (unV)
import Node.Optlicative (Optlicative, defaultPreferences, flag, optional, optlicate, renderErrors, string)
import Node.Process (PROCESS)

type Config =
  { pattern ∷ Maybe String
  , list ∷ Boolean
  }

parseConfig
  ∷ ∀ e
  . Eff (process ∷ PROCESS | e) (Either String Config)
parseConfig = do
  { value } ← optlicate {} (defaultPreferences { globalOpts = parseConfig' })
  pure $ unV (Left <<< renderErrors) Right value

parseConfig' :: Optlicative Config
parseConfig' = {pattern: _, list: _}
  <$> optional (string "pattern" Nothing)
  <*> flag "list" Nothing
