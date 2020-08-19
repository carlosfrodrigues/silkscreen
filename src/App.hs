{-# LANGUAGE OverloadedStrings #-}
module App where
import Util.Data
import Data.List
import CMark
import qualified Data.Text as T


generateFullPage :: String -> String -> String -> [String] -> T.Text
generateFullPage title content template colors = do
    let sectionsList = replaceThreeDashes $ map (T.pack) $ split "---" (sanitizeMarkdown content)
    let sections = map (commonmarkToHtml []) $ sectionsList
    let templateTitle = T.replace "<< +TITLE+ >>" (T.pack title) $ T.pack template
    let templateBackgroundColor = T.replace "<< +BACKGROUND COLOR+ >>" (generateBackgroundCSS (take (length sections) (cycle colors))) templateTitle
    let templateActions = T.replace "<< +ACTIONS+ >>" (generateActionsCSS (length sections)) templateBackgroundColor
    let templateRadioButtons = T.replace "<< +RADIOBUTTONS+ >>" (generateRadioButtons (length sections)) templateActions
    T.replace "<< +SECTIONS+ >>" (generateSectionsHTML (map (T.unpack) sections)) templateRadioButtons
                                                   

generateBackgroundCSS :: [String] -> T.Text
generateBackgroundCSS colors = T.pack $
    intercalate "" [unlines [
        "\t\t#pg" ++ show x ++ " {"
        ,unwords ["\t\t\tbackground-color:",y,";"]
        ,"\t\t}"] | (x,y) <- zip [1 ..] colors]

generateActionsCSS :: Int -> T.Text
generateActionsCSS size = T.pack $
    intercalate "" [unlines [
        "\t\t#rd"++ show x ++":checked ~ .sections{"
        ,"\t\t\tmargin-top: -" ++ show((x-1)*100) ++ "vh;"
        ,"\t\t}"] | x <- [2..size]]

generateSectionsHTML :: [String] -> T.Text
generateSectionsHTML sections = T.pack $
    intercalate "" [unlines [
        "\t\t<section class=\"page\" id=\"pg" ++ show x ++ "\">"
        ,"\t\t\t<div>"++ y ++"</div>"
        ,"\t\t</section>\n"] | (x,y) <- zip [1..] sections]

generateRadioButtons :: Int -> T.Text
generateRadioButtons size = T.pack $
    intercalate "" 
        [if x == 1 then 
            "\t<input type=\"radio\" name=\"selectPage\" id=\"rd1\" checked=\"true\" autofocus>\n" 
        else 
            "\t<input type=\"radio\" name=\"selectPage\" id=\"rd" ++ show x ++ "\">\n"
        | x <- [1..size]]

replaceThreeDashes :: [T.Text] -> [T.Text]
replaceThreeDashes sections = [
    if(isInfixOf "<< +THREEDASHES+ >>" (T.unpack txt)) then 
        (T.replace "<< +THREEDASHES+ >>" "\'---\'" txt) 
    else txt 
    | txt <- sections ]


applyWeezerTheme ::T.Text-> T.Text
applyWeezerTheme fullpage = T.replace
    "body{\n            font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;\n\
    \            font-size: 2vw;\n            color: wheat;\n        }\n\n" "body{\n\
    \            font-family: \"Century Gothic\", CenturyGothic, AppleGothic, sans-serif;\n\
    \            font-size: 2vw;\n            color: black;\n        }\n\n" fullpage
