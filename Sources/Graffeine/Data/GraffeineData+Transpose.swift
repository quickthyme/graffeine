import UIKit

public extension GraffeineData {

    internal init(transposed otherData: GraffeineData) {
        let otherLowest = min(otherData.lowestHi, otherData.lowestLo)
        let otherMax = otherData.transposedValueMax(otherLowest)
        let otherMin = otherData.transposedValueMin(otherLowest)
        let otherValues = otherData.transposedValues(otherLowest, otherMax, otherMin)
        self.valueMax = otherMax
        self.valueMin = otherMin
        self.values   = otherValues
        self.labels   = otherData.labels
        self.selected = otherData.selected
        self._transposeDelta = (otherLowest <= 0) ? 0 - otherLowest : 0
    }

    internal func transposedValueMax(_ lowest: Double? = nil) -> Double {
        let lowest = lowest ?? min(lowestHi, lowestLo)
        guard lowest < 0 else { return valueMax ?? highestHi }
        let oldMax = valueMax ?? highestHi
        let oldMin = valueMin ?? lowest
        return abs(oldMax - oldMin)
    }

    internal func transposedValueMin(_ lowest: Double? = nil) -> Double {
        return 0
    }

    internal func transposedValues(_ lowest: Double? = nil,
                                   _ maxVal: Double? = nil,
                                   _ minVal: Double? = nil) -> HiLoPair<[Double?]> {

        let lowest = lowest ?? min(lowestHi, lowestLo)
        guard lowest < 0 else { return values }

        let maxVal = maxVal ?? highestHi
        let minVal = minVal ?? lowest
        let absMinVal = abs(minVal)
        let offset: Double = (abs(maxVal - minVal) / 2) - absMinVal

        var newHiVals: [Double] = []
        var newLoVals: [Double] = []

        let hiCount = self.values.hi.count

        for i in 0..<hiCount {

            let oldHi = self.values.hi[i] ?? 0

            var newHi: Double
            var newLo: Double

            if (oldHi >= 0) {
                newHi = oldHi + absMinVal
                newLo = absMinVal
            } else {
                newHi = absMinVal
                newLo = absMinVal + oldHi
            }
            newHi += offset
            newLo += offset

            newHiVals.append(max(0, newHi))
            newLoVals.append(newLo)
        }

        return HiLoPair<[Double?]>(hi: newHiVals,
                                   lo: newLoVals)
    }
}
