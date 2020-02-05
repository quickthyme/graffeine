import UIKit

public struct GraffeineRadialSegmentLayerDefaultPositioner: GraffeineRadialSegmentLayerPositioning {

    public func reposition(segment: GraffeineRadialSegmentLayer.Segment,
                           for index: Int,
                           in percentages: [CGFloat],
                           centerPoint: CGPoint,
                           animator: GraffeineRadialSegmentDataAnimating?) {
        let clockwise = segment.clockwise
        let rotAngle = rotationAngle(segment.rotation, clockwise)
        let pctAngle = PercentageToRadians(percentages[index], clockwise)
        let startAngle = (clockwise)
            ? (0 + startingAngle(for: index, in: percentages, clockwise)) + rotAngle
            : (0 - startingAngle(for: index, in: percentages, clockwise)) + rotAngle
        let endAngle = startAngle + pctAngle
        let newAngles = (clockwise)
            ? GraffeineAnglePair(start: startAngle, end: endAngle)
            : GraffeineAnglePair(start: endAngle, end: startAngle)

        if (segment.angles == .zero) {
            segment._angles = GraffeineAnglePair(start: newAngles.start, end: newAngles.start)
        }

        if let animator = animator {
            animator.animate(radialSegment: segment,
                             fromAngles: segment.angles,
                             toAngles: newAngles,
                             centerPoint: centerPoint)
        } else {
            segment.performWithoutAnimation {
                segment.path = segment.constructPath(centerPoint: centerPoint,
                                                     angles: newAngles)
            }
        }
        segment._angles = newAngles
    }

    private func rotationAngle(_ rotation: UInt, _ clockwise: Bool) -> CGFloat {
        return PercentageToRadians( CGFloat(rotation % 360) / 360 , clockwise)
    }

    private func startingAngle(for index: Int, in percentages: [CGFloat], _ clockwise: Bool) -> CGFloat {
        let startingPercentage = percentages[0..<index].reduce(CGFloat(0)) { $0 + $1 }
        let angle = PercentageToRadians(startingPercentage, clockwise)
        return ((clockwise) ? angle : (0 - angle))
    }
}
