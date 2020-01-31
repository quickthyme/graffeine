import UIKit

public struct GraffeinePlotLabelLayerColumnPositioner: GraffeinePlotLabelLayerPositioning {

    public func reposition(label: GraffeinePlotLabelLayer.Label,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize,
                           animator: GraffeinePlotLabelDataAnimating?) {

        guard (0..<data.labels.count ~= index),
            let value = data.values[index] else {
                label.performWithoutAnimation {
                    label.opacity = 0.0
                    label.string = ""
                }
                return
        }

        let labelValue = data.preferredLabelValue(index)

        let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: data.valueMaxOrHighest)

        let numberOfUnitsAdjustedForPlotOffset = data.values.count - 1

        let width = label.unitColumn.resolvedWidth(within: containerSize.width,
                                                   numberOfUnits: numberOfUnitsAdjustedForPlotOffset)

        let newPosition = CGPoint(
            x: label.unitColumn.resolvedOffset(index: index, actualWidth: width),
            y: containerSize.height - (containerSize.height * valPercent)
        )

        if let animator = animator {
            animator.animate(label: label, toValue: labelValue, toPosition: newPosition)
        } else {
            label.performWithoutAnimation {
                label.string = labelValue
                label.frame.size = label.preferredFrameSize()
                label.position = newPosition
                label.opacity = 1.0
            }
        }
    }
}
