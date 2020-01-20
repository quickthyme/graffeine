import UIKit

open class GraffeineBarLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0
    public var unitSubdivision: GraffeineLayer.UnitSubdivision? = nil
    public var roundedEnds: RoundedEnds = .none

    public var barShadowColor:   UIColor? = nil
    public var barShadowOpacity: CGFloat = 0.0
    public var barShadowRadius:  CGFloat = 0.0
    public var barShadowOffset:  CGSize = .zero

    override open func generateSublayer() -> CALayer {
        return Bar()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.valuesHi.count

        for (index, bar) in sublayers.enumerated() {
            guard let bar = bar as? Bar, index < numberOfUnits else { continue }
            bar.frame = self.bounds
            bar.fillColor = safeIndexedColor(index)
            if let shadowColor = barShadowColor {
                bar.shadowColor = shadowColor.cgColor
                bar.shadowOpacity = Float(barShadowOpacity)
                bar.shadowRadius = barShadowRadius
                bar.shadowOffset = barShadowOffset
            }
            bar.subdivision = unitSubdivision
            bar.roundedEnds = roundedEnds
            bar.flipXY = flipXY
            bar.reposition(for: index,
                           in: data,
                           unitWidth: unitWidth,
                           unitMargin: unitMargin,
                           containerSize: bounds.size,
                           animator: animator as? GraffeineBarDataAnimating)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
        self.masksToBounds = true
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
            self.unitWidth = layer.unitWidth
            self.unitMargin = layer.unitMargin
            self.unitSubdivision = layer.unitSubdivision
            self.roundedEnds = layer.roundedEnds
            self.barShadowColor = layer.barShadowColor
            self.barShadowRadius = layer.barShadowRadius
            self.barShadowOffset = layer.barShadowOffset
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineBarLayer) -> ()) -> GraffeineBarLayer {
        conf(self)
        return self
    }
}
