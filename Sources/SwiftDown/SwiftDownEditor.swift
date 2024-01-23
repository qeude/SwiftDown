//
//  SwiftDownEditor.swift
//
//
//  Created by Quentin Eude on 16/03/2021.
//

import Down
import SwiftUI
import Combine

#if os(iOS)
  // MARK: - SwiftDownEditor iOS
public struct SwiftDownEditor: UIViewRepresentable {
  private var debounceTime = 0.3
  @Binding var text: String {
    didSet {
      onTextChange(text)
    }
  }

    private(set) var isEditable: Bool = true
    private(set) var theme: Theme = Theme.BuiltIn.defaultDark.theme()
    private(set) var insetsSize: CGFloat = 0
    private(set) var autocapitalizationType: UITextAutocapitalizationType = .sentences
    private(set) var autocorrectionType: UITextAutocorrectionType = .default
    private(set) var keyboardType: UIKeyboardType = .default
    private(set) var hasKeyboardToolbar: Bool = true
    private(set) var textAlignment: TextAlignment = .leading

    public var onTextChange: (String) -> Void = { _ in }
    public var onSelectionChange: (NSRange) -> Void = { _ in }
    let engine = MarkdownEngine()

    public init(
      text: Binding<String>,
      onTextChange: @escaping (String) -> Void = { _ in },
      onSelectionChange: @escaping (NSRange) -> Void = { _ in }
    ) {
      _text = text
      self.onTextChange = onTextChange
      self.onSelectionChange = onSelectionChange
    }

    public func makeUIView(context: Context) -> SwiftDown {
      let swiftDown = SwiftDown(frame: .zero, theme: theme)
      swiftDown.storage.markdowner = { self.engine.render($0, offset: $1) }
      swiftDown.storage.applyMarkdown = { m in Theme.applyMarkdown(markdown: m, with: self.theme) }
      swiftDown.storage.applyBody = { Theme.applyBody(with: self.theme) }
      swiftDown.delegate = context.coordinator
      swiftDown.isEditable = isEditable
      swiftDown.isScrollEnabled = true
      swiftDown.keyboardType = keyboardType
      swiftDown.hasKeyboardToolbar = hasKeyboardToolbar
      swiftDown.autocapitalizationType = autocapitalizationType
      swiftDown.autocorrectionType = autocorrectionType
      swiftDown.textContainerInset = UIEdgeInsets(
        top: insetsSize, left: insetsSize, bottom: insetsSize, right: insetsSize)
      swiftDown.backgroundColor = theme.backgroundColor
      swiftDown.tintColor = theme.tintColor
      swiftDown.textColor = theme.tintColor
      swiftDown.text = text

      return swiftDown
    }

  public func updateUIView(_ uiView: SwiftDown, context: Context) {
    context.coordinator.cancellable?.cancel()
    context.coordinator.cancellable = Timer
      .publish(every: debounceTime, on: .current, in: .default)
      .autoconnect()
      .first()
      .sink { _ in
        let selectedRange = uiView.selectedRange
        uiView.text = text
        uiView.highlighter?.applyStyles()
        uiView.selectedRange = selectedRange
      }
  }

    public func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }
  }

  // MARK: - SwiftDownEditor iOS Coordinator
  extension SwiftDownEditor {
    public class Coordinator: NSObject, UITextViewDelegate {
      var cancellable: Cancellable?
      var parent: SwiftDownEditor

      init(_ parent: SwiftDownEditor) {
        self.parent = parent
      }

      public func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }

        DispatchQueue.main.async {
          self.parent.text = textView.text
        }
      }

      public func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        self.parent.onSelectionChange(textView.selectedRange)
      }
    }
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

    public func hasKeyboardToolbar(_ hasKeyboardToolbar: Bool) -> Self {
      var editor = self
      editor.hasKeyboardToolbar = hasKeyboardToolbar
      return editor
    }
  }
#else
  // MARK: - SwiftDownEditor macOS
  public struct SwiftDownEditor: NSViewRepresentable {
    private var debounceTime = 0.3
    @Binding var text: String {
      didSet {
        onTextChange(text)
      }
    }

    private(set) var isEditable: Bool = true
    private(set) var theme: Theme = Theme.BuiltIn.defaultDark.theme()
    private(set) var insetsSize: CGFloat = 0

    public var onTextChange: (String) -> Void = { _ in }
    public var onSelectionChange: (NSRange) -> Void = { _ in }

    public init(
      text: Binding<String>,
      onTextChange: @escaping (String) -> Void = { _ in },
      onSelectionChange: @escaping (NSRange) -> Void = { _ in }
    ) {
      _text = text
      self.onTextChange = onTextChange
      self.onSelectionChange = onSelectionChange
    }

    public func makeNSView(context: Context) -> SwiftDown {
      let swiftDown = SwiftDown(theme: theme, isEditable: isEditable, insetsSize: insetsSize)
      swiftDown.delegate = context.coordinator
      swiftDown.setupTextView()
      swiftDown.text = text
      return swiftDown
    }

    public func updateNSView(_ nsView: SwiftDown, context: Context) {
      context.coordinator.cancellable?.cancel()
      context.coordinator.cancellable = Timer
        .publish(every: debounceTime, on: .current, in: .default)
        .autoconnect()
        .first()
        .sink { _ in
          let selectedRanges = nsView.selectedRanges
          nsView.text = text
          nsView.applyStyles()
          nsView.selectedRanges = selectedRanges
        }
    }

    public func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }
  }

  // MARK: - SwiftDownEditor Coordinator macOS
  extension SwiftDownEditor {
    // MARK: - Coordinator
    public class Coordinator: NSObject, NSTextViewDelegate {
      var parent: SwiftDownEditor
      var cancellable: Cancellable?
      init(_ parent: SwiftDownEditor) {
        self.parent = parent
      }

      public func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
          return
        }

        self.parent.text = textView.string
      }

      public func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
          return
        }
        self.parent.onSelectionChange(textView.selectedRange())
      }
    }
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
    editor.isEditable = isEditable
    return editor
  }

  public func debounceTime(_ debounceTime: Double) -> Self {
     var editor = self
     editor.debounceTime = debounceTime
     return editor
   }
}
