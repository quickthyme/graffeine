import UIKit

open class GraffeineBarLayer: GraffeineLayer {

    public var roundedEnds: RoundedEnds = .none

    public var clipLoEdge: Bool = false

    override open func generateSublayer() -> CALayer {
        return Bar()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.hi.count

        for (index, bar) in sublayers.enumerated() {
            guard let bar = bar as? Bar, index < numberOfUnits else { continue }
            bar.frame = self.bounds
            applyLoEdgeClippingMaskIfEnabled()

            bar.unitColumn = unitColumn
            bar.roundedEnds = roundedEnds
            bar.flipXY = flipXY

            unitFill.apply(to: bar, index: index)
            unitLine.apply(to: bar, index: index)
            unitShadow.apply(to: bar)
            unitAnimation.apply(to: bar)

            applySelectionState(bar, index: index)

            bar.reposition(for: index,
                           in: data,
                           containerSize: bounds.size,
                           animator: animator as? GraffeineBarDataAnimating)
        }
    }

    open func applyLoEdgeClippingMaskIfEnabled() {
        guard (clipLoEdge) else { return }
        let mask = CAShapeLayer()
        mask.contentsScale = UIScreen.main.scale
        mask.path = UIBezierPath(rect: rectForLoEdgeClippingMask).cgPath
        mask.fillColor = UIColor.black.cgColor
        self.mask = mask
    }

    private var rectForLoEdgeClippingMask: CGRect {
        return (flipXY)
            ? CGRect(x: 0,
                     y: -20,
                     width: bounds.width + 20,
                     height: bounds.height + 40)
            : CGRect(x: -20,
                     y: -20,
                     width: bounds.width + 40,
                     height: bounds.height + 20)
    }

    override public init() {
        super.init()
    }

    public convenience init(id: AnyHashable, region: Region = .main) {
        self.init()
        self.id = id
        self.region = region
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.roundedEnds = layer.roundedEnds
            self.clipLoEdge = layer.clipLoEdge
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineBarLayer) -> ()) -> GraffeineBarLayer {
        conf(self)
        return self
    }
}
