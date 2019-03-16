#!/bin/bash

# This script should be run to generate the Xcode project.

# Update Version.swift

./generate-version-swift.sh

# Generate xcodeproj

swift package generate-xcodeproj 

# Set header template.

sed s/CURRENTYEAR/`date +%Y`/g > appicon-generator.xcodeproj/xcshareddata/IDETemplateMacros.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>FILEHEADER</key>
	<string>
//  Copyright © CURRENTYEAR Simon Kågedal Reimer. See LICENSE.
//</string>
</dict>
</plist>
EOF

# Here would like to run add the SwiftLint build phase but despite creating this tool, it doesn't quite work the way I want 
# to.  If we just run it directly, we will for some reason get no schemes in the Xcode project.  We have to first open
# the Xcode project, then run this tool.  If anyone have suggestions for how to deal with all this in a better way, please
# contact me. 

# ACTUALLY:
# What we should do is save the scheme files before running the xcodeproj-modify tool, and then restore them afterwards.
# Until we find out something better.

echo Please open appicon-generator.xcodeproj in Xcode, then run ./add-build-phase.sh
# Add build phase

# xcodebuild

