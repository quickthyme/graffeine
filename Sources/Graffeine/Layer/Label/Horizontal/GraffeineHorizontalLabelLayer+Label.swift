import UIKit

extension GraffeineHorizontalLabelLayer {

    public class Label: GraffeineLabel {

        public var unitColumn: UnitColumn = UnitColumn()
        public var labelRotation: Int = 0

        override public init() {
            super.init()
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.unitColumn = layer.unitColumn
                self.labelRotation = layer.labelRotation
            }
        }
    }
}
