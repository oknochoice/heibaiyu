#!/bin/bash

outpath=/Users/wangJW/Desktop/git/protobuf

arm64path=${outpath}"/arm64"
mkdir ${arm64path}
./configure --prefix=${arm64path} --enable-static --disable-shared \
	--enable-utf8 \
	--host=arm-apple-darwin \
	CFLAGS="-arch arm64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0 -fembed-bitcode" \
	CXXFLAGS="-arch arm64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0 -fembed-bitcode" \
	LDFLAGS="-L." \
	CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
	CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"

make clean
make
make install

armv7path=${outpath}"/armv7"
mkdir ${armv7path}
./configure --prefix=${armv7path} --enable-static --disable-shared \
	--enable-utf8 \
	--host=arm-apple-darwin \
	CFLAGS="-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0 -fembed-bitcode" \
	CXXFLAGS="-arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0 -fembed-bitcode" \
	LDFLAGS="-L." \
	CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
	CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"

make clean
make
make install

armv7spath=${outpath}"/armv7s"
mkdir ${armv7spath}
./configure --prefix=${armv7spath} --enable-static --disable-shared \
	--enable-utf8 \
	--host=arm-apple-darwin \
	CFLAGS="-arch armv7s -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0 -fembed-bitcode" \
	CXXFLAGS="-arch armv7s -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0 -fembed-bitcode" \
	LDFLAGS="-L." \
	CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
	CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"

make clean
make
make install

x86_64path=${outpath}"/x86_64"
mkdir ${x86_64path}
./configure --prefix=${x86_64path} --enable-static --disable-shared \
	--enable-utf8 \
	--host=arm-apple-darwin \
	CFLAGS="-arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk" \
	CXXFLAGS="-arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk" \
	LDFLAGS="-L." \
	CC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" \
	CXX="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"

make clean
make
make install

universalpath=${outpath}"universal"
mkdir ${universalpath}
#lipo -create 

