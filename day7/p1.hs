import Data.ByteString.Char8 (ByteString, getContents, readInt, split)
import Data.Maybe (Maybe (..), mapMaybe)
import Prelude (Bool (..), Int, filter, fmap, fst, print, putStrLn, show, sum, ($), (*), (+), (.), (<$>), (==), (||), read, (++), quot, (<), (-))

parseInt :: ByteString -> Maybe Int
parseInt x = fmap fst (readInt x)

unwrap (Just x) = x

parseLine :: ByteString -> (Int, [Int])
parseLine line =
  let many = split ':' line
   in case many of
        [x, y] -> (unwrap $ parseInt x, mapMaybe parseInt (split ' ' y))

goodLine :: (Int, [Int]) -> Bool
goodLine (needed, list) = h 0 list
  where
    h acc (x : rest) = h (acc + x) rest || h (acc * x) rest
    h acc [] = acc == needed

-- find the 'length' of y, then do (x * 10^(len(y)) + y)
intConcat :: Int -> Int -> Int
intConcat x y = (x * (10 `raise` intLen(y)) + y) 
  where 
    intLen z = if z < 10 then 1 else 1 + intLen (z `quot` 10)
    raise z 0 = 1
    raise z w = z * (raise z (w-1))

goodLine2 :: (Int, [Int]) -> Bool
goodLine2 (needed, list) = h 0 list
  where
    h acc (x : rest) = h (acc + x) rest || h (acc * x) rest || h (intConcat acc x) rest
    h acc [] = acc == needed

getSum l parsed = sum $ fst <$> filter l parsed

main = do
  (content :: ByteString) <- getContents
  let (parsed :: [(Int, [Int])]) = fmap parseLine (split '\n' content)
  print "p1"
  print (getSum goodLine parsed)
  print "p2"
  print (getSum goodLine2 parsed)
