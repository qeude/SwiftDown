//
//  SwiftDownHighlighter.swift
//
//
//  Created by Quentin Eude on 28/12/2022.
//

#if os(iOS)
import UIKit

class SwiftDownHighlighter {
  weak var textView: UITextView?

  /// - param textView: The text view which should be observed and highlighted.
  init(textView: UITextView?) {
    self.textView = textView
    applyStyles()
  }

  public func applyStyles() {
    guard let customTextStorage = self.textView?.textStorage as? Storage
    else { return }

    customTextStorage.beginEditing()
    customTextStorage.applyStyles()
    customTextStorage.endEditing()
  }
}

#else
import AppKit

class SwiftDownHighlighter {
  let textView: NSTextView

  /// - param textView: The text view which should be observed and highlighted.
  init(textView: NSTextView) {
    self.textView = textView
    applyStyles()
  }

  public func applyStyles() {
    guard let customTextStorage = self.textView.textStorage as? Storage
    else { return }

    customTextStorage.beginEditing()
    customTextStorage.applyStyles()
    customTextStorage.endEditing()
  }
}

#endif
