//
//  File.swift
//
//
//  Created by Quentin Eude on 16/03/2021.
//

import Down
import SwiftUI

#if os(iOS)
  // MARK: - SwiftDownEditor iOS
  public struct SwiftDownEditor: UIViewRepresentable {
    @Binding var text: String

    private(set) var isEditable: Bool = true
    private(set) var theme: Theme = Theme.BuiltIn.defaultDark.theme()
    private(set) var insetsSize: CGFloat = 0
    private(set) var autocapitalizationType: UITextAutocapitalizationType = .sentences
    private(set) var autocorrectionType: UITextAutocorrectionType = .default
    private(set) var keyboardType: UIKeyboardType = .default
    private(set) var textAlignment: TextAlignment = .leading

    let onTextChange: (String) -> Void
    let engine = MarkdownEngine()

    public init(
      text: Binding<String>,
      onTextChange: @escaping (String) -> Void = { _ in }
    ) {
      _text = text
      self.onTextChange = onTextChange
    }

    public func makeUIView(context: Context) -> UITextView {
      let np = SwiftDown(frame: .zero, theme: theme)
      np.isEditable = true
      np.isScrollEnabled = true
      np.onTextChange = onTextChange
      np.keyboardType = keyboardType
      np.autocapitalizationType = autocapitalizationType
      np.autocorrectionType = autocorrectionType
      np.textContainerInset = UIEdgeInsets(
        top: insetsSize, left: insetsSize, bottom: insetsSize, right: insetsSize)
      np.backgroundColor = theme.backgroundColor
      np.tintColor = theme.tintColor
      np.storage.markdowner = { engine.render($0) }
      textView.storage.applyMarkdown = { m in Theme.applyMarkdown(markdown: m, with: self.theme) }
      textView.storage.applyBody = { Theme.applyBody(with: self.theme) }
      np.text = text

      return np
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {}
  }

  // MARK: - iOS Specifics modifiers
  extension SwiftDownEditor {
    public func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
      var new = self
      new.autocapitalizationType = type
      return new
    }

    public func autocorrectionType(_ type: UITextAutocorrectionType) -> Self {
      var new = self
      new.autocorrectionType = type
      return new
    }

    public func keyboardType(_ type: UIKeyboardType) -> Self {
      var new = self
      new.keyboardType = type
      return new
    }

    public func textAlignment(_ type: TextAlignment) -> Self {
      var new = self
      new.textAlignment = type
      return new
    }
  }
#else
  // MARK: - SwiftDownEditor macOS
  public struct SwiftDownEditor: NSViewRepresentable {
    @Binding var text: String

    private(set) var isEditable: Bool = true
    private(set) var theme: Theme = Theme.BuiltIn.defaultDark.theme()
    private(set) var insetsSize: CGFloat = 0

    let onTextChange: (String) -> Void

    public init(
      text: Binding<String>,
      onTextChange: @escaping (String) -> Void = { _ in }
    ) {
      _text = text
      self.onTextChange = onTextChange
    }

    public func makeNSView(context: Context) -> SwiftDown {
      let editor = SwiftDown(
        text: text, theme: theme, isEditable: isEditable, insetsSize: insetsSize)
      return editor
    }

    public func updateNSView(_ nsView: SwiftDown, context: Context) {}
  }
#endif

// MARK: - Common Modifiers
extension SwiftDownEditor {
  public func insetsSize(_ size: CGFloat) -> Self {
    var editor = self
    editor.insetsSize = size
    return editor
  }

  public func theme(_ theme: Theme) -> Self {
    var editor = self
    editor.theme = theme
    return editor
  }

  public func isEditable(_ isEditable: Bool) -> Self {
    var editor = self
    editor.isEditable = true
    return editor
  }
}
