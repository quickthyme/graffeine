import UIKit

public struct GraffeineAnglePair: Equatable {
    public var start: CGFloat
    public var end: CGFloat
    public init(start: CGFloat, end: CGFloat) {
        self.start = start
        self.end = end
    }

    public var middle: CGFloat {
        let hi = max(start, end)
        let lo = min(start, end)
        return start + ((hi - lo) / 2)
    }

    public static var zero: GraffeineAnglePair { return GraffeineAnglePair(start: 0, end: 0) }

    public static func ==(lhs: GraffeineAnglePair, rhs: GraffeineAnglePair) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }

    public func points(center: CGPoint, radius: CGFloat) -> (start: CGPoint, end: CGPoint) {
        return (start: GraffeineAnglePair.point(for: start, center: center, radius: radius),
                end: GraffeineAnglePair.point(for: end, center: center, radius: radius))
    }

    public static func point(for angle: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle),
                       y: center.y + radius * sin(angle))
    }
}
