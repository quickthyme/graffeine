import UIKit

public struct GraffeineVerticalLabelLayerDefaultPositioner: GraffeineVerticalLabelLayerPositioning {

    public func reposition(label: GraffeineVerticalLabelLayer.Label,
                           for index: Int,
                           in labels: [String?],
                           rowHeight: GraffeineLayer.DimensionalUnit,
                           rowMargin: CGFloat,
                           containerSize: CGSize) {

        let labelsCount = labels.count
        let labelValue = (index < labelsCount) ? (labels[index] ?? "") : ""


        let height = rowHeight.resolved(within: containerSize.height,
                                        numberOfUnits: labels.count,
                                        unitMargin: rowMargin)

        let yPos = (CGFloat(index) * (height + rowMargin))

        let newFrame = CGRect(x: 0, y: yPos, width: containerSize.width, height: height)

        let newTransform = labelRotationTransform(label.labelRotation)

        label.performWithoutAnimation {
            label.string = labelValue
            label.frame = newFrame
            label.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            label.transform = newTransform
        }
    }

    private func labelRotationTransform(_ targetRotation: Int) -> CATransform3D {
        guard (targetRotation != 0) else { return CATransform3DIdentity }
        let newAngle = rotationValueToAngle(targetRotation, true)
        return CATransform3DMakeRotation(newAngle, 0, 0, 1)
    }

    private func rotationValueToAngle(_ rotationVal: Int, _ clockwise: Bool) -> CGFloat {
        return DegreesToRadians(CGFloat(rotationVal % 360), clockwise)
    }
}
