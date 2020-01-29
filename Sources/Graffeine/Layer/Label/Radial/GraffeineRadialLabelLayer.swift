import UIKit

open class GraffeineRadialLabelLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var diameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var unitText: UnitText = UnitText()

    override open func generateSublayer() -> CALayer {
        return Label()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfLabels = data.values.count
        let total = data.valueMaxOrSum
        let percentages = data.values.map { CGFloat( ($0 ?? 0) / total ) }
        let radius = resolveRadius(diameter: diameter, bounds: bounds)

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfLabels else { continue }
            let text = data.preferredLabelValue(index)
            label.clockwise = clockwise
            label.rotation = rotation
            label.radius = radius
            label.string = text

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)
            unitAnimation.apply(to: label)

            applySelectionState(label, index: index)
            applyRadialSelectionState(label, index: index)

            label.frame.size = label.preferredFrameSize()
            label.reposition(for: index,
                             in: percentages,
                             centerPoint: centerPoint,
                             animator: animator as? GraffeineRadialLabelDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ label: Label, index: Int) {
        if (data.selectedIndex == index) {
            if let selectedDiameter = selection.radial.outerDiameter {
                label.radius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
            } else if let selectedDiameter = selection.radial.innerDiameter {
                label.radius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
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
            self.unitText = layer.unitText
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialLabelLayer) -> ()) -> GraffeineRadialLabelLayer {
        conf(self)
        return self
    }
}
