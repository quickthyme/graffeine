import UIKit

public struct GraffeineHorizontalLabelLayerColumnPositioner: GraffeineHorizontalLabelLayerPositioning {

    public func reposition(label: GraffeineHorizontalLabelLayer.Label,
                           for index: Int,
                           in labels: [String?],
                           containerSize: CGSize) {

        let labelsCount = labels.count
        let labelValue = (index < labelsCount) ? (labels[index] ?? "") : ""

        let width = label.unitColumn.resolvedWidth(within: containerSize.width,
                                                   numberOfUnits: labels.count)
        let xPos = label.unitColumn.resolvedOffset(index: index, actualWidth: width)

        let newFrame = CGRect(x: xPos, y: 0, width: width, height: containerSize.height)

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
