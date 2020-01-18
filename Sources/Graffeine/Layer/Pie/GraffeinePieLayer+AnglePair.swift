import UIKit

extension GraffeinePieLayer {

    public struct AnglePair: Equatable {
        public var start: CGFloat
        public var end: CGFloat
        public init(start: CGFloat, end: CGFloat) {
            self.start = start
            self.end = end
        }

        public static var zero: AnglePair { return AnglePair(start: 0, end: 0) }

        public static func ==(lhs: AnglePair, rhs: AnglePair) -> Bool {
            return lhs.start == rhs.start && lhs.end == rhs.end
        }

        public func points(center: CGPoint, radius: CGFloat) -> (start: CGPoint, end: CGPoint) {
            return (start: AnglePair.point(for: start, center: center, radius: radius),
                    end: AnglePair.point(for: end, center: center, radius: radius))
        }

        public static func point(for angle: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint {
            return CGPoint(x: center.x + radius * cos(angle),
                           y: center.y + radius * sin(angle))
        }
    }
}
