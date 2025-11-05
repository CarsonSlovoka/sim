import Carbon
import Foundation

let VERSION = "1.0.0"

let rawArgs = CommandLine.arguments

if rawArgs.contains("-v") || rawArgs.contains("--version") {
    print("sim version \(VERSION)")
    exit(0)
}

let arg = CommandLine.arguments.dropFirst().first ?? ""

// argument 為空，就列出所有可用輸入法；否則嘗試切換到指定的輸入法
if arg.isEmpty {
    // 列出所有可用源
    // 類似命令: `defaults read com.apple.HIToolbox AppleEnabledInputSources | grep Bundle`
    // com.apple.keylayout.ABC
    // com.apple.inputmethod.TCIM.Zhuyin
    // com.apple.inputmethod.TCIM
    // com.apple.CharacterPaletteIM
    // com.apple.PressAndHold
    // com.boshiamy.inputmethod.BoshiamyIMK
    guard
        let allSources = TISCreateInputSourceList(nil, false).takeRetainedValue()
            as? [TISInputSource]
    else {
        fatalError("Unable to obtain input source list")
    }

    for source in allSources {
        // 取得 ID（kTISPropertyInputSourceID）
        if let cfID = TISGetInputSourceProperty(source, kTISPropertyInputSourceID as CFString) {
            let sourceID = Unmanaged<CFString>.fromOpaque(cfID).takeUnretainedValue() as String
            print(sourceID)
        }
    }
} else {
    // 先嘗試找到符合 ID 的輸入源
    let query: [CFString: Any] = [kTISPropertyInputSourceID as CFString: arg]
    guard
        let sources = TISCreateInputSourceList(query as CFDictionary, false).takeRetainedValue()
            as? [TISInputSource],
        let source = sources.first
    else {
        print("The input method with ID '\(arg)' cannot be found")
        exit(1)
    }

    // Switch input method
    TISSelectInputSource(source)
}
