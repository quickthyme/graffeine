import UIKit

open class GraffeineVerticalLabelLayer: GraffeineLayer {

    public var rowHeight: GraffeineLayer.DimensionalUnit = .relative
    public var rowMargin: CGFloat = 0.0
    public var unitText: UnitText = UnitText()

    public var labelPadding = GraffeineLabel.Padding()
    public var labelAlignment = DistributedLabelAlignment(horizontal: .right,
                                                          vertical: .centerTopBottom)

    override public var unitColumn: GraffeineLayer.UnitColumn {
        get {
            return UnitColumn.init(width: rowHeight,
                                   subdivision: UnitSubdivision(),
                                   margin: rowMargin)
        }
        set {
            self.rowHeight = newValue.width
            self.rowMargin = newValue.margin
        }
    }

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

            label.unitColumn = unitColumn
            label.padding = labelPadding
            label.alignment = labelAlignment.graffeineLabelAlignment(for: index, count: numberOfUnits)

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)
            unitAnimation.apply(to: label)

            applySelectionState(label, index: index)

            label.reposition(for: index,
                             in: data.labels,
                             rowHeight: rowHeight,
                             rowMargin: rowMargin,
                             containerSize: bounds.size)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, width: CGFloat, region: Region = .leftGutter) {
        self.init()
        self.id = id
        self.region = region
        self.frame = CGRect(x: 0, y: 0, width: width, height: 100)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.rowHeight = layer.rowHeight
            self.rowMargin = layer.rowMargin
            self.unitText = layer.unitText
            self.labelPadding = layer.labelPadding
            self.labelAlignment = layer.labelAlignment
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineVerticalLabelLayer) -> ()) -> GraffeineVerticalLabelLayer {
        conf(self)
        return self
    }
}
