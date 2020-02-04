import UIKit

extension GraffeineGridLineLayer {

    open class GridLine: CAShapeLayer {

        open var flipXY: Bool = false

        override public init() {
            super.init()
            self.contentsScale = UIScreen.main.scale
            self.anchorPoint   = CGPoint(x: 0, y: 0)
            self.frame         = CGRect(x: 0, y: 0, width: 1, height: 0)
            self.fillColor     = nil
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.flipXY = layer.flipXY
            }
        }
    }
}
