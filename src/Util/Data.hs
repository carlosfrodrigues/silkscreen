module Util.Data
(split
,sanitizeMarkdown
,removeExtensionMD
,getArgsIndex) where

import Data.List
import qualified Data.Text as T

(!!!) array (m, n) = drop m (take n array)

findString :: String -> String -> [Int]
findString search str = findIndices (isPrefixOf search) (tails str)

normalizeArray :: [Int] -> Int -> [Int]
normalizeArray array size =  zipWith (-) array $ 0:( map (+ size) $ init array)

splitbyIndices :: String -> [Int] -> Int -> [String]
splitbyIndices str (x:xs) size = str !!! (0, x):splitbyIndices (str !!! (x+size, length str)) xs size
splitbyIndices _ [] _ = []

split :: String -> String -> [String]
split sub str = splitbyIndices str (normalizeArray (findString sub str) $ length sub) (length sub)

sanitizeMarkdown :: String -> String
sanitizeMarkdown txt = do
                        let newTxt = if(isInfixOf "\'---\'" txt) then T.unpack (T.replace (T.pack "\'---\'") (T.pack "<< +THREEDASHES+ >>") (T.pack txt)) else txt

                        if(newTxt !!! (length newTxt - 3, length newTxt) /= "---") then do
                            (newTxt ++ "---")
                        else
                            newTxt

removeExtensionMD :: String -> String
removeExtensionMD file = if(isInfixOf ".md" file) then file !!! (0, (length file) - 3) else file

getArgsIndex :: Int -> [String] -> Maybe String
getArgsIndex index args = if((length args) > index) then Just (args !! index) else Nothing