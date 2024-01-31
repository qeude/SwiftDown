//
//  MarkdownKeyboardToolbar.swift
//
//
//  Created by Ross Brandon on 18/01/24.
//

#if os(iOS)
import UIKit

extension SwiftDown {
  /// Adds a keyboard toolbar for quick markdown syntax
  /// Adds the selected markdown at the cursor's position
  func addKeyboardToolbar() {
    let toolbar = UIToolbar()
    let h1Button = keyboardButton(title: "H1", action: #selector(self.h1Action))
    let h2Button = keyboardButton(title: "H2", action: #selector(self.h2Action))
    let h3Button = keyboardButton(title: "H3", action: #selector(self.h3Action))
    let boldButton = keyboardButton(icon: "bold", action: #selector(self.boldAction))
    let italicizeButton = keyboardButton(icon: "italic", action: #selector(self.italicizeAction))
    let unorderedListButton = keyboardButton(icon: "list.bullet",action: #selector(self.unorderedListAction))
    let orderedListButton = keyboardButton(icon: "list.number",action: #selector(self.orderedListAction))
    let blockQuoteButton = keyboardButton(icon: "quote.closing",action: #selector(self.blockQuoteAction))
    let linkButton = keyboardButton(icon: "link", action: #selector(self.linkAction))
    let codeBlockButton = keyboardButton(icon: "curlybraces", action: #selector(self.codeBlockAction))
    toolbar.setItems(
      [
        h1Button,
        h2Button,
        h3Button,
        boldButton,
        italicizeButton,
        unorderedListButton,
        orderedListButton,
        blockQuoteButton,
        linkButton,
        codeBlockButton
      ],
      animated: false
    )
    toolbar.isUserInteractionEnabled = true
    toolbar.sizeToFit()
    toolbar.barStyle = UIBarStyle.default
    toolbar.isTranslucent = true
    toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    toolbar.backgroundColor = UIColor.secondarySystemBackground
    let toolbarWidth = max(40 * CGFloat(toolbar.items?.count ?? 0), UIScreen.main.bounds.width)
    toolbar.frame = CGRect(x: 0, y: 0, width: toolbarWidth, height: toolbar.frame.size.height)
    let scrollView = UIScrollView(frame:
      CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbar.frame.size.height)
    )
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.bounds = toolbar.bounds
    scrollView.contentSize = toolbar.frame.size
    scrollView.backgroundColor = UIColor.secondarySystemBackground
    scrollView.addSubview(toolbar)
    self.inputAccessoryView = scrollView
  }

  private func keyboardButton(title: String, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(
      title: title,
      style: .plain,
      target: self,
      action: action
    )
  }

  private func keyboardButton(icon: String, action: Selector) -> UIBarButtonItem {
    UIBarButtonItem(
      image: UIImage(systemName: icon),
      style: .plain,
      target: self,
      action: action
    )
  }

  /// Moves the cursor position after the inserted characters
  @objc private func h1Action() {
    let selectedStart = self.selectedStart
    self.text.insert(contentsOf: "# ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.moveCursor(selectedStart + 2)
    self.highlighter?.applyStyles()
  }

  /// Moves the cursor position after the inserted characters
  @objc private func h2Action() {
    let selectedStart = self.selectedStart
    self.text.insert(contentsOf: "## ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.moveCursor(selectedStart + 3)
    self.highlighter?.applyStyles()
  }

  /// Moves the cursor position after the inserted characters
  @objc private func h3Action() {
    let selectedStart = self.selectedStart
    self.text.insert(contentsOf: "### ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.moveCursor(selectedStart + 4)
    self.highlighter?.applyStyles()
  }

  /// If text is selected, surrounds the selected text with the bold tags
  /// Moves the cursor to the end of the selected text, if applicable
  @objc private func boldAction() {
    let selectedStart = self.selectedStart
    let selectedEnd = self.selectedEnd
    self.text.insert(contentsOf: "**", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.text.insert(contentsOf: "**", at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 2))
    self.moveCursor(selectedEnd + 2)
    self.highlighter?.applyStyles()
  }

  /// If text is selected, surrounds the selected text with the italic tags
  /// Moves the cursor to the end of the selected text, if applicable
  @objc private func italicizeAction() {
    let selectedStart = self.selectedStart
    let selectedEnd = self.selectedEnd
    self.text.insert(contentsOf: "*", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.text.insert(contentsOf: "*", at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 1))
    self.moveCursor(selectedEnd + 1)
    self.highlighter?.applyStyles()
  }

  /// Adds 1 leading line break
  @objc private func unorderedListAction() {
    let selectedStart = self.selectedStart
    self.text.insert(contentsOf: "\n- ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.moveCursor(selectedStart + 3)
    self.highlighter?.applyStyles()
  }

  /// Adds 1 leading line break
  @objc private func orderedListAction() {
    let selectedStart = self.selectedStart
    self.text.insert(contentsOf: "\n1. ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.moveCursor(selectedStart + 3)
    self.highlighter?.applyStyles()
  }

  @objc private func blockQuoteAction() {
    let selectedStart = self.selectedStart
    self.text.insert(contentsOf: "> ", at: self.text.index(self.text.startIndex, offsetBy: selectedStart))
    self.highlighter?.applyStyles()
  }

  /// If text is selected, it is checked if it contains a link
  ///   If a link is detected, the selected text is placed inside the braces
  ///   If a link is not detected, the selected text is placed inside the parenthesis
  /// Moves the cursor into the text bracket or parenthesis as applicable
  @objc private func linkAction() {
    let selectedStart = self.selectedStart
    let selectedEnd = self.selectedEnd
    if self.containsLink {
      self.text.insert(
        contentsOf: "[](",
        at: self.text.index(self.text.startIndex, offsetBy: selectedStart)
    )
      self.text.insert(
        contentsOf: ")",
        at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 3)
    )
      self.moveCursor(selectedStart + 1)
    } else {
      self.text.insert(
        contentsOf: "[",
        at: self.text.index(self.text.startIndex, offsetBy: selectedStart)
      )
      self.text.insert(
        contentsOf: "]()",
        at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 1)
      )
      self.moveCursor(selectedEnd + 3)
    }
    self.highlighter?.applyStyles()
  }

  /// If text is selected, moves the selected text inside the code block
  /// Moves the cursor into the code block at the end of the selected text, if applicable
  @objc private func codeBlockAction() {
    let selectedStart = self.selectedStart
    let selectedEnd = self.selectedEnd
    self.text.insert(
      contentsOf: "```\n",
      at: self.text.index(self.text.startIndex,
      offsetBy: selectedStart)
    )
    self.text.insert(
      contentsOf: "\n```",
      at: self.text.index(self.text.startIndex, offsetBy: selectedEnd + 4)
    )
    self.moveCursor(selectedEnd + 4)
    self.highlighter?.applyStyles()
  }
}

/// Extends UITextView to provide cursor helper methods
extension UITextView {
  /// Get selected text range start position
  var selectedStart: Int {
    guard let selectedRange = self.selectedTextRange else {
      return 0
    }
    return self.offset(from: self.beginningOfDocument, to: selectedRange.start)
  }

  /// Get selected text range end position
  var selectedEnd: Int {
    guard let selectedRange = self.selectedTextRange else {
      return 0
    }
    return self.offset(from: self.beginningOfDocument, to: selectedRange.end)
  }

  /// Move cursor by the given offset
  func moveCursor(_ offset: Int = 1) {
    guard let newPosition = self.position(from: self.beginningOfDocument, offset: offset) else {
      return
    }
    self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
  }

  /// Validate if the selected text range contains a link
  var containsLink: Bool {
    guard let selectedTextRange = self.selectedTextRange,
      let selectedText = self.text(in: selectedTextRange) else {
      return false
    }
    do {
      let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
      let matches = detector.matches(
        in: selectedText, options: [],
        range: NSRange(location: 0, length: selectedText.utf16.count)
      )
      return !matches.isEmpty
    } catch {
      return false
    }
  }
}
#endif
