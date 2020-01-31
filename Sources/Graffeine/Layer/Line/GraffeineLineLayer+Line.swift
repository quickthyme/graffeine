import UIKit

extension GraffeineLineLayer {

    open class Line: CAShapeLayer {

        public var unitColumn: UnitColumn = UnitColumn()

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            self.fillColor = nil
            self.path = nil
            self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.position = CGPoint(x: 0.0, y: 0.0)
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.unitColumn = layer.unitColumn
            }
        }
    }
}
