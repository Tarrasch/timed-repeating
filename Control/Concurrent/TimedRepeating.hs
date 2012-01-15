-- | In the documentation I often say every hour, but of course that
--   time is configureable.
module Control.Concurrent.TimedRepeating (
      timedRepeating
    , defaultTrSettings
    , trSettingsPeriodicity
    , TrSettings()
    ) where

import Data.IORef (IORef, newIORef, writeIORef)
import Control.Monad (forever)
import Control.Concurrent (forkIO, threadDelay)

data TrSettings = TrSettings
    { -- | How often to repeat the action in microseconds.
      --   Set to 60*1000000 to run it every minute.
      --   Note that as of the limitations of `Int` you
      --   can't have a period time of one hour.
    trSettingsPeriodicity :: Int
    }

-- | For usage of this value, please read about
--   <http://www.yesodweb.com/blog/2011/10/settings-types>
defaultTrSettings :: TrSettings
defaultTrSettings = TrSettings (60*1000000)

-- | Repeteadly run an action every hour, the action
--   will run once immedietly to fill in the IORef,
--   however, as the action might crash and not provide any
--   start value, a start value must be provided, even though
--   it hopefully will be overwritten instantly.
timedRepeating :: TrSettings
               -> IO a -- ^ Routine to run every hour to fill in ref
               -> a -- ^ Start value, likely to be overwritten quickly
               -> IO (IORef a) -- ^ Ref one can read from
timedRepeating settings io a = do
    ref <- newIORef a
    _ <- forkIO $ forever $ do _ <- forkIO (writeIORef ref =<< io)
                               threadDelay $ trSettingsPeriodicity settings
    return ref
