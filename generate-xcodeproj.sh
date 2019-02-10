#!/bin/bash

# This script should be run to generate the Xcode project.  Unfortunately, some steps I haven't
# yet figured out a good way to automate, so there will be some instructions printed.

# Update Version.swift

./generate-version-swift.sh

# Generate xcodeproj

swift package generate-xcodeproj 

# Set header template.  We would like no header at all, but Xcode will not let us do that.

cat > appicon-generator.xcodeproj/xcshareddata/IDETemplateMacros.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>FILEHEADER</key>
	<string><# Remove me #></string>
</dict>
</plist>
EOF

# Show add build phase info

cat <<EOF
Done.

You need to do one more thing yourself.  Open Xcode project settings and add a new Build Phase for the
appicon-generator target.  It should be a Run Script phase and it should contain this line:

./xcode-build-phase.sh
EOF
