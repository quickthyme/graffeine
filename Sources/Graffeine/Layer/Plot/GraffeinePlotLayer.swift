import UIKit

open class GraffeinePlotLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0

    public var plotDiameter: CGFloat = 0.0

    override open func generateSublayer() -> CALayer {
        return Plot()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.count

        for (index, plot) in sublayers.enumerated() {
            guard let plot = plot as? Plot, index < numberOfUnits else { continue }
            plot.diameter = plotDiameter

            unitFill.apply(to: plot)
            unitLine.apply(to: plot)
            unitShadow.apply(to: plot)

            applySelectionState(plot, index: index)

            plot.reposition(for: index,
                            in: data,
                            unitWidth: unitWidth,
                            unitMargin: unitMargin,
                            containerSize: bounds.size,
                            animator: animator as? GraffeinePlotDataAnimating)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
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
            self.plotDiameter = layer.plotDiameter
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePlotLayer) -> ()) -> GraffeinePlotLayer {
        conf(self)
        return self
    }
}
