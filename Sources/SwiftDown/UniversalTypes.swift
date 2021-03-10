//
//  UniversalTypes.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

#if os(iOS)
  import UIKit
  typealias UniversalColor = UIColor
  typealias UniversalFont = UIFont
  typealias UniversalFontDescriptor = UIFontDescriptor
  typealias UniversalTraits = UIFontDescriptor.SymbolicTraits
#elseif os(macOS)
  import AppKit
  typealias UniversalColor = NSColor
  typealias UniversalFont = NSFont
  typealias UniversalFontDescriptor = NSFontDescriptor
  typealias UniversalTraits = NSFontDescriptor.SymbolicTraits
#endif
