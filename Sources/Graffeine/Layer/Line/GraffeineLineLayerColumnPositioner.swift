import UIKit

public struct GraffeineLineLayerColumnPositioner: GraffeineLineLayerPositioning {

    public typealias Line = GraffeineLineLayer.Line
    public typealias Smoothing = GraffeineLineLayer.Smoothing

    public func reposition(line: Line,
                           fill: Line,
                           data: GraffeineData,
                           containerSize: CGSize,
                           smoothing: GraffeineLineLayer.Smoothing,
                           animator: GraffeineLineDataAnimating?) {

        line.frame.size = containerSize

        fill.frame.size = containerSize

        let newPathLine = line.constructLinePath(values: data.values.hi,
                                                 maxValue: data.valueMaxOrHighestHi,
                                                 containerSize: containerSize,
                                                 smoothing: smoothing)

        let newPathFill = fill.constructFillPath(valuesTop: data.values.hi,
                                                 valuesBottom: data.values.lo,
                                                 maxValue: data.valueMaxOrHighestHi,
                                                 containerSize: containerSize,
                                                 smoothing: smoothing)

        if let animator = animator {
            let oldPathLine = line.presentation()?.path ?? line.path ?? newPathLine
            let oldPathFill = fill.presentation()?.path ?? fill.path ?? newPathFill
            animator.animate(line: line, from: oldPathLine, to: newPathLine)
            animator.animate(line: fill, from: oldPathFill, to: newPathFill)
        } else {
            line.performWithoutAnimation {
                line.path = newPathLine
            }
            fill.performWithoutAnimation {
                fill.path = newPathFill
            }
        }
    }
}
