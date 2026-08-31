# appicon-generator

**This repository has moved.** `appicon-generator` now lives in the
[skagedal-tools](https://github.com/skagedal/skagedal-tools) monorepo, under
[`appicon-generator/`](https://github.com/skagedal/skagedal-tools/tree/main/appicon-generator).
Its history came along, with the paths rewritten, so `git log` there goes back
to the first commit here.

The version in skagedal-tools is a substantial rewrite: Swift 6.2 instead of
Swift 4, the single-size app icon set Xcode 14 and later produce (with the iOS
18 dark and tinted variants), and modes for Flutter apps and bare PNGs
alongside native Xcode projects.

## Installing

The Mint and release-zip instructions that used to be here no longer apply —
there are no tagged releases any more. Clone skagedal-tools and run:

```shell
$ ./install appicon-generator
```

which builds it and puts the binary in `~/.local/bin`.

This repository is kept only so existing links resolve. Nothing further will
be developed here.
