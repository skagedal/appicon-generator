#!/bin/bash

# This should be executed as a build phase in Xcode

swift run swiftlint autocorrect --path Sources
swift run swiftlint --path Sources
