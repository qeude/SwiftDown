//
//  SwiftDownEditor.iOS.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//

import Foundation

#if os(iOS)
  import SwiftUI
  import UIKit

  public struct SwiftDownEditor: UIViewRepresentable {
    @Binding public var text: String

    private(set) var isEditable: Bool = true
    private(set) var theme: Theme = Theme.BuiltIn.oneDark.theme()
    private(set) var insetsSize: CGFloat = 0
    private(set) var autocapitalizationType: UITextAutocapitalizationType = .sentences
    private(set) var autocorrectionType: UITextAutocorrectionType = .default
    private(set) var keyboardType: UIKeyboardType = .default
    private(set) var textAlignment: TextAlignment = .leading

    public var onEditingChanged: () -> Void = {}
    public var onCommit: () -> Void = {}
    public var onTextChange: (String) -> Void = { _ in }

    public init(
      text: Binding<String>,
      onEditingChanged: @escaping () -> Void = {},
      onCommit: @escaping () -> Void = {},
      onTextChange: @escaping (String) -> Void = { _ in }
    ) {
      _text = text
      self.onEditingChanged = onEditingChanged
      self.onCommit = onCommit
      self.onTextChange = onTextChange
    }

    public func makeUIView(context: Context) -> CustomTextView {
      let editor = CustomTextView(frame: .zero, theme: theme)
      editor.isEditable = true
      editor.isScrollEnabled = true
      editor.keyboardType = keyboardType
      editor.autocapitalizationType = autocapitalizationType
      editor.autocorrectionType = autocorrectionType
      editor.backgroundColor = theme.backgroundColor
      editor.textContainerInset = UIEdgeInsets(
        top: insetsSize, left: insetsSize, bottom: insetsSize, right: insetsSize)
      editor.tintColor = theme.tintColor
      editor.delegate = context.coordinator
      return editor
    }

    public func updateUIView(_ view: CustomTextView, context: Context) {
      view.selectedTextRange = context.coordinator.selectedTextRange
    }

    public func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }
  }

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
  }

  extension SwiftDownEditor {
    public class Coordinator: NSObject, UITextViewDelegate {
      var parent: SwiftDownEditor
      var selectedTextRange: UITextRange? = nil

      init(_ parent: SwiftDownEditor) {
        self.parent = parent
      }

      public func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }

        self.parent.text = textView.text
        selectedTextRange = textView.selectedTextRange
      }

      public func textViewDidBeginEditing(_ textView: UITextView) {
        parent.onEditingChanged()
      }

      public func textViewDidEndEditing(_ textView: UITextView) {
        parent.onCommit()
      }
    }
  }

  public class CustomTextView: UITextView {
    var editor: Editor = Editor()

    convenience public init(frame: CGRect, theme: Theme.BuiltIn) {
      self.init(frame: frame, theme: theme.theme())
    }

    convenience public init(frame: CGRect, theme: Theme) {
      self.init(frame: frame, textContainer: nil)
      editor.theme = theme
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
      let layoutManager = NSLayoutManager()
      let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
      let container = NSTextContainer(size: containerSize)
      container.widthTracksTextView = true

      layoutManager.addTextContainer(container)
      editor.addLayoutManager(layoutManager)
      super.init(frame: frame, textContainer: container)
    }

    required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      let layoutManager = NSLayoutManager()
      let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
      let container = NSTextContainer(size: containerSize)
      container.widthTracksTextView = true

      layoutManager.addTextContainer(container)
      editor.addLayoutManager(layoutManager)
    }
  }
#endif
