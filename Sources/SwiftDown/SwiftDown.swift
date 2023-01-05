//
//  SwiftDown.swift
//
//
//  Created by Quentin Eude on 16/03/2021.
//

#if os(iOS)
  import UIKit

  // MARK: - SwiftDown iOS
  public class SwiftDown: UITextView, UITextViewDelegate {
    var storage: Storage = Storage()
    var highlighter: SwiftDownHighligther?

    convenience init(frame: CGRect, theme: Theme) {
      self.init(frame: frame, textContainer: nil)
      self.storage.theme = theme
      self.backgroundColor = theme.backgroundColor
      self.tintColor = theme.tintColor
      self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
      let layoutManager = NSLayoutManager()
      let containerSize = CGSize(width: frame.size.width, height: frame.size.height)
      let container = NSTextContainer(size: containerSize)
      container.widthTracksTextView = true

      layoutManager.addTextContainer(container)
      storage.addLayoutManager(layoutManager)
      super.init(frame: frame, textContainer: container)
      self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      let layoutManager = NSLayoutManager()
      let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
      let container = NSTextContainer(size: containerSize)
      container.widthTracksTextView = true
      layoutManager.addTextContainer(container)
      storage.addLayoutManager(layoutManager)
      self.delegate = self
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
      self.highlighter = SwiftDownHighligther(textView: self)
    }
  }
#else
  import AppKit

  // MARK: - CustomTextView
  class CustomTextView: NSTextView {
    var storage: Storage = Storage()

    convenience init(frame: CGRect, theme: Theme) {
      self.init(frame: frame, textContainer: nil)
      self.storage.theme = theme
      self.backgroundColor = theme.backgroundColor
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
      let layoutManager = NSLayoutManager()
      let containerSize = CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
      let container = NSTextContainer(size: containerSize)
      container.widthTracksTextView = true

      layoutManager.addTextContainer(container)
      storage.addLayoutManager(layoutManager)
      super.init(frame: frame, textContainer: container)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  // MARK: - SwiftDown macOS
  class TransparentBackgroundScroller: NSScroller {
    override func draw(_ dirtyRect: NSRect) {
      self.drawKnob()
    }
  }

  public class SwiftDown: NSView {
    var theme: Theme
    private var isEditable: Bool
    private var insetsSize: CGFloat

    weak var delegate: NSTextViewDelegate? {
      didSet {
        textView.delegate = delegate
      }
    }

    let engine = MarkdownEngine()
    var highlighter: SwiftDownHighligther!

    var text: String {
      didSet {
        textView.string = text
      }
    }

    var selectedRanges: [NSValue] {
      get {
        textView.selectedRanges
      }
      set(value) {
        textView.selectedRanges = value
      }
    }

    // MARK: - ScrollView setup
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
      scrollView.verticalScroller = TransparentBackgroundScroller()
      return scrollView
    }()

    // MARK: - TextView setup
    private lazy var textView: NSTextView = {
      let contentSize = scrollView.contentSize
      let textView = CustomTextView(frame: scrollView.frame, theme: theme)
      textView.delegate = self.delegate
      textView.string = text
      textView.storage.markdowner = { self.engine.render($0, offset: $1) }
      textView.storage.applyMarkdown = { m in Theme.applyMarkdown(markdown: m, with: self.theme) }
      textView.storage.applyBody = { Theme.applyBody(with: self.theme) }
      textView.storage.theme = theme
      textView.autoresizingMask = .width
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

    init(
      theme: Theme, isEditable: Bool, insetsSize: CGFloat = 0
    ) {
      self.isEditable = isEditable
      self.text = ""
      self.theme = theme
      self.insetsSize = insetsSize

      super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

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
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
      ])
    }

    func setupTextView() {
      scrollView.documentView = textView
      highlighter = SwiftDownHighligther(textView: textView)
    }

    func applyStyles() {
      assert(highlighter != nil)
      highlighter.applyStyles()
    }
  }
#endif
