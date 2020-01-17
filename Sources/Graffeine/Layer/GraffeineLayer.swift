import UIKit

open class GraffeineLayer: CALayer {

    public enum Region {
        case main, topGutter, rightGutter, bottomGutter, leftGutter
    }

    open var region: Region = .main

    open var insets: UIEdgeInsets = .zero

    open var id: AnyHashable = Int(0)

    open var flipXY: Bool = false {
        didSet { self.reset() }
    }

    public var data: GraffeineLayer.Data = GraffeineLayer.Data() {
        didSet { self.reset() }
    }

    public var colors: [UIColor] = []

    open func removeAllSublayers() {
        for layer in sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
    }

    open func generateSublayers() {
        /* */
    }

    open func repositionSublayers() {
        /* */
    }

    open func safeIndexedColor(_ idx: Int) -> CGColor {
        return safeIndexedColor(idx, colors: self.colors)
    }

    internal func safeIndexedColor(_ idx: Int, colors: [UIColor]) -> CGColor {
        guard (!colors.isEmpty) else { return UIColor.black.cgColor }
        return colors[(idx % colors.count)].cgColor
    }

    override public init() {
        super.init()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? GraffeineLayer {
            self.region = layer.region
            self.insets = layer.insets
            self.id = layer.id
            self.flipXY = layer.flipXY
            self.data = layer.data
            self.colors = layer.colors
        }
    }

    override open func layoutSublayers() {
        super.layoutSublayers()
        repositionSublayers()
    }

    open func reset() {
        removeAllSublayers()
        generateSublayers()
    }

    @discardableResult
    open func apply(_ conf: (GraffeineLayer) -> ()) -> GraffeineLayer {
        conf(self)
        return self
    }
}
