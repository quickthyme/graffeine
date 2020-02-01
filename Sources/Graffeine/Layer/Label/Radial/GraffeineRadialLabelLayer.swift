import UIKit

open class GraffeineRadialLabelLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var diameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var unitText: UnitText = UnitText()
    public var labelPadding = GraffeineLabel.Padding()
    public var labelAlignment = DistributedLabelAlignment(horizontal: .center, vertical: .center)

    override open func generateSublayer() -> CALayer {
        return Label()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfLabels = data.values.hi.count
        let total = data.valueMaxOrSumHi
        let percentages = data.values.hi.map { CGFloat( ($0 ?? 0) / total ) }
        let radius = resolveRadius(diameter: diameter, bounds: bounds)

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfLabels else { continue }
            let text = data.preferredLabelValue(index)
            label.clockwise = clockwise
            label.rotation = rotation
            label.radius = radius
            label.string = text
            label.frame.size = label.sizeFittingText
            label.padding = labelPadding
            label.distributedAlignment = labelAlignment

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)
            unitAnimation.apply(to: label)

            applySelectionState(label, index: index)
            applyRadialSelectionState(label, index: index)

            label.reposition(for: index,
                             in: percentages,
                             centerPoint: centerPoint,
                             animator: animator as? GraffeineRadialLabelDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ label: Label, index: Int) {
        if (data.selected.index == index) {
            if let selectedDiameter = selection.radial.outerDiameter {
                label.radius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
            } else if let selectedDiameter = selection.radial.innerDiameter {
                label.radius = resolveRadius(diameter: selectedDiameter, bounds: bounds)
            }
            if let alignment = selection.text.alignment { label.distributedAlignment = alignment }
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
            self.diameter = layer.diameter
            self.unitText = layer.unitText
            self.labelPadding = layer.labelPadding
            self.labelAlignment = layer.labelAlignment
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineRadialLabelLayer) -> ()) -> GraffeineRadialLabelLayer {
        conf(self)
        return self
    }
}
