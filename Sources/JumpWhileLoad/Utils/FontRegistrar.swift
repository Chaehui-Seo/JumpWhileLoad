//
//  FontRegistrar.swift
//  JumpWhileLoad
//
//  Created by 서채희 on 4/3/25.
//

import UIKit
import CoreText

public enum FontRegistrar {
    public static func registerFonts() {
        registerFont(bundle: Bundle.module, fontName: "SourceCodePro-Bold", fontExtension: "ttf")
    }

    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("⚠️ Could not find font \(fontName)")
            return
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("⚠️ Could not create font from data provider")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("⚠️ Error registering font: \(error.debugDescription)")
        }
    }
}
