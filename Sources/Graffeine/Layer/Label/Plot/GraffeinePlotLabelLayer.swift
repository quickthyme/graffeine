import UIKit

open class GraffeinePlotLabelLayer: GraffeineLayer {

    public var unitText: UnitText = UnitText()
    public var diameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)
    public var positioner: Positioner = .column
    public var labelPadding = GraffeineLabel.Padding()
    public var labelAlignment = GraffeineLabel.Alignment(horizontal: .center,
                                                         vertical: .center)

    override open func generateSublayer() -> CALayer {
        return Label()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.count

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfUnits else { continue }
            label.frame = self.bounds

            label.unitColumn = unitColumn
            label.diameter = resolveDiameter(diameter: diameter, bounds: bounds)

            label.padding = labelPadding
            label.alignment = labelAlignment

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)
            unitAnimation.apply(to: label)

            applySelectionState(label, index: index)
            applyRadialSelectionState(label, index: index)

            positioner.get().reposition(label: label,
                                        for: index,
                                        in: data,
                                        containerSize: bounds.size,
                                        animator: animator as? GraffeinePlotLabelDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ label: Label, index: Int) {
        if (data.selectedIndex == index) {
            if let selectedDiameter = selection.radial.outerDiameter {
                label.diameter = resolveDiameter(diameter: selectedDiameter, bounds: bounds)
            } else if let selectedDiameter = selection.radial.innerDiameter {
                label.diameter = resolveDiameter(diameter: selectedDiameter, bounds: bounds)
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
            self.unitText = layer.unitText
            self.diameter = layer.diameter
            self.positioner = layer.positioner
            self.labelPadding = layer.labelPadding
            self.labelAlignment = layer.labelAlignment
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePlotLabelLayer) -> ()) -> GraffeinePlotLabelLayer {
        conf(self)
        return self
    }
}
