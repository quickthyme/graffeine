import UIKit

open class GraffeineRadialSegmentLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var outerDiameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var innerDiameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)
    public var centerOffsetDiameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)

    override open func generateSublayer() -> CALayer {
        return Segment()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfSegments = data.values.hi.count
        let total = data.valueMaxOrSumHi
        let percentages = data.values.hi.map { CGFloat( ($0 ?? 0) / total ) }
        let outerRadius = resolveRadius(diameter: outerDiameter, bounds: bounds)
        let innerRadius = resolveRadius(diameter: innerDiameter, bounds: bounds)
        let centerOffsetRadius = resolveRadius(diameter: centerOffsetDiameter, bounds: bounds)

        for (index, segment) in sublayers.enumerated() {
            guard let segment = segment as? Segment, index < numberOfSegments else { continue }
            segment.frame = self.bounds
            segment.clockwise = clockwise
            segment.rotation = rotation
            segment.outerRadius = outerRadius
            segment.innerRadius = innerRadius
            segment.centerOffsetRadius = centerOffsetRadius

            unitFill.apply(to: segment, index: index)
            unitLine.apply(to: segment, index: index)
            unitShadow.apply(to: segment)
            unitAnimation.apply(to: segment)

            applySelectionState(segment, index: index)
            applyRadialSelectionState(segment, index: index)

            segment.reposition(for: index,
                               in: percentages,
                               centerPoint: centerPoint,
                               animator: animator as? GraffeineRadialSegmentDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ segment: Segment, index: Int) {
        if (data.selected.index == index) {
            if let selectedDiameter = selection.radial.outerDiameter {
                segment.outerRadius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
            }

            if let selectedHoleDiameter = selection.radial.innerDiameter {
                segment.innerRadius = resolveRadius(diameter: selectedHoleDiameter, bounds: bounds)
            }

            if let selectedCenterOffsetDiameter = selection.radial.centerOffsetDiameter {
                segment.centerOffsetRadius = resolveRadius(diameter: selectedCenterOffsetDiameter, bounds: bounds)
            }
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
            self.clockwise = layer.clockwise
            self.rotation = layer.rotation
            self.outerDiameter = layer.outerDiameter
            self.innerDiameter = layer.innerDiameter
            self.centerOffsetDiameter = layer.centerOffsetDiameter
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialSegmentLayer) -> ()) -> GraffeineRadialSegmentLayer {
        conf(self)
        return self
    }
}
