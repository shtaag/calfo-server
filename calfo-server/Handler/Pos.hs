module Handler.Pos where

import Import
import Data.Aeson

data Pos = Pos { lat :: Double, lng :: Double }
  deriving (Show)
instance ToJSON Pos where
  toJSON (Pos latV lngV) = Data.Aeson.object ["lat" .= latV
                                  , "lng" .= lngV]
getPosR :: Handler RepJson
getPosR = do
  let json = encode $ Pos 35.0 136.00
  jsonToRepJson json
