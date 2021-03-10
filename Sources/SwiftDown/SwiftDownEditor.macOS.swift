//
//  SwiftDownEditor.macOS.swift
//
//
//  Created by Quentin Eude on 10/03/2021.
//
#if os(macOS)
  import AppKit
  import SwiftUI

  public struct SwiftDownEditor: NSViewRepresentable {
    @Binding var text: String

    private(set) var isEditable: Bool = true
    private(set) var theme: Theme = Theme.BuiltIn.oneDark.theme()
    private(set) var insetsSize: CGFloat = 0

    var onEditingChanged: () -> Void = {}
    var onCommit: () -> Void = {}
    var onTextChange: (String) -> Void = { _ in }

    public func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }

    public func makeNSView(context: Context) -> CustomEditor {
      let editor = CustomEditor(
        text: text, theme: theme, isEditable: isEditable, insetsSize: insetsSize)
      editor.delegate = context.coordinator
      return editor
    }

    public func updateNSView(_ view: CustomEditor, context: Context) {
      view.text = text
      view.selectedRanges = context.coordinator.selectedRanges
    }
  }

  // MARK: - Modifiers
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

  // MARK: - Coordinator
  extension SwiftDownEditor {
    public class Coordinator: NSObject, NSTextViewDelegate {
      var parent: SwiftDownEditor
      var selectedRanges: [NSValue] = []

      init(_ parent: SwiftDownEditor) {
        self.parent = parent
      }

      public func textDidBeginEditing(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
          return
        }

        self.parent.text = textView.string
        self.parent.onEditingChanged()
      }

      public func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
          return
        }

        self.parent.text = textView.string
        self.selectedRanges = textView.selectedRanges
      }

      public func textDidEndEditing(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
          return
        }

        self.parent.text = textView.string
        self.parent.onCommit()
      }
    }
  }

  class OpaqueGridScroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
      self.drawKnob()
    }
  }

  public class CustomEditor: NSView {
    var theme: Theme
    private var isEditable: Bool
    private var insetsSize: CGFloat

    weak var delegate: NSTextViewDelegate?

    var text: String {
      didSet {
        textView.string = text
      }
    }

    var selectedRanges: [NSValue] = [] {
      didSet {
        guard selectedRanges.count > 0 else {
          return
        }

        textView.selectedRanges = selectedRanges
      }
    }

    private lazy var scrollView: NSScrollView = {
      let scrollView = NSScrollView()
      scrollView.drawsBackground = true
      scrollView.borderType = .noBorder
      scrollView.hasVerticalScroller = true
      scrollView.hasHorizontalRuler = false
      scrollView.autoresizingMask = [.width, .height]
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      scrollView.autohidesScrollers = true
      scrollView.borderType = .noBorder
      scrollView.verticalScroller = OpaqueGridScroller()
      return scrollView
    }()

    private lazy var textView: NSTextView = {
      let contentSize = scrollView.contentSize

      let textView = CustomTextView(frame: scrollView.frame, theme: theme)
      textView.autoresizingMask = .width
      textView.delegate = self.delegate
      textView.drawsBackground = true
      textView.isEditable = self.isEditable
      textView.isHorizontallyResizable = false
      textView.isVerticallyResizable = true
      textView.maxSize = NSSize(
        width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
      textView.minSize = NSSize(width: 0, height: contentSize.height)
      textView.textContainerInset = NSSize(width: self.insetsSize, height: self.insetsSize)
      textView.allowsUndo = true
      textView.allowsDocumentBackgroundColorChange = true
      textView.backgroundColor = theme.backgroundColor
      textView.insertionPointColor = theme.cursorColor
      textView.textColor = theme.tintColor
      return textView
    }()

    // MARK: - Init
    init(text: String, theme: Theme, isEditable: Bool, insetsSize: CGFloat = 0) {
      self.isEditable = isEditable
      self.text = text
      self.theme = theme
      self.insetsSize = insetsSize

      super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    public override func viewWillDraw() {
      super.viewWillDraw()

      setupScrollViewConstraints()
      setupTextView()
    }

    func setupScrollViewConstraints() {
      scrollView.translatesAutoresizingMaskIntoConstraints = false

      addSubview(scrollView)

      NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: topAnchor),
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      ])
    }

    func setupTextView() {
      scrollView.documentView = textView
    }

  }

  public class CustomTextView: NSTextView {
    var editor: Editor = Editor()

    convenience public init(frame: CGRect, builtin: Theme.BuiltIn) {
      self.init(frame: frame, theme: builtin.theme())
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
