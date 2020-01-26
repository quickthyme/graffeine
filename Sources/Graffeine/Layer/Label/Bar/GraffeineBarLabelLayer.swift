import UIKit

open class GraffeineBarLabelLayer: GraffeineLayer {

    public var unitText: UnitText = UnitText()

    public var labelPadding: GraffeineLabel.Padding = .zero
    public var labelAlignment: GraffeineLabel.Alignment = GraffeineLabel.Alignment()

    override open var expectedNumberOfSublayers: Int {
        return self.data.labels.count
    }

    override open func generateSublayer() -> CALayer {
        return Label()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.labels.count

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfUnits else { continue }
            label.flipXY = flipXY
            label.unitColumn = unitColumn

            let newPadding = labelPadding
            let newAlignment = labelAlignment

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)

            applySelectionState(label, index: index)

            label.reposition(for: index,
                             in: data,
                             alignment: newAlignment,
                             padding: newPadding,
                             containerSize: bounds.size,
                             animator: animator as? GraffeineLabelDataAnimating)
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

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.unitText = layer.unitText
            self.labelPadding = layer.labelPadding
            self.labelAlignment = layer.labelAlignment
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineBarLabelLayer) -> ()) -> GraffeineBarLabelLayer {
        conf(self)
        return self
    }
}
