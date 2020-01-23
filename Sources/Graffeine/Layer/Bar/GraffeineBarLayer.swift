import UIKit

open class GraffeineBarLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0
    public var unitSubdivision: GraffeineLayer.UnitSubdivision? = nil
    public var roundedEnds: RoundedEnds = .none

    override open func generateSublayer() -> CALayer {
        return Bar()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.valuesHi.count

        for (index, bar) in sublayers.enumerated() {
            guard let bar = bar as? Bar, index < numberOfUnits else { continue }
            bar.frame = self.bounds
            bar.subdivision = unitSubdivision
            bar.roundedEnds = roundedEnds
            bar.flipXY = flipXY

            unitFill.apply(to: bar, index: index)
            unitLine.apply(to: bar, index: index)
            unitShadow.apply(to: bar)

            if (data.selectedIndex == index) {
                if let color = selection.fill.color { bar.fillColor = color.cgColor }
            }

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
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineBarLayer) -> ()) -> GraffeineBarLayer {
        conf(self)
        return self
    }
}
