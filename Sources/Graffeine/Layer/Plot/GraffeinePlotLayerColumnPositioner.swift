import UIKit

public struct GraffeinePlotLayerColumnPositioner: GraffeinePlotLayerPositioning {

    public func reposition(plot: GraffeinePlotLayer.Plot,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize,
                           animator: GraffeinePlotDataAnimating?) {

        guard let value = data.values.hi[index] else {
            plot.performWithoutAnimation {
                plot.opacity = 0.0
            }
            return
        }

        let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: data.valueMaxOrHighestHi)

        let width = plot.unitColumn.resolvedWidth(within: containerSize.width,
                                                  numberOfUnits: data.values.hi.count)

        let newPosition = CGPoint(
            x: plot.unitColumn.resolvedOffset(index: index, actualWidth: width),
            y: containerSize.height - (containerSize.height * valPercent)
        )

        let newPath = plot.constructPath(at: newPosition)

        if let animator = animator {
            animator.animate(plot: plot,
                             fromPath: plot.path ?? newPath,
                             toPath: newPath)
        } else {
            plot.performWithoutAnimation {
                plot.path = newPath
                plot.opacity = 1.0
            }
        }
    }
}
