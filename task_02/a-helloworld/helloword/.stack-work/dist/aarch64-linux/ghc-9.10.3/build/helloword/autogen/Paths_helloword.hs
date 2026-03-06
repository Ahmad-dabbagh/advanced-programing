{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_helloword (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/ad/progtasks/task_02/a-helloworld/helloword/.stack-work/install/aarch64-linux/5d79b29f0d1f5eaa5ef86de56d7f908cc33051b5aa1c4fb69496dec7b0f382c9/9.10.3/bin"
libdir     = "/home/ad/progtasks/task_02/a-helloworld/helloword/.stack-work/install/aarch64-linux/5d79b29f0d1f5eaa5ef86de56d7f908cc33051b5aa1c4fb69496dec7b0f382c9/9.10.3/lib/aarch64-linux-ghc-9.10.3-d564/helloword-0.1.0.0-Gnobh2TCMkeHvhy3oiCCsj-helloword"
dynlibdir  = "/home/ad/progtasks/task_02/a-helloworld/helloword/.stack-work/install/aarch64-linux/5d79b29f0d1f5eaa5ef86de56d7f908cc33051b5aa1c4fb69496dec7b0f382c9/9.10.3/lib/aarch64-linux-ghc-9.10.3-d564"
datadir    = "/home/ad/progtasks/task_02/a-helloworld/helloword/.stack-work/install/aarch64-linux/5d79b29f0d1f5eaa5ef86de56d7f908cc33051b5aa1c4fb69496dec7b0f382c9/9.10.3/share/aarch64-linux-ghc-9.10.3-d564/helloword-0.1.0.0"
libexecdir = "/home/ad/progtasks/task_02/a-helloworld/helloword/.stack-work/install/aarch64-linux/5d79b29f0d1f5eaa5ef86de56d7f908cc33051b5aa1c4fb69496dec7b0f382c9/9.10.3/libexec/aarch64-linux-ghc-9.10.3-d564/helloword-0.1.0.0"
sysconfdir = "/home/ad/progtasks/task_02/a-helloworld/helloword/.stack-work/install/aarch64-linux/5d79b29f0d1f5eaa5ef86de56d7f908cc33051b5aa1c4fb69496dec7b0f382c9/9.10.3/etc"

getBinDir     = catchIO (getEnv "helloword_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "helloword_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "helloword_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "helloword_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "helloword_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "helloword_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
