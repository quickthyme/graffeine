import UIKit

open class GraffeinePlotLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative

    public var diameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)

    override open func generateSublayer() -> CALayer {
        return Plot()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.count

        for (index, plot) in sublayers.enumerated() {
            guard let plot = plot as? Plot, index < numberOfUnits else { continue }
            plot.frame = self.bounds

            plot.unitColumn = unitColumn
            plot.diameter = resolveDiameter(diameter: diameter, bounds: bounds)

            unitFill.apply(to: plot, index: index)
            unitLine.apply(to: plot, index: index)
            unitShadow.apply(to: plot)
            unitAnimation.apply(to: plot)

            applySelectionState(plot, index: index)
            applyRadialSelectionState(plot, index: index)

            plot.reposition(for: index,
                            in: data,
                            containerSize: bounds.size,
                            animator: animator as? GraffeinePlotDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ plot: Plot, index: Int) {
        if (data.selectedIndex == index) {
            if let selectedDiameter = selection.radial.outerDiameter {
                plot.diameter = resolveDiameter(diameter: selectedDiameter, bounds: bounds)
            } else if let selectedDiameter = selection.radial.innerDiameter {
                plot.diameter = resolveDiameter(diameter: selectedDiameter, bounds: bounds)
            }
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
            self.diameter = layer.diameter
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePlotLayer) -> ()) -> GraffeinePlotLayer {
        conf(self)
        return self
    }
}
