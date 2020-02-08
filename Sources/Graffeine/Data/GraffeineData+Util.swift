import UIKit

extension GraffeineData {

    public var highestHi: Double {
        return values.hi.map({ $0 ?? 0 }).max() ?? 0
    }

    public var highestLo: Double {
        return values.lo.map({ $0 ?? 0 }).max() ?? 0
    }

    public var lowestHi: Double {
        return values.hi.map({ $0 ?? 0 }).min() ?? 0
    }

    public var lowestLo: Double {
        return values.lo.map({ $0 ?? 0 }).min() ?? 0
    }

    public var sumHi: Double {
        return values.hi.reduce(Double(0)) { $0 + ($1 ?? 0) }
    }

    public var sumLo: Double {
        return values.lo.reduce(Double(0)) { $0 + ($1 ?? 0) }
    }

    public var valueMaxOrSumHi: Double {
        return valueMax ?? sumHi
    }

    public var valueMaxOrSumLo: Double {
        return valueMax ?? sumLo
    }

    public var valueMaxOrHighestHi: Double {
        return valueMax ?? highestHi
    }

    public func loValueOrZero(_ idx: Int) -> Double {
        return (0..<values.lo.count ~= idx)
            ? values.lo[idx] ?? 0.0
            : 0.0
    }

    public func preferredLabelValue(_ index: Int) -> String {
        return (index == (selected.index ?? Int.max))
            ? selectedLabelValue(self.selected.index!)
            : labelValue(index)
    }

    public func labelValue(_ index: Int) -> String {
        return (0..<labels.count ~= index)
            ? labels[index] ?? ""
            : ""
    }

    public func selectedLabelValue(_ index: Int) -> String {
        return (0..<selected.labels.count ~= index)
            ? selected.labels[index] ?? ""
            : labelValue(index)
    }

    public static func getPercent(of value: Double, in maxValue: Double) -> CGFloat {
        return (0 != maxValue) ? CGFloat(value / maxValue) : 0
    }

    public static func convertHiLo(_ a: Double, _ b: Double) -> (hi: Double, lo: Double) {
        return (
            hi: max(a, b),
            lo: min(a, b)
        )
    }

    public static func invertPairs(_ arrays: ([Double], [Double])) -> [(Double, Double)] {
        guard !(arrays.0.isEmpty), (arrays.0.count == arrays.1.count) else { return [] }
        return arrays.0.enumerated().map { ($0.element, arrays.1[$0.offset]) }
    }

    public static func invertPairs(_ pairs: [(Double, Double)]) -> ([Double], [Double]) {
        let a0: [Double] = pairs.map { $0.0 }
        let a1: [Double] = pairs.map { $0.1 }
        return (a0, a1)
    }
}
