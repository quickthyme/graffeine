import UIKit

public struct GraffeineLineLayerColumnPositioner: GraffeineLineLayerPositioning {

    public typealias Line = GraffeineLineLayer.Line
    public typealias Smoothing = GraffeineLineLayer.Smoothing

    public func reposition(line: GraffeineLineLayer.Line,
                           data: GraffeineData,
                           containerSize: CGSize,
                           smoothing: GraffeineLineLayer.Smoothing,
                           animator: GraffeineLineDataAnimating?) {
        line.frame.size = containerSize

        let newPath = constructPath(line: line,
                                    data: data,
                                    containerSize: containerSize,
                                    smoothing: smoothing)

        if let animator = animator {
            let oldPath = line.presentation()?.path
                ?? line.path
                ?? newPath
            animator.animate(line: line, from: oldPath, to: newPath)
        } else {
            line.performWithoutAnimation {
                line.path = newPath
            }
        }
    }

    func constructPath(line: Line,
                       data: GraffeineData,
                       containerSize: CGSize,
                       smoothing: Smoothing) -> CGPath {
        guard (!data.values.isEmpty) else { return CGPath(rect: .zero, transform: nil) }

        let maxValue = data.valueMaxOrHighest

        let path = UIBezierPath()

        var lastValueWasNil: Bool = true

        for (index, value) in data.values.enumerated() {
            guard let value = value else {
                lastValueWasNil = true
                continue
            }

            let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: maxValue)

            let numberOfUnitsAdjustedForLineOffset = data.values.count - 1

            let width = line.unitColumn.width.resolved(within: containerSize.width,
                                                       numberOfUnits: numberOfUnitsAdjustedForLineOffset,
                                                       unitMargin: line.unitColumn.margin)

            let yPos = containerSize.height - (containerSize.height * valPercent)
            let xPos = (CGFloat(index) * (width + line.unitColumn.margin))
            let point = CGPoint(x: xPos, y: yPos)

            if (lastValueWasNil) {
                lastValueWasNil = false
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        return applySmoothingIfDesired(smoothing, to: path).cgPath
    }

    func applySmoothingIfDesired(_ smoothing: Smoothing, to path: UIBezierPath) -> UIBezierPath {
        switch (smoothing) {
        case .none:
            return path

        case let .catmullRom(granularity):
            return path.pathBySmoothing(method:
                LineSmoothingMethodCatmullRom(granularity: granularity))

        case let .custom(smoother):
            return smoother.pathBySmoothing(in: path)
        }
    }
}
