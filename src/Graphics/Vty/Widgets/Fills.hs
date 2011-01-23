module Graphics.Vty.Widgets.Fills
    ( VFill
    , HFill
    , hFill
    , vFill
    )
where

import Control.Monad.Trans
    ( MonadIO
    )
import Graphics.Vty
    ( Attr
    , region_width
    , region_height
    , char_fill
    )
import Graphics.Vty.Widgets.Core
    ( Widget
    , WidgetImpl(..)
    , newWidget
    , updateWidget
    , getState
    )

data VFill = VFill Attr Char
             deriving (Show)

-- |A vertical fill widget.  Fills all available space with the
-- specified character and attribute.
vFill :: (MonadIO m) => Attr -> Char -> m (Widget VFill)
vFill att c = do
  wRef <- newWidget
  updateWidget wRef $ \w ->
      w { state = VFill att c
        , getGrowHorizontal = const $ return False
        , getGrowVertical = const $ return True
        , draw = \this s _ _ mAttr -> do
                   VFill attr ch <- getState this
                   let attr' = maybe attr id mAttr
                   return $ char_fill attr' ch (region_width s) (region_height s)
        }
  return wRef

data HFill = HFill Attr Char Int
             deriving (Show)

-- |A horizontal fill widget.  Fills the available horizontal space,
-- one row high, using the specified character and attribute.
hFill :: (MonadIO m) => Attr -> Char -> Int -> m (Widget HFill)
hFill att c h = do
  wRef <- newWidget
  updateWidget wRef $ \w ->
      w { state = HFill att c h
        , getGrowHorizontal = const $ return True
        , getGrowVertical = const $ return False
        , draw = \this s _ _ mAttr -> do
                   HFill attr ch height <- getState this
                   let attr' = maybe attr id mAttr
                   return $ char_fill attr' ch (region_width s) (toEnum height)
        }
  return wRef
