import UIKit

public struct GraffeineRadialLineLayerDefaultPositioner: GraffeineRadialLineLayerPositioning {

    public func reposition(line: GraffeineRadialLineLayer.Line,
                         for index: Int,
                         in percentages: [CGFloat],
                         centerPoint: CGPoint,
                         animator: GraffeineRadialLineDataAnimating?) {
        let clockwise = line.clockwise
        let rotAngle = rotationAngle(line.rotation, clockwise)
        let pctAngle = PercentageToRadians(percentages[index], clockwise)
        let startAngle = (clockwise)
            ? (0 + startingAngle(for: index, in: percentages, clockwise)) + rotAngle
            : (0 - startingAngle(for: index, in: percentages, clockwise)) + rotAngle
        let endAngle = startAngle + pctAngle
        let newAngles = (clockwise)
            ? GraffeineAnglePair(start: startAngle, end: endAngle)
            : GraffeineAnglePair(start: endAngle, end: startAngle)

        if (line.angles == .zero) {
            line._angles = GraffeineAnglePair(start: newAngles.start, end: newAngles.start)
        }

        let middleAngle = newAngles.middle

        let outerPoint = GraffeineAnglePair.point(for: middleAngle,
                                                  center: centerPoint,
                                                  radius: line.outerRadius)

        let innerPoint = GraffeineAnglePair.point(for: middleAngle,
                                                  center: centerPoint,
                                                  radius: line.innerRadius)

        if let animator = animator {
            animator.animate(line: line,
                             fromAngles: line.angles,
                             toAngles: newAngles,
                             outerPoint: outerPoint,
                             innerPoint: innerPoint)
        } else {
            line.performWithoutAnimation {
                line.path = line.constructPath(outerPoint: outerPoint,
                                               innerPoint: innerPoint,
                                               angles: newAngles)
            }
        }
        line._angles = newAngles
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
