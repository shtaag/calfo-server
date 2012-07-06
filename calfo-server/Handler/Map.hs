module Handler.Map where

import Import

getMapR :: Handler RepHtml
getMapR = do
  defaultLayout $ do
    [whamlet|<h1>Map here!!|]
