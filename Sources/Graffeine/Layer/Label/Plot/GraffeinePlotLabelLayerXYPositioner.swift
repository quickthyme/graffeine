import UIKit

public struct GraffeinePlotLabelLayerXYPositioner: GraffeinePlotLabelLayerPositioning {

    typealias DimensionalUnit = GraffeineLayer.DimensionalUnit

    public func reposition(label: GraffeinePlotLabelLayer.Label,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize,
                           animator: GraffeinePlotLabelDataAnimating?) {

        guard
            (0..<data.labels.count ~= index),
            let X = data.values.hi[index],
            let Y = data.values.lo[index] else {
                label.performWithoutAnimation {
                    label.opacity = 0.0
                    label.string = ""
                }
                return
        }

        let labelValue = data.preferredLabelValue(index)

        let Xmax: Double = data.values.hi.compactMap({ $0 }).max() ?? 1
        let Ymax: Double = data.values.lo.compactMap({ $0 }).max() ?? 1

        let pctX: CGFloat = GraffeineData.getPercent(of: X, in: Xmax)
        let pctY: CGFloat = GraffeineData.getPercent(of: Y, in: Ymax)

        let newPosition = CGPoint(
            x: DimensionalUnit.percentage(pctX).resolved(within: containerSize.width),
            y: DimensionalUnit.percentage(pctY).resolved(within: containerSize.height)
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
