import UIKit

extension GraffeineLayer {

    public struct UnitColumn {

        public typealias DrawingInfo = (origin: CGPoint, size: CGSize)
        public typealias Percentages = (hi: CGFloat, lo: CGFloat, loPositionMultiplier: CGFloat)
        public typealias Horizontal  = (x: CGFloat, width: CGFloat)
        public typealias Vertical    = (y: CGFloat, height: CGFloat)

        public var width: DimensionalUnit = .relative
        public var subdivision: UnitSubdivision = UnitSubdivision()
        public var margin: CGFloat = 0.0

        public init() {}

        public init(width: DimensionalUnit, subdivision: UnitSubdivision, margin: CGFloat) {
            self.width = width
            self.subdivision = subdivision
            self.margin = margin
        }

        public func resolvedWidth(within boundary: CGFloat, numberOfUnits: Int = 1) -> CGFloat {
            return width.resolved(within: boundary,
                                  numberOfUnits: numberOfUnits,
                                  unitMargin: margin)
        }

        public func resolvedOffset(index: Int, actualWidth: CGFloat) -> CGFloat {
            return (CGFloat(index) * (actualWidth + margin))
        }

        public func drawingInfo(valueHi: Double,
                                valueLo: Double,
                                maxValue: Double,
                                unitIndex: Int,
                                numberOfUnits: Int,
                                containerSize: CGSize,
                                flipXY: Bool) -> DrawingInfo {

            let pcnt = percentages(maxVal: maxValue,
                                   valHi: valueHi,
                                   valLo: valueLo,
                                   flipXY: flipXY)

            let horz = horizontal(index: unitIndex,
                                  numberOfUnits: numberOfUnits,
                                  containerSize: containerSize,
                                  flipXY: flipXY)

            let vert = vertical(hiPercent: pcnt.hi,
                                loPercent: pcnt.lo,
                                loPercentPositionMultiplier: pcnt.loPositionMultiplier,
                                containerSize: containerSize,
                                flipXY: flipXY)

            return (
                origin: translatedOrigin(CGPoint(x: horz.x, y: vert.y), flipXY),
                size: translatedSize(CGSize(width: horz.width, height: vert.height), flipXY)
            )
        }

        public func percentages(maxVal: Double,
                                valHi: Double,
                                valLo: Double,
                                flipXY: Bool) -> Percentages {
            let shouldConsiderLo = (0...valHi ~= valLo)
            let hiPercent: CGFloat = (valHi <= maxVal) ? CGFloat(valHi / maxVal) : 1.0
            let loPercent: CGFloat = (shouldConsiderLo) ? CGFloat(valLo / maxVal) : 0.0
            let loPercentInverted: CGFloat = (shouldConsiderLo) ? ((1.0 - loPercent)) : 1.0
            let loPositionMultiplier = (flipXY) ? loPercent : loPercentInverted
            return (hi: hiPercent, lo: loPercent, loPositionMultiplier: loPositionMultiplier)
        }

        public func horizontal(index: Int,
                               numberOfUnits: Int,
                               containerSize: CGSize,
                               flipXY: Bool) -> Horizontal {
            let translatedContainerSize = translatedSize(containerSize, flipXY)
            let actualWidth = width.resolved(within: translatedContainerSize.width,
                                             numberOfUnits: numberOfUnits,
                                             unitMargin: margin)
            let offset = (CGFloat(index) * (actualWidth + margin))
            let subdiv = subdivision.resolved(in: actualWidth)
            return (x: offset + subdiv.offset,
                    width: subdiv.width)
        }

        public func vertical(hiPercent: CGFloat,
                             loPercent: CGFloat,
                             loPercentPositionMultiplier: CGFloat,
                             containerSize: CGSize,
                             flipXY: Bool) -> Vertical {
            let translatedContainerSize = translatedSize(containerSize, flipXY)
            let translatedHeight = translatedContainerSize.height * (hiPercent - loPercent)
            let y = (flipXY)
                ? translatedContainerSize.height * loPercentPositionMultiplier
                : (translatedContainerSize.height * loPercentPositionMultiplier) - translatedHeight

            return (y: y, height: translatedHeight)
        }

        internal func translatedSize(_ size: CGSize, _ flipXY: Bool) -> CGSize {
            return (flipXY)
                ? CGSize(width: size.height, height: size.width)
                : size
        }

        internal func translatedOrigin(_ point: CGPoint, _ flipXY: Bool) -> CGPoint {
            return (flipXY)
                ? CGPoint(x: point.y, y: point.x)
                : point
        }
    }
}
