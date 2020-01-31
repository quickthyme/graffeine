import UIKit

public struct GraffeinePlotLayerColumnPositioner: GraffeinePlotLayerPositioning {

    public func reposition(plot: GraffeinePlotLayer.Plot,
                           for index: Int,
                           in data: GraffeineData,
                           containerSize: CGSize,
                           animator: GraffeinePlotDataAnimating?) {

        guard let value = data.values[index] else {
            plot.performWithoutAnimation {
                plot.opacity = 0.0
                plot.position = .zero
            }
            return
        }

        let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: data.valueMaxOrHighest)

        let numberOfUnitsAdjustedForPlotOffset = data.values.count - 1

        let width = plot.unitColumn.resolvedWidth(within: containerSize.width,
                                                  numberOfUnits: numberOfUnitsAdjustedForPlotOffset)

        let newPosition = CGPoint(
            x: plot.unitColumn.resolvedOffset(index: index, actualWidth: width),
            y: containerSize.height - (containerSize.height * valPercent)
        )

        let newRadius = (plot.diameter / 2)

        let newPath = UIBezierPath(arcCenter: newPosition,
                                   radius: newRadius,
                                   startAngle: 0,
                                   endAngle: DegreesToRadians(360),
                                   clockwise: true).cgPath

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
