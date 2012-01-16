A small haskell library for running an action continiously
(background jobs)
without needing to bother about implementing concurrency and
handling crashes.

## Basics

The basic interface is `IO a -> IO (IORef a)`.
You give an action to be run every minute (of course configurable),
and the result of the latest non-crashed value will be placed in the
IORef. This is typically useful when for example scraping a
remote web site, it's likely for your action to crash or to get
stuck fetching the remote web page, and you don't want it to stop
scraping if it crashes. Nor do you want
it to spawn 1000 threads that just are idle,
this library hinders such things and lets you only worry about
the action (`IO a`) you provide.

## Features

 * The provided action will always run in a seperate thread,
   enforcing the hierarchy that the thread spawner won't crash
   even if the child thread does. For example, if you're scraping
   a remote web page hourly and a scraping attempt fails,
   then no master thread will terminate and the scraper will
   be launched in the next hour.

   Small note, the threads' lifetime isn't controllable in the
   current unfinished implementation.

## Installing

Get it simply by `cabal install timed-repeating`
(as soon as I get this up on hackage).

For documentation, generate the haddocks with `cabal haddock`.
