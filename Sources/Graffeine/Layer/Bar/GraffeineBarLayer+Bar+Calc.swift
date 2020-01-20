import UIKit

extension GraffeineBarLayer.Bar {

    public typealias DrawingInfo = (origin: CGPoint, size: CGSize) //, anchorPoint: CGPoint)

    internal struct Calc {
        private init() {}
        typealias Percentages = (hi: CGFloat, lo: CGFloat, loPositionMultiplier: CGFloat)
        typealias Horizontal  = (x: CGFloat, width: CGFloat)
        typealias Vertical    = (y: CGFloat, height: CGFloat)

        static func drawingInfo(valueHi: Double,
                                valueLo: Double,
                                maxValue: Double,
                                unitIndex: Int,
                                numberOfUnits: Int,
                                unitWidth: GraffeineLayer.DimensionalUnit,
                                unitMargin: CGFloat,
                                subdivision: GraffeineLayer.UnitSubdivision?,
                                containerSize: CGSize,
                                flipXY: Bool) -> DrawingInfo {


            let pcnt = percentages(maxVal: maxValue,
                                   valHi: valueHi,
                                   valLo: valueLo,
                                   flipXY: flipXY)

            let horz = horizontal(index: unitIndex,
                                  numberOfUnits: numberOfUnits,
                                  unitWidth: unitWidth,
                                  unitMargin: unitMargin,
                                  subdivision: subdivision,
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

        static func percentages(maxVal: Double,
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

        static func horizontal(index: Int,
                               numberOfUnits: Int,
                               unitWidth: GraffeineLayer.DimensionalUnit,
                               unitMargin: CGFloat,
                               subdivision: GraffeineLayer.UnitSubdivision?,
                               containerSize: CGSize,
                               flipXY: Bool) -> Horizontal {

            let translatedContainerSize = translatedSize(containerSize, flipXY)

            var width = unitWidth.resolved(within: translatedContainerSize.width,
                                           numberOfUnits: numberOfUnits,
                                           unitMargin: unitMargin)
            var xPos = (CGFloat(index) * (width + unitMargin))

            if let subdivision = subdivision {
                width = subdivision.width.resolved(within: width)
                xPos += (CGFloat(subdivision.index) * width)
            }

            return (x: xPos, width: width)
        }

        static func vertical(hiPercent: CGFloat,
                             loPercent: CGFloat,
                             loPercentPositionMultiplier: CGFloat,
                             containerSize: CGSize,
                             flipXY: Bool) -> Vertical {

            let translatedContainerSize = translatedSize(containerSize, flipXY)
            let translatedHeight = translatedContainerSize.height * (hiPercent - loPercent)
            let y = (flipXY)
                ? translatedContainerSize.height * loPercentPositionMultiplier
                : translatedContainerSize.height - translatedHeight

            return (y: y, height: translatedHeight)
        }

        static func translatedSize(_ size: CGSize, _ flipXY: Bool) -> CGSize {
            return (flipXY)
                ? CGSize(width: size.height, height: size.width)
                : size
        }

        static func translatedOrigin(_ point: CGPoint, _ flipXY: Bool) -> CGPoint {
            return (flipXY)
                ? CGPoint(x: point.y, y: point.x)
                : point
        }
    }
}
