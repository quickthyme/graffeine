import UIKit

extension GraffeineRadialLabelLayer {

    open class Label: GraffeineLabel {

        public var clockwise: Bool = true
        public var centerRotation: Int = 0
        public var labelRotation: Int = 0
        public var labelRotationInheritFromCenter: Bool = false
        public var radius: CGFloat = 0
        public var distributedAlignment = DistributedLabelAlignment(horizontal: .center, vertical: .center)

        internal var _angles: GraffeineAnglePair = .zero
        public var angles: GraffeineAnglePair { return _angles }

        override public init() {
            super.init()
            self.backgroundColor = UIColor.clear.cgColor
            self.foregroundColor = UIColor.darkGray.cgColor
            self.frame = CGRect(x: 0, y: 0, width: 10.0, height: 10.0)
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.fontSize = 12
            self.string = ""
        }

        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        override public init(layer: Any) {
            super.init(layer: layer)
            if let layer = layer as? Self {
                self.clockwise = layer.clockwise
                self.centerRotation = layer.centerRotation
                self.labelRotation = layer.labelRotation
                self.labelRotationInheritFromCenter = layer.labelRotationInheritFromCenter
                self.radius = layer.radius
                self.distributedAlignment = layer.distributedAlignment
                self._angles = layer.angles
            }
        }
    }
}
