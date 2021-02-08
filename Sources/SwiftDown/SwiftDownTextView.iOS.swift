//
//  SwiftDownTextView.iOS.swift
//  SampleApp
//
//  Created by Quentin Eude on 08/02/2021.
//
#if os(iOS)
  import SwiftUI
  import UIKit

  public struct SwiftDownTextView: UIViewRepresentable {
    @Binding var text: String {
      didSet {
        self.onTextChange(text)
      }
    }

    var swiftDown: SwiftDown

    var onEditingChanged: () -> Void = {}
    var onCommit: () -> Void = {}
    var onTextChange: (String) -> Void = { _ in }

    private(set) var autocapitalizationType: UITextAutocapitalizationType = .sentences
    private(set) var autocorrectionType: UITextAutocorrectionType = .default
    private(set) var backgroundColor: UIColor? = nil
    private(set) var color: UIColor? = nil
    private(set) var font: UIFont? = nil
    private(set) var insertionPointColor: UIColor? = nil
    private(set) var keyboardType: UIKeyboardType = .default
    private(set) var textAlignment: TextAlignment = .leading

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
      self.swiftDown = SwiftDown()
    }

    public func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }

    public func makeUIView(context: Context) -> UITextView {
      let textView = UITextView()
      textView.delegate = context.coordinator
      textView.isEditable = true
      textView.isScrollEnabled = true
      textView.font = font
      updateTextViewModifiers(textView)

      return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
      uiView.isScrollEnabled = false

      let formattedText =
        swiftDown
        .getFormattedText(from: text)

      if let range = uiView.markedTextNSRange {
        uiView.setAttributedMarkedText(formattedText, selectedRange: range)
      } else {
        uiView.attributedText = formattedText
      }
      updateTextViewModifiers(uiView)
      uiView.isScrollEnabled = true
      uiView.selectedTextRange = context.coordinator.selectedTextRange
    }

    private func updateTextViewModifiers(_ textView: UITextView) {
      textView.keyboardType = keyboardType
      textView.autocapitalizationType = autocapitalizationType
      textView.autocorrectionType = autocorrectionType

      textView.backgroundColor = backgroundColor
      let layoutDirection = UIView.userInterfaceLayoutDirection(
        for: textView.semanticContentAttribute)
      textView.textAlignment = NSTextAlignment(
        textAlignment: textAlignment, userInterfaceLayoutDirection: layoutDirection)
      textView.tintColor = insertionPointColor ?? textView.tintColor

      let textInputTraits = textView.value(forKey: "textInputTraits") as? NSObject
      textInputTraits?.setValue(textView.tintColor, forKey: "insertionPointColor")
    }

    public class Coordinator: NSObject, UITextViewDelegate {
      var parent: SwiftDownTextView
      var selectedTextRange: UITextRange? = nil

      init(_ parent: SwiftDownTextView) {
        self.parent = parent
      }

      public func textViewDidChange(_ textView: UITextView) {

        // For Multistage Text Input
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

  extension SwiftDownTextView {
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

    public func backgroundColor(_ color: UIColor) -> Self {
      var new = self
      new.backgroundColor = color
      return new
    }

    public func keyboardType(_ type: UIKeyboardType) -> Self {
      var new = self
      new.keyboardType = type
      return new
    }

    public func insertionPointColor(_ color: UIColor) -> Self {
      var new = self
      new.insertionPointColor = color
      return new
    }

    public func multilineTextAlignment(_ alignment: TextAlignment) -> Self {
      var new = self
      new.textAlignment = alignment
      return new
    }
  }
#endif
