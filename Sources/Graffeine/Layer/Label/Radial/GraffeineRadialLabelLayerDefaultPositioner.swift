import UIKit

public struct GraffeineRadialLabelLayerDefaultPositioner: GraffeineRadialLabelLayerPositioning {

    public func reposition(label: GraffeineRadialLabelLayer.Label,
                           for index: Int,
                           in percentages: [CGFloat],
                           centerPoint: CGPoint,
                           animator: GraffeineRadialLabelDataAnimating?) {
        let clockwise = label.clockwise
        let centerAngle = rotationValueToAngle(label.centerRotation, clockwise)
        let pctAngle = PercentageToRadians(percentages[index], clockwise)
        let startAngle = startingAngle(for: index, in: percentages, clockwise) + centerAngle
        let endAngle = startAngle + pctAngle
        let newAngles = (clockwise)
            ? GraffeineAnglePair(start: startAngle, end: endAngle)
            : GraffeineAnglePair(start: endAngle, end: startAngle)
        if (label.angles == .zero) {
            label._angles = GraffeineAnglePair(start: newAngles.start, end: newAngles.start)
        }

        let middleAngle = newAngles.middle

        let labelTextAngle = rotationValueToAngle(label.labelRotation, clockwise)

        let labelPoint = GraffeineAnglePair.point(for: middleAngle,
                                                  center: centerPoint,
                                                  radius: label.radius)

        label.alignment = label.distributedAlignment.graffeineRadialLabelAlignment(labelPoint: labelPoint,
                                                                                   centerPoint: centerPoint)
        label.anchorPoint = deriveAnchorPoint(label)

        label.transform = labelRotationTransform(centerRotationAngle: centerAngle,
                                                 labelAngle: labelTextAngle,
                                                 positionAngle: middleAngle,
                                                 label: label)

        if let animator = animator {
            animator.animate(label: label,
                             fromAngles: label.angles,
                             toAngles: newAngles,
                             labelPoint: labelPoint,
                             centerPoint: centerPoint)
        } else {
            label.performWithoutAnimation {
                label.position = labelPoint
            }
        }
        label._angles = newAngles
    }

    private func rotationValueToAngle(_ rotationVal: Int, _ clockwise: Bool) -> CGFloat {
        return DegreesToRadians(CGFloat(rotationVal % 360), clockwise)
    }

    private func labelRotationTransform(centerRotationAngle: CGFloat,
                                        labelAngle: CGFloat,
                                        positionAngle: CGFloat,
                                        label: GraffeineRadialLabelLayer.Label) -> CATransform3D {
        guard (label.labelRotationInheritFromCenter || label.labelRotation != 0) else { return CATransform3DIdentity }
        let angle = ((label.labelRotationInheritFromCenter) ? positionAngle : 0)
            + centerRotationAngle
            + labelAngle
        return CATransform3DMakeRotation(angle, 0, 0, 1)
    }

    private func startingAngle(for index: Int, in percentages: [CGFloat], _ clockwise: Bool) -> CGFloat {
        let startingPercentage = percentages[0..<index].reduce(CGFloat(0)) { $0 + $1 }
        let angle = (startingPercentage * FullCircleInRadians)
        return ((clockwise) ? angle : (0 - angle))
    }

    private func deriveAnchorPoint(_ label: GraffeineRadialLabelLayer.Label) -> CGPoint {
        let x: CGFloat
        switch label.alignment.horizontal {
        case .left:     x = 0
        case .right:    x = 1
        case .center:   x = 0.5
        }
        let y: CGFloat
        switch label.alignment.vertical {
        case .top:      y = 0
        case .bottom:   y = 1
        case .center:   y = 0.5
        }
        return CGPoint(x: x, y: y)
    }
}
