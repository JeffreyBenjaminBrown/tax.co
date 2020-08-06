-- | This is Haskell code that generates Python code.
-- For an example of how it is used, see the function
-- `non_dividend_income_tax` in `python/regime/r2018.py`.

{-# LANGUAGE NumericUnderscores #-}


-- * Types

-- | A way to represent marginal tax rates.
data MoneyBracket = MoneyBracket
  { top :: Float
  , rate :: Float } deriving (Show)

-- | A formula from money (usually income, sometimes wealth)
-- to total (not marginal) tax owed.
data Formula = Formula
  { fSubtract :: Float
  , fRate :: Float
  , fAdd :: Float
  , fMax :: Float }

instance Show Formula where
  show f = "(x - " ++ show (fSubtract f) ++ " * muvt)*" ++
           show (fRate f) ++ " + " ++ show (fAdd f)
           ++ "*muvt if x < (" ++ show (fMax f) ++ "*muvt)"


-- * Functions

go :: Formula -> [MoneyBracket] -> IO ()
go initialFormula brackets =
  mapM_ (putStrLn . show) $
  scanl unMarginalize initialFormula brackets

unMarginalize :: Formula -> MoneyBracket -> Formula
unMarginalize prev bracket =
  Formula { fSubtract = fMax prev
          , fRate = rate bracket
          , fAdd = fAdd prev +
                   fRate prev * (fMax prev - fSubtract prev)
          , fMax = top bracket }

-- ** Data

-- * Dividend tax rates

-- *Main> go dividendFormula1 dividendBrackets
-- 0                                if x < (300*muvt)
-- (x - 300  * muvt)*0.1            if x < (600*muvt)
-- (x - 600  * muvt)*0.12 + 30*muvt if x < (1000*muvt)
-- (x - 1000 * muvt)*0.18 + 78*muvt if x < (1500*muvt)
-- (x - 1500 * muvt)*0.2  + 168*muvt otherwise

-- | If your dividend income is less than 300 UVT,
-- you pay nothing in taxes on it.
dividendFormula1 :: Formula
dividendFormula1 = Formula 0 0 0 300

-- | Don't include the first bracket,
-- as it's already been converted into a Formula (`dividendFormula1`).
dividendBrackets :: [MoneyBracket]
dividendBrackets =
  [ MoneyBracket 600  0.1
  , MoneyBracket 1000 0.12
  , MoneyBracket 1500 0.18
  , MoneyBracket 9e20 0.2 ]


-- * Income tax rates

-- Main> go incomeFormula1 incomeBrackets
-- 0                                    if x < (1090*muvt)
-- (x - 1090  * muvt)*0.19              if x < (1700*muvt)
-- (x - 1700  * muvt)*0.28 + 116  *muvt if x < (4100*muvt)
-- (x - 4100  * muvt)*0.33 + 788  *muvt if x < (8670*muvt)
-- (x - 8670  * muvt)*0.35 + 2296 *muvt if x < (18970*muvt)
-- (x - 18970 * muvt)*0.39 + 5901 *muvt if x < (27595*muvt)
-- (x - 27595 * muvt)*0.44 + 9265 *muvt if x < (36000*muvt)
-- (x - 36000 * muvt)*0.47 + 12963*muvt if x < (55000*muvt)
-- (x - 55000 * muvt)*0.5  + 21893*muvt if x < (90000*muvt)
-- (x - 90000 * muvt)*0.55 + 39393*muvt otherwise

-- | If your income is less than 300 UVT, you pay nothing in taxes on it.
incomeFormula1 :: Formula
incomeFormula1 = Formula 0 0 0 1090

-- | Don't include the first bracket,
-- as it's already been converted into a Formula (`incomeFormula1`).
incomeBrackets :: [MoneyBracket]
incomeBrackets =
  [ MoneyBracket  1_700 0.19
  , MoneyBracket  4_100 0.28
  , MoneyBracket  8_670 0.33
  , MoneyBracket 18_970 0.35
  , MoneyBracket 27_595 0.39
  , MoneyBracket 36e3   0.44
  , MoneyBracket 55e3   0.47
  , MoneyBracket 90e3   0.5
  , MoneyBracket 9e20   0.55 ]


-- * Inheritance tax rates

-- What I calculate from the proposal's thresholds and marginal rates:
-- Main> go inheritanceFormula1 inheritanceBrackets
-- 0                                           if x < ( 112337*muvt)
-- (x -  112337 * muvt)*0.1                    if x < ( 280884*muvt)
-- (x -  280884 * muvt)*0.2  +  16854.701*muvt if x < (2808436*muvt)
-- (x - 2808436 * muvt)*0.33 + 522365.1*muvt   if x <    (9e20*muvt)

-- Formulas contained in the proposal are wildly different:
-- 0                                       if x < ( 112337*muvt)
-- x*0.1                                   if x < ( 280884*muvt)
-- (x -  280884 * muvt)*0.2  +  28084*muvt if x < (2808436*muvt)
-- (x - 2808436 * muvt)*0.25 + 533594*muvt if x <    (9e20*muvt)


-- | If your inheritance is less than 300 UVT, you pay nothing in taxes on it.
inheritanceFormula1 :: Formula
inheritanceFormula1 = Formula 0 0 0 112_337

-- | Don't include the first bracket,
-- as it's already been converted into a Formula (`inheritanceFormula1`).
inheritanceBrackets :: [MoneyBracket]
inheritanceBrackets =
  [ MoneyBracket    280_884 0.1
  , MoneyBracket  2_808_436 0.2
  , MoneyBracket  9e20      0.33 ]
