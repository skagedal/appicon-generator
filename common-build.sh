# Common variables for build scripts.

export version=`git describe`
export binary="appicon-generator"
export zipfile="$binary-$version.zip"
export built_release_binary="./.build/x86_64-apple-macosx10.10/release/$binary"

function build_release {
    ./generate-version-swift.sh
    swift build -c release --static-swift-stdlib
}
