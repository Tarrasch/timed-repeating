A small haskell library for running an action continiously
without needing to bother about implementing concurrency and
handling crashes.

The basic interface is `IO a -> IO (IORef a)`.
You give an action to be run every minute (of course configurable),
and the result of the latest non-crashed value will be placed in the
IORef. This is typically useful when for example scraping a
remote web site, it's likely for your action to crash or to get
stuck fetching the remote web page, so you don't want it to stop
scraping forever if it ever crashes. Nor do you want
it to have been spawned 1000 processes that just are idle,
this library hinders such things and lets you only worry about
the action (`IO a`) you provide.

Small note, so far processes can get stuck idle in the
current unfinished implementation.

Get it simply by `cabal install timed-repeating`
(as soon as I get this up on hackage).

For documentation, generate the haddocks with `cabal haddock`.
