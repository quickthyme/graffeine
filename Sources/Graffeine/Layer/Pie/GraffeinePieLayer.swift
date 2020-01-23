import UIKit

open class GraffeinePieLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var diameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var holeDiameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)
    public var centerOffsetDiameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)

    override open func generateSublayer() -> CALayer {
        return PieSlice()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfSlices = data.values.count
        let total = data.valueMaxOrSum
        let percentages = data.values.map { CGFloat( ($0 ?? 0) / total ) }
        let radius = resolveRadius(diameter: diameter, bounds: bounds)
        let holeRadius = resolveRadius(diameter: holeDiameter, bounds: bounds)
        let centerOffsetRadius = resolveRadius(diameter: centerOffsetDiameter, bounds: bounds)

        for (index, slice) in sublayers.enumerated() {
            guard let slice = slice as? PieSlice, index < numberOfSlices else { continue }
            slice.frame = self.bounds
            slice.clockwise = clockwise
            slice.rotation = rotation
            slice.radius = radius
            slice.holeRadius = holeRadius
            slice.centerOffsetRadius = centerOffsetRadius
            unitFill.apply(to: slice, index: index)
            unitLine.apply(to: slice, index: index)
            unitShadow.apply(to: slice)

            applySelectionState(slice, index: index)
            applyRadialSelectionState(slice, index: index)

            slice.reposition(for: index,
                             in: percentages,
                             centerPoint: centerPoint,
                             animator: animator as? GraffeinePieDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ slice: PieSlice, index: Int) {
        if (data.selectedIndex == index) {
            if let selectedDiameter = selection.radial.diameter {
                slice.radius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
            }

            if let selectedHoleDiameter = selection.radial.holeDiameter {
                slice.holeRadius = resolveRadius(diameter: selectedHoleDiameter, bounds: bounds)
            }

            if let selectedCenterOffsetDiameter = selection.radial.centerOffsetDiameter {
                slice.centerOffsetRadius = resolveRadius(diameter: selectedCenterOffsetDiameter, bounds: bounds)
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
            self.diameter = layer.diameter
            self.holeDiameter = layer.holeDiameter
            self.centerOffsetDiameter = layer.centerOffsetDiameter
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePieLayer) -> ()) -> GraffeinePieLayer {
        conf(self)
        return self
    }
}
