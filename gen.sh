#!/bin/bash
swiftgen strings -t dot-syntax-swift3 ./heibaiyu/zh-Hans.lproj/Localizable.strings > ./heibaiyu/genL10n.swift
swiftgen images -t swift3 ./heibaiyu/Assets.xcassets > ./heibaiyu/genImage.swift
swiftgen colors -t swift3 ./colors.clr > ./heibaiyu/genColors.swift
swiftgen storyboards -t swift3 ./heibaiyu > ./heibaiyu/genStoryboards.swift
