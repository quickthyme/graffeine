import UIKit

open class GraffeineLabel: CALayer {

    public struct Alignment: Equatable {
        public enum Horizontal: Equatable {
            case left, center, right
        }

        public enum Vertical: Equatable {
            case top, center, bottom
        }

        public var horizontal: Horizontal = .center
        public var vertical: Vertical = .center
        public init() {}
        public init(horizontal: Horizontal, vertical: Vertical) {
            self.horizontal = horizontal
            self.vertical = vertical
        }
    }

    public struct Padding: Equatable {
        public var horizontal: CGFloat = 0
        public var vertical: CGFloat = 0
        public init() {}
        public init(horizontal: CGFloat, vertical: CGFloat) {
            self.horizontal = horizontal
            self.vertical = vertical
        }
        public static var zero: Padding {
            return Padding()
        }
    }

    internal lazy var text: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        return layer
    }()

    public var alignment: Alignment = Alignment()
    public var padding: Padding = Padding()

    public var font: CFTypeRef? {
        get { return text.font }
        set {
            text.font = newValue
            text.layoutIfNeeded()
        }
    }

    public var fontSize: CGFloat {
        get { return text.fontSize }
        set {
            text.fontSize = newValue
            text.layoutIfNeeded()
        }
    }

    public var string: String? {
        get { return (text.string as? String)
            ?? (text.string as? NSAttributedString)?.string }
        set {
            text.string = newValue
            text.layoutIfNeeded()
        }
    }

    override public var backgroundColor: CGColor? {
        get { return text.backgroundColor }
        set {
            super.backgroundColor = nil
            text.backgroundColor = newValue
            text.layoutIfNeeded()
        }
    }

    public var foregroundColor: CGColor? {
        get { return text.foregroundColor }
        set {
            text.foregroundColor = newValue
            text.layoutIfNeeded()
        }
    }

    public override var borderColor: CGColor? {
        get { return text.borderColor }
        set {
            super.borderColor = nil
            text.borderColor = newValue
            text.layoutIfNeeded()
        }
    }

    public override var borderWidth: CGFloat {
        get { return text.borderWidth }
        set {
            super.borderWidth = 0
            text.borderWidth = newValue
            text.layoutIfNeeded()
        }
    }

    public override var shadowColor: CGColor? {
        get { return text.shadowColor }
        set {
            super.shadowColor = nil
            text.shadowColor = newValue
            text.layoutIfNeeded()
        }
    }

    public override var shadowOffset: CGSize {
        get { return text.shadowOffset }
        set {
            super.shadowOffset = .zero
            text.shadowOffset = newValue
            text.layoutIfNeeded()
        }
    }

    public override var shadowOpacity: Float {
        get { return text.shadowOpacity }
        set {
            super.shadowOpacity = 0
            text.shadowOpacity = newValue
            text.layoutIfNeeded()
        }
    }

    public override var shadowRadius: CGFloat {
        get { return text.shadowRadius }
        set {
            super.shadowRadius = 0
            text.shadowRadius = newValue
            text.layoutIfNeeded()
        }
    }

    public override var shadowPath: CGPath? {
        get { return text.shadowPath }
        set {
            super.shadowPath = nil
            text.shadowPath = newValue
            text.layoutIfNeeded()
        }
    }

    public var sizeFittingText: CGSize {
        return text.preferredFrameSize()
    }

    override open class func needsDisplay(forKey key: String) -> Bool {
        return key == "alignment"
            || key == "padding"
            || super.needsDisplay(forKey: key)
    }

    override open func layoutSublayers() {
        super.layoutSublayers()
        if (text.superlayer == nil) { self.addSublayer(text) }
        let h = getTextHPosition(bounds)
        let v = getTextVPosition(bounds)
        performWithoutAnimation {
            text.frame.size = text.preferredFrameSize()
            text.alignmentMode = h.align
            text.anchorPoint = CGPoint(x: h.anchor, y: v.anchor)
            text.position = CGPoint(x: h.x, y: v.y)
        }
    }

    func getTextHPosition(_ bounds: CGRect) -> (x: CGFloat, anchor: CGFloat, align: CATextLayerAlignmentMode) {
        let boundWidth = bounds.size.width
        switch alignment.horizontal {
        case .left:     return (x: padding.horizontal, anchor: 0, align: .left)
        case .center:   return (x: (boundWidth / 2), anchor: 0.5, align: .center)
        case .right:    return (x: (boundWidth - padding.horizontal), anchor: 1.0, align: .right)
        }
    }

    func getTextVPosition(_ bounds: CGRect) -> (y: CGFloat, anchor: CGFloat) {
        let boundHeight = bounds.size.height
        switch alignment.vertical {
        case .top:      return (y: padding.vertical, anchor: 0)
        case .center:   return (y: (boundHeight / 2), anchor: 0.5)
        case .bottom:   return (y: (boundHeight - padding.vertical), anchor: 1.0)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
        self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.string = layer.string
            self.backgroundColor = layer.backgroundColor
            self.foregroundColor = layer.foregroundColor
            self.font = layer.font
            self.fontSize = layer.fontSize
            self.alignment = layer.alignment
            self.padding = layer.padding
        }
    }
}
