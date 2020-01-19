import UIKit

open class GraffeinePlotLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative
    public var unitMargin: CGFloat = 4.0

    public var plotDiameter: CGFloat = 0.0
    public var plotBorderColors: [UIColor] = []
    public var plotBorderThickness: CGFloat = 0.0

    override open func generateSublayer() -> CALayer {
        return Plot()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.count

        for (index, plot) in sublayers.enumerated() {
            guard let plot = plot as? Plot, index < numberOfUnits else { continue }
            plot.diameter = plotDiameter
            plot.fillColor = safeIndexedColor(index)
            plot.strokeColor = safeIndexedBorderColor(0)
            plot.lineWidth = plotBorderThickness
            plot.reposition(for: index,
                            in: data,
                            unitWidth: unitWidth,
                            unitMargin: unitMargin,
                            containerSize: bounds.size,
                            animator: animator as? GraffeinePlotDataAnimating)
        }
    }

    open func safeIndexedBorderColor(_ idx: Int) -> CGColor {
        return safeIndexedColor(idx, colors: self.plotBorderColors)
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
            self.plotBorderColors = layer.plotBorderColors
            self.plotBorderThickness = layer.plotBorderThickness
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePlotLayer) -> ()) -> GraffeinePlotLayer {
        conf(self)
        return self
    }
}
