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

# Add build phase

swift run xcodeproj-modify ./appicon-generator.xcodeproj add-run-script-phase appicon-generator ./xcode-build-phase.sh

