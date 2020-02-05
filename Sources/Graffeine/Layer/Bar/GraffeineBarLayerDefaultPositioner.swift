import UIKit

public struct GraffeineBarLayerDefaultPositioner: GraffeineBarLayerPositioning {

    public func reposition(bar: GraffeineBarLayer.Bar,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize,
                           animator: GraffeineBarDataAnimating?) {

        let drawingInfo = bar.unitColumn.drawingInfo(valueHi: data.values.hi[index] ?? 0,
                                                     valueLo: data.loValueOrZero(index),
                                                     maxValue: data.valueMaxOrHighestHi,
                                                     unitIndex: index,
                                                     numberOfUnits: data.values.hi.count,
                                                     containerSize: containerSize,
                                                     flipXY: bar.flipXY)

        let oldBarFrame: CGRect = bar.path?.boundingBoxOfPath ?? .zero
        let oldOrigin = oldBarFrame.origin
        let oldSize = oldBarFrame.size

        let newOrigin = drawingInfo.origin
        let newSize = drawingInfo.size

        if let animator = animator {
            animator.animate(bar: bar,
                             fromOrigin: oldOrigin,
                             toOrigin: newOrigin,
                             fromSize: oldSize,
                             toSize: newSize)
        } else {
            bar.performWithoutAnimation {
                bar.path = bar.constructPath(origin: newOrigin, size: newSize)
            }
        }
    }
}
