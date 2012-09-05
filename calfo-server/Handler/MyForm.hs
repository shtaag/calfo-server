module Handler.MyForm where

import Import

getMyFormR :: Handler RepHtml
getMyFormR = do
  (formWidget, formEnctype) <- generateFormPost (carAForm Nothing)
  defaultLayout $ do
    setTitle "This is ma form"
    $(widgetFile "myform_input")

postMyFormR :: Handler RepHtml
postMyFormR = do
  ((result, formWidget), formEnctype) <- runFormPost (carAForm Nothing)
  case result of
    FormSuccess car -> do
      defaultLayout [whamlet|<h1>#{show car} |]
    _ -> do
      defaultLayout [whamlet|
      <form method=post action=@{MyFormR} enctype=#{formEnctype}>
        <table>
          ^{formWidget}
        <input type=submit>

      |]
    
data Car = Car 
  { carModel :: Text
  , carYear :: Int
  , carColor :: Maybe Text
} deriving Show

carAForm :: Maybe Car -> Form Car
carAForm submission = renderDivs $ Car
  <$> areq textField "Model" (fmap carModel submission)
  <*> areq carYearField "Year" (fmap carYear submission)
  <*> aopt textField "Color" (fmap carColor submission)
  where
    errorMessage :: Text
    errorMessage = "Your Car is too old, gotta get new one!!!!"
    carYearField = checkBool (>=1990) errorMessage intField

    validateYear y
      | y < 1990 = Left errorMessage
      | otherwise = Right y
      
