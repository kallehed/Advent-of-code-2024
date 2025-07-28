import Data.ByteString (breakSubstring)
import Data.ByteString.Char8 (ByteString, pack, split)
import qualified Data.ByteString.Char8 as Char8
import Debug.Trace
import Distribution.Simple.Utils (fromUTF8BS)

parse_order :: ByteString -> (Int, Int)
parse_order s =
  let (num1, num2) = breakSubstring (pack "|") s
   in (read $ fromUTF8BS num1, read $ Prelude.tail (fromUTF8BS num2))

parse_orders :: ByteString -> [(Int, Int)]
parse_orders = map parse_order . split '\n'

parse_updates :: ByteString -> [[Int]]
parse_updates = map (map (read . fromUTF8BS) . split ',') . split '\n'

parse_file :: ByteString -> ([(Int, Int)], [[Int]])
parse_file inp =
  let (orderings_str, updates_strf :: ByteString) = breakSubstring (pack "\n\n") inp
   in let updates_str :: ByteString = Char8.tail (Char8.tail updates_strf)
       in let orders = parse_orders orderings_str
           in let updates :: [[Int]] = parse_updates updates_str
               in (orders, updates)

-- check through all the orders to see if we are good
two_nums_in_correct_order :: Int -> Int -> [(Int, Int)] -> Bool
two_nums_in_correct_order x y =
  all (\(z, w) -> x /= w || y /= z)

get_pairs :: [Int] -> [(Int, Int)]
get_pairs [] = []
get_pairs [_] = []
get_pairs (first : rest) = map (first,) rest ++ get_pairs rest

update_correct :: [(Int, Int)] -> [Int] -> Bool
update_correct orders line =
  all (\(x, y) -> two_nums_in_correct_order x y orders) $ get_pairs line

-- instead of doing this,
-- I should probably try to find the numbers that are allowed to be first,
-- and pick the one that was earliest in the original list
-- then remove the one found from line, and
-- SO: find first element that is OK for all subsequent elements, remove it from list, also append it to resulting list

find_errors_and_correct_them :: [(Int, Int)] -> [Int] -> [Int]
find_errors_and_correct_them orders = h
  where
    h (head : rest) =
      if all (\x -> two_nums_in_correct_order head x orders) rest
        then head : h rest -- it's correct, meaning, head can be placed before all in the line
        else h (rest ++ [head]) -- it's incorrect, place head last in the list and try the next element
    h [] = []

-- Main function: read input from stdin and print the result
main :: IO ()
main = do
  input <- getContents
  let (orders :: [(Int, Int)], updates :: [[Int]]) = parse_file $ pack input
  let good_updates :: [[Int]] = filter (update_correct orders) updates
  let total :: Int = foldl (\acc item -> acc + item !! quot (length item) 2) 0 good_updates
  print "p1:"
  print total
  let bad_updates :: [[Int]] = filter (not . update_correct orders) updates
  -- fix them, if we find pair in wrong order, find first occurence of bad order, and
  -- move fst to after snd, check if it's correct now, if it is, add to list of correct, otherwise repeat
  -- until it's correct.
  print "p2"
  let total2 :: Int =
        foldl (\acc item -> acc + item !! quot (length item) 2) 0 (map (find_errors_and_correct_them orders) bad_updates)
  print total2

-- too high: 6567. Correct: 6191
