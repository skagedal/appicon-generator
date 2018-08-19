version=`git describe --abbrev=0`
binary="appicon-generator"
zipfile="$binary-$version.zip"

rm $binary $zipfile
swift build -c release --static-swift-stdlib
cp ./.build/x86_64-apple-macosx10.10/release/appicon-generator .
zip $zipfile $binary
rm $binary
