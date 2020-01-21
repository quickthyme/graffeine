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

        func apply(to target: Any) {
            (target as? UnitShadowColorAppliable)?.shadowColor = self.color?.cgColor
            (target as? UnitShadowOffsetAppliable)?.shadowOffset = self.offset
            (target as? UnitShadowOpacityAppliable)?.shadowOpacity = Float(self.opacity)
            (target as? UnitShadowRadiusAppliable)?.shadowRadius = self.radius
        }
    }
}

public protocol UnitShadowColorAppliable: class {
    var shadowColor: CGColor? { get set }
}

public protocol UnitShadowOffsetAppliable: class {
    var shadowOffset: CGSize { get set }
}

public protocol UnitShadowOpacityAppliable: class {
    var shadowOpacity: Float { get set }
}

public protocol UnitShadowRadiusAppliable: class {
    var shadowRadius: CGFloat { get set }
}

extension CAShapeLayer:
    UnitShadowColorAppliable,
    UnitShadowOffsetAppliable,
    UnitShadowOpacityAppliable,
    UnitShadowRadiusAppliable {
}

extension CATextLayer:
    UnitShadowColorAppliable,
    UnitShadowOffsetAppliable,
    UnitShadowOpacityAppliable,
    UnitShadowRadiusAppliable {
}
