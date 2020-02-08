import UIKit

open class GraffeineBarLayer: GraffeineLayer {

    public var positioner: Positioner = .default
    public var roundedEnds: RoundedEnds = .none

    override open func generateSublayer() -> CALayer {
        return Bar()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.hi.count

        for (index, bar) in sublayers.enumerated() {
            guard let bar = bar as? Bar, index < numberOfUnits else { continue }
            bar.frame = self.bounds

            bar.unitColumn = unitColumn
            bar.roundedEnds = roundedEnds
            bar.flipXY = flipXY

            unitFill.apply(to: bar, index: index)
            unitLine.apply(to: bar, index: index)
            unitShadow.apply(to: bar)
            unitAnimation.apply(to: bar)

            applySelectionState(bar, index: index)

            let txData = GraffeineData(transposed: data)

            positioner.get().reposition(bar: bar,
                                        for: index,
                                        in: txData,
                                        containerSize: bounds.size,
                                        animator: animator as? GraffeineBarDataAnimating)
        }
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
            self.positioner = layer.positioner
            self.roundedEnds = layer.roundedEnds
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineBarLayer) -> ()) -> GraffeineBarLayer {
        conf(self)
        return self
    }
}
