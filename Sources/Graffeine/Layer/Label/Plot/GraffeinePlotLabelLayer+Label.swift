import UIKit

extension GraffeinePlotLabelLayer {

    open class Label: GraffeineLabel {

        public var unitColumn: UnitColumn = UnitColumn()
        public var diameter: CGFloat = 0.0

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.position = .zero
            self.opacity = 0
            self.alignment.horizontal = .center
            self.alignment.vertical = .center
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Label {
                self.unitColumn = layer.unitColumn
                self.diameter = layer.diameter
            }
        }
    }
}
