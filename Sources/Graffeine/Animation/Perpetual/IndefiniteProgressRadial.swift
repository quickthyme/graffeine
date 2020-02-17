import UIKit

extension GraffeineAnimation.Perpetual {

    static let equalizeAngles = GraffeineAnimation.Data.RadialSegment.equalizeAngles

    public static func IndefiniteProgressRadial(radialSegment: @autoclosure @escaping () -> (GraffeineRadialSegmentLayer.Segment),
                                                centerPoint: CGPoint,
                                                duration: TimeInterval) -> (() -> (CAAnimation)) {

        return {
            let segment = radialSegment()
            let rotaion = DegreesToRadians(CGFloat(segment.rotation))

            let initialAngles = GraffeineAnglePair(start: rotaion - DegreesToRadians( 45),
                                                   end:   rotaion + DegreesToRadians( 45))
            let halfwayAngles = GraffeineAnglePair(start: rotaion + DegreesToRadians( 45),
                                                   end:   rotaion + DegreesToRadians(315))
            let fullwayAngles = GraffeineAnglePair(start: rotaion + FullCircleInRadians - DegreesToRadians( 45),
                                                   end:   rotaion + FullCircleInRadians + DegreesToRadians( 45))

            let animation = CAKeyframeAnimation(keyPath: "path")
            animation.timingFunction  = CAMediaTimingFunction(name: .linear)
            animation.duration = duration
            animation.values = interpolatePaths(radialSegment: segment,
                                                initialAngles: initialAngles,
                                                halfwayAngles: halfwayAngles,
                                                fullwayAngles: fullwayAngles,
                                                centerPoint:   centerPoint)
            animation.repeatCount = .infinity
            return animation
        }
    }

    private static func interpolatePaths(radialSegment: GraffeineRadialSegmentLayer.Segment,
                                         initialAngles: GraffeineAnglePair,
                                         halfwayAngles: GraffeineAnglePair,
                                         fullwayAngles: GraffeineAnglePair,
                                         centerPoint: CGPoint) -> [CGPath] {

        let riseStep: (CGFloat, CGFloat) = ((OneDegreeInRadians * 0.25), (OneDegreeInRadians * 0.75))
        let fallStep: (CGFloat, CGFloat) = ((OneDegreeInRadians * 0.75), (OneDegreeInRadians * 0.25))

        let eqAngles1 = equalizeAngles(
            [initialAngles.start]
                + Array<CGFloat>(stride(from: initialAngles.start,
                                        to:   halfwayAngles.start,
                                        by:   riseStep.0)),

            [initialAngles.end]
                + Array<CGFloat>(stride(from: initialAngles.end,
                                        to:   halfwayAngles.end,
                                        by:   riseStep.1))
        )

        let eqAngles2 = equalizeAngles(
            [halfwayAngles.start]
                + Array<CGFloat>(stride(from: halfwayAngles.start,
                                        to:   fullwayAngles.start,
                                        by:   fallStep.0))
                + [fullwayAngles.start],

            [halfwayAngles.end]
                + Array<CGFloat>(stride(from: halfwayAngles.end,
                                        to:   fullwayAngles.end,
                                        by:   fallStep.1))
                + [fullwayAngles.end]
        )

        return zip(eqAngles1.start + eqAngles2.start, eqAngles1.end + eqAngles2.end).map {
            return radialSegment.constructPath(centerPoint: centerPoint,
                                               angles: GraffeineAnglePair(start: $0.0, end: $0.1))
        }
    }
}
