module Handler.Map where

import Import
import Yesod.Form.Nic (YesodNic, nicHtmlField)
import Yesod.Auth

getMapR :: Handler RepHtml
getMapR = do
  (formWidget, formEnctype) <- generateFormPost (messageForm Nothing)
  defaultLayout $ do
    setTitle "Regist Your Message!!"
    $(widgetFile "map_input")

postMapR :: Handler RepHtml
postMapR = do
  requireAuth
  ((result, formWidget), formEnctype) <- runFormPost (messageForm Nothing)
  case result of
    FormSuccess res -> do
       --  $(logInfo) (formSubject res)
        Just maid <- maybeAuthId
        messageId <- runDB $ insert Message {
            messageUser = maid
            , messageSubject = formSubject res
            , messageBody = formBody res
            , messageLat = formLat res
            , messageLng = formLng res
            , messagePublic = formPubl res
            }
        defaultLayout $ do
            setTitle "Your Message!!"
            $(widgetFile "map")
    _ ->
      defaultLayout $ [whamlet|
        <h1> fail.
        |]

data MessageForm = MessageForm {
  formSubject :: Text
, formBody :: Text
, formLat :: Double
, formLng :: Double
, formPubl :: Text
} deriving Show

messageForm :: Maybe MessageForm -> Form MessageForm
messageForm mmessage = renderDivs $ MessageForm
  <$> areq textField "Subject" (fmap formSubject mmessage)
  <*> areq textField "Body" (fmap formBody mmessage)
  <*> areq doubleField "latitude" (fmap formLat mmessage)
  <*> areq doubleField "longitude" (fmap formLng mmessage)
  <*> areq textField "public" (fmap formPubl mmessage)
