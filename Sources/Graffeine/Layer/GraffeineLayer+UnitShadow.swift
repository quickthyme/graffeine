import UIKit

extension GraffeineLayer {

    public struct UnitShadow {
        public var color:   UIColor?
        public var opacity: CGFloat
        public var radius:  CGFloat
        public var offset:  CGSize

        public init(color:   UIColor? = nil,
                    opacity: CGFloat = 0.0,
                    radius:  CGFloat = 0.0,
                    offset:  CGSize = .zero) {

            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }

        public func apply(to target: CAShapeLayer) {
            target.shadowColor = self.color?.cgColor
            target.shadowOffset = self.offset
            target.shadowOpacity = Float(self.opacity)
            target.shadowRadius = self.radius
        }

        public func apply(to target: CATextLayer) {
            target.shadowColor = self.color?.cgColor
            target.shadowOffset = self.offset
            target.shadowOpacity = Float(self.opacity)
            target.shadowRadius = self.radius
        }
    }
}
