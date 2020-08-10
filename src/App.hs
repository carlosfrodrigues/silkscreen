module App where
import Util.Data
import Data.List
import CMark
import qualified Data.Text as T


generateFullPage :: String -> String -> String -> [String] -> T.Text
generateFullPage title content template colors = do
                                                let sectionsList = replaceThreeDashes $ map (T.pack) $ split "---" (sanitizeMarkdown content)
                                                let sections = map (commonmarkToHtml []) $ sectionsList
                                                let templateTitle = T.replace (T.pack "<< +TITLE+ >>") (T.pack title) $ T.pack template
                                                let templateBackgroundColor = T.replace (T.pack "<< +BACKGROUND COLOR+ >>") (generateBackgroundCSS (take (length sections) (cycle colors))) templateTitle
                                                let templateActions = T.replace (T.pack "<< +ACTIONS+ >>") (generateActionsCSS (length sections)) templateBackgroundColor
                                                let templateRadioButtons = T.replace (T.pack "<< +RADIOBUTTONS+ >>") (generateRadioButtons (length sections)) templateActions
                                                T.replace (T.pack "<< +SECTIONS+ >>") (generateSectionsHTML (map (T.unpack) sections)) templateRadioButtons
                                                   

generateBackgroundCSS :: [String] -> T.Text
generateBackgroundCSS colors = T.pack $ intercalate "" ["#pg" ++ show x ++"{\n            background-color: "++ y ++";\n        }\n\n        " | (x,y) <- zip [1..] colors]

generateActionsCSS :: Int -> T.Text
generateActionsCSS size = T.pack $ intercalate "" ["#rd"++ show x ++":checked ~ .sections{\n            margin-top: -" ++ show((x-1)*100) ++"vh;\n        }\n   " | x <- [2..size]]

generateSectionsHTML :: [String] -> T.Text
generateSectionsHTML sections = T.pack $ intercalate "" ["<section class=\"page\" id=\"pg" ++ show x ++ "\"><div>"++ y ++"</div></section>\n" | (x,y) <- zip [1..] sections]

generateRadioButtons :: Int -> T.Text
generateRadioButtons size = T.pack $ intercalate "" [if x == 1 then "<input type=\"radio\" name=\"selectPage\" id=\"rd1\" checked=\"true\" autofocus>\n" else "<input type=\"radio\" name=\"selectPage\" id=\"rd" ++ show x ++ "\">\n" | x <- [1..size]]

replaceThreeDashes :: [T.Text] -> [T.Text]
replaceThreeDashes sections = [if(isInfixOf "<< +THREEDASHES+ >>" (T.unpack txt)) then (T.replace (T.pack "<< +THREEDASHES+ >>") (T.pack "\'---\'") txt) else txt | txt <- sections ]


applyWeezerTheme ::T.Text-> T.Text
applyWeezerTheme fullpage = T.replace (T.pack "body{\n            font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n            font-size: 2vw;\n            color: wheat;\n        }\n\n") (T.pack "body{\n            font-family: \"Century Gothic\", CenturyGothic, AppleGothic, sans-serif;\n            font-size: 2vw;\n            color: black;\n        }\n\n") fullpage
