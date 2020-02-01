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

        let newPathLine = constructLinePath(line: line,
                                            values: data.values.hi,
                                            maxValue: data.valueMaxOrHighestHi,
                                            containerSize: containerSize,
                                            smoothing: smoothing)

        let newPathFill = constructFillPath(fill: fill,
                                            valuesTop: data.values.hi,
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

    func constructLinePath(line: Line?,
                           values: [Double?],
                           maxValue: Double,
                           containerSize: CGSize,
                           smoothing: Smoothing) -> CGPath {
        guard
            let line = line,
            (!values.isEmpty)
            else { return CGPath(rect: .zero, transform: nil) }

        var path = UIBezierPath()

        draw(values: values,
             maxValue: maxValue,
             path: &path,
             unitColumn: line.unitColumn,
             containerSize: containerSize,
             startsWith: nil,
             drawThroughNil: false,
             reverse: false)

        return applySmoothingIfDesired(smoothing, to: path).cgPath
    }

    func constructFillPath(fill: Line?,
                           valuesTop: [Double?],
                           valuesBottom: [Double?],
                           maxValue: Double,
                           containerSize: CGSize,
                           smoothing: Smoothing) -> CGPath {
        guard
            let fill = fill,
            (!valuesTop.isEmpty)
            else { return CGPath(rect: .zero, transform: nil) }

//        let valuesTop: [Double] = valuesTop.map { $0 ?? 0 }

        let valuesBottom: [Double?] = (valuesBottom.isEmpty)
            ? valuesTop.map { _ in return 0 }
            : valuesBottom //.map { $0 ?? 0 }

        var path = UIBezierPath()

        draw(values: valuesTop,
             maxValue: maxValue,
             path: &path,
             unitColumn: fill.unitColumn,
             containerSize: containerSize,
             startsWith: nil,
             drawThroughNil: false,
             reverse: false)

        draw(values: valuesBottom,
             maxValue: maxValue,
             path: &path,
             unitColumn: fill.unitColumn,
             containerSize: containerSize,
             startsWith: valuesTop.last ?? 0,
             drawThroughNil: true,
             reverse: true)

        path.close()

        return applySmoothingIfDesired(smoothing, to: path).cgPath
    }

    func draw(values: [Double?],
              maxValue: Double,
              path: inout UIBezierPath,
              unitColumn: GraffeineLayer.UnitColumn,
              containerSize: CGSize,
              startsWith: Double?,
              drawThroughNil: Bool,
              reverse: Bool) {

        func drawNextSegment(index: Int,
                             value: Double?,
                             lastValue: Double?) -> Double? {

            guard let value = value else { return nil }

            let lastValueWasNil = (lastValue == nil)

            let valPercent: CGFloat = GraffeineData.getPercent(of: value, in: maxValue)

            let width = unitColumn.resolvedWidth(within: containerSize.width,
                                                 numberOfUnits: values.count)

            let yPos = containerSize.height - (containerSize.height * valPercent)

            let xPos = (CGFloat(index) * (width + unitColumn.margin))

            let point = CGPoint(x: xPos, y: yPos)

            if (lastValueWasNil && !drawThroughNil) {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            return value
        }

        var lastValue: Double? = startsWith
        if reverse {
            for (index, value) in values.enumerated().reversed() {
                lastValue = drawNextSegment(index: index, value: value, lastValue: lastValue)
            }
        } else {
            for (index, value) in values.enumerated() {
                lastValue = drawNextSegment(index: index, value: value, lastValue: lastValue)
            }
        }
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
