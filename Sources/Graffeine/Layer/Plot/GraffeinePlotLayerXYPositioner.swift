import UIKit

public struct GraffeinePlotLayerXYPositioner: GraffeinePlotLayerPositioning {

    typealias DimensionalUnit = GraffeineLayer.DimensionalUnit

    public func reposition(plot: GraffeinePlotLayer.Plot,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize,
                           animator: GraffeinePlotDataAnimating?) {
        guard
            let X = data.values.hi[index],
            let Y = data.values.lo[index] else {
                plot.performWithoutAnimation {
                    plot.opacity = 0.0
                }
                return
        }

        let Xmax: Double = data.values.hi.compactMap({ $0 }).max() ?? 1
        let Ymax: Double = data.values.lo.compactMap({ $0 }).max() ?? 1

        let pctX: CGFloat = GraffeineData.getPercent(of: X, in: Xmax)
        let pctY: CGFloat = GraffeineData.getPercent(of: Y, in: Ymax)

        let newPosition = CGPoint(
            x: DimensionalUnit.percentage(pctX).resolved(within: containerSize.width),
            y: DimensionalUnit.percentage(pctY).resolved(within: containerSize.height)
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
