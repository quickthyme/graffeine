import UIKit

open class GraffeineRadialLineLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var outerDiameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var innerDiameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)

    override open func generateSublayer() -> CALayer {
        return Line()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfSlices = data.values.count
        let total = data.valueMaxOrSum
        let percentages = data.values.map { CGFloat( ($0 ?? 0) / total ) }
        let outerRadius = resolveRadius(diameter: outerDiameter, bounds: bounds)
        let innerRadius = resolveRadius(diameter: innerDiameter, bounds: bounds)

        for (index, line) in sublayers.enumerated() {
            guard let line = line as? Line, index < numberOfSlices else { continue }
            line.frame = self.bounds
            line.clockwise = clockwise
            line.rotation = rotation
            line.outerRadius = outerRadius
            line.innerRadius = innerRadius

            unitLine.apply(to: line, index: index)
            unitShadow.apply(to: line)
            unitAnimation.apply(to: line)

            applySelectionState(line, index: index)
            applyRadialSelectionState(line, index: index)

            line.reposition(for: index,
                             in: percentages,
                             centerPoint: centerPoint,
                             animator: animator as? GraffeineRadialLineDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ line: Line, index: Int) {
        if (data.selectedIndex == index) {
            if let selectedDiameter = selection.radial.outerDiameter {
                line.outerRadius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
            }

            if let selectedHoleDiameter = selection.radial.innerDiameter {
                line.innerRadius = resolveRadius(diameter: selectedHoleDiameter, bounds: bounds)
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
            self.clockwise = layer.clockwise
            self.rotation = layer.rotation
            self.outerDiameter = layer.outerDiameter
            self.innerDiameter = layer.innerDiameter
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialLineLayer) -> ()) -> GraffeineRadialLineLayer {
        conf(self)
        return self
    }
}
