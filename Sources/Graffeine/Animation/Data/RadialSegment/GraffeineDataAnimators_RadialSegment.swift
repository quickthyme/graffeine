import UIKit

public protocol GraffeineRadialSegmentDataAnimating: GraffeineDataAnimating {
    func animate(pieSlice: GraffeineRadialSegmentLayer.Segment,
                 fromAngles: GraffeineAnglePair,
                 toAngles: GraffeineAnglePair,
                 centerPoint: CGPoint)
}

extension GraffeineAnimation.Data {

    public struct RadialSegment {
        private init() {}

        public static func equalizeAngles(_ startAngles: [CGFloat], _ endAngles: [CGFloat]) -> (start: [CGFloat], end: [CGFloat]) {
            var startAngles = startAngles
            var endAngles = endAngles
            while startAngles.count < endAngles.count {
                startAngles.append(startAngles.last ?? 0)
            }
            while endAngles.count < startAngles.count {
                endAngles.append(endAngles.last ?? 0)
            }
            return (start: startAngles, end: endAngles)
        }
    }
}
