import UIKit

extension GraffeineGridLineLayer {

    open class GridLine: CAShapeLayer {

        open var alignment: Alignment = .center
        open var length: DimensionalUnit = .percentage(1.0)
        open var flipXY: Bool = false

        public func constructPath() -> UIBezierPath{
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
            return path
        }

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
                self.alignment = layer.alignment
                self.length = layer.length
                self.flipXY = layer.flipXY
            }
        }
    }
}
