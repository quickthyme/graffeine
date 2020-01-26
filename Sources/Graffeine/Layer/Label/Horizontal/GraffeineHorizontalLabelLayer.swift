import UIKit

open class GraffeineHorizontalLabelLayer: GraffeineLayer {

    public var unitText: UnitText = UnitText()

    public var labelHPadding: CGFloat = 4.0
    public var labelVPadding: CGFloat = 0.0
    public var labelHorizontalAlignmentMode: LabelAlignment.HorizontalMode = .centerLeftRight
    public var labelVerticalAlignmentMode: LabelAlignment.VerticalMode = .center

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
            label.hPadding = labelHPadding
            label.vPadding = labelVPadding
            label.horizontalAlignmentMode = labelHorizontalAlignmentMode
            label.verticalAlignmentMode = labelVerticalAlignmentMode

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)

            applySelectionState(label, index: index)

            label.reposition(for: index,
                             in: data.labels,
                             containerSize: bounds.size)
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, height: CGFloat, region: Region = .bottomGutter) {
        self.init()
        self.id = id
        self.region = region
        self.frame = CGRect(x: 0, y: 0, width: 100, height: height)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.unitText = layer.unitText
            self.labelHPadding = layer.labelHPadding
            self.labelVPadding = layer.labelVPadding
            self.labelHorizontalAlignmentMode = layer.labelHorizontalAlignmentMode
            self.labelVerticalAlignmentMode = layer.labelVerticalAlignmentMode
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineHorizontalLabelLayer) -> ()) -> GraffeineHorizontalLabelLayer {
        conf(self)
        return self
    }
}
