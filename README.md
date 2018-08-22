# appicon-generator

*A tool to quickly generate snazzy iOS placeholder appicons!*

If you're an iOS developer like me, chances are that you also create tiny iOS app projects in Xcode all the time. Maybe it's an idea you'd like to try out, a toy for experimenting with a new iOS feature, maybe it's a micro-tool, maybe it's the alpha version of the next App Store blockbuster. 

Suddenly your iOS simulators and your phone has a whole bunch of apps with the placeholder icon. That's not very nice. But – making an icon, just for this? You don't have time for that. You're not a designer.  You don't have Sketch. You just want something that looks ok for now. 

Here's a tool that quickly generates app icons from a big set of beautifully crafted icons that are already on your computer.  Open a shell, `cd` to your project directory and type:

```shell
$ appicon-generator 🐘
```

Now you have an elephant as an appicon. _Nice._

## Installation

Grab the zip from the releases page on Github, unzip and move `appicon-generator` into `/usr/local/bin` (or some other place you like to keep your binaries). 

## Caveats

* `appicon-generator` will look for an `Assets.xcassets` directory, in the directory you're at or most one level down, and then generate an `AppIcon.appiconset` there, **overwriting any existing data without asking**. Commit your data if needed before using.
* Obviously, don't try to commit an app with an emoji as an icon to the App Store. They won't like that. 

## Build instructions

To build the tool, use `swift build`.  Make sure to have your `xcode-select` version to Xcode 10 – as of this writing, I am using the beta 6 version. 

## Framework

This repository also contains the app icon set generator code as a Swift Package Manager distributed framework, if you'd like to integrate it with other tools. Please see:

* [AppIconKit](http://skagedal.github.io/appicon-generator/)
