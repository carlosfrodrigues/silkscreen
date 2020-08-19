module Main where
import System.Environment
import Util.Data
import App
import Data.Text as T
import Paths_silkscreen

main:: IO()
main = do
    arg <- getArgs
    colorsFileName <- getDataFileName "colors"
    colors <- Prelude.words <$> (readFile colorsFileName)
    templateFileName <- getDataFileName "template.silk"
    template <- readFile $ templateFileName
    content <- readFile $ arg !! 0
    print "Generating HTML file..."
    let htmlGenerated = case (getArgsIndex 1 arg) of
                        Just "--weezer" -> applyWeezerTheme $ generateFullPage (removeExtensionMD (arg !! 0)) content template ["#009CCF", "#BDD639", "#EF1831", "#ECECEC"]
                        _ -> generateFullPage (removeExtensionMD (arg !! 0)) content template colors
    writeFile (removeExtensionMD (arg !! 0) ++ ".html") $ T.unpack htmlGenerated
    print "File successfully created"