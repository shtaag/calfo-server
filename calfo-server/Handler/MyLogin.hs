module Handler.MyLogin where

import Import
import Yesod.Auth.BrowserId
import Yesod.Auth.GoogleEmail
import Yesod.Auth

getMyLoginR :: Handler RepHtml
getMyLoginR = do
  maid <- maybeAuthId
  defaultLayout [whamlet|
    <p>Your current auth ID: #{show maid}
    $maybe _ <- maid
      <p>
        <a href=@{AuthR LogoutR}>Logout
    $nothing
      <p>
        <a href=@{AuthR LoginR}>Go to the Login Page
    |]

