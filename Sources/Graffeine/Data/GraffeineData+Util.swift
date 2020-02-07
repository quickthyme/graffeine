import UIKit

public extension GraffeineData {

    static func getPercent(of value: Double, in maxValue: Double) -> CGFloat {
        return (0 != maxValue) ? CGFloat(value / maxValue) : 0
    }

    static func convertHiLo(_ a: Double, _ b: Double) -> (hi: Double, lo: Double) {
        return (
            hi: max(a, b),
            lo: min(a, b)
        )
    }

    static func invertPairs(_ arrays: ([Double], [Double])) -> [(Double, Double)] {
        guard !(arrays.0.isEmpty), (arrays.0.count == arrays.1.count) else { return [] }
        return arrays.0.enumerated().map { ($0.element, arrays.1[$0.offset]) }
    }

    static func invertPairs(_ pairs: [(Double, Double)]) -> ([Double], [Double]) {
        let a0: [Double] = pairs.map { $0.0 }
        let a1: [Double] = pairs.map { $0.1 }
        return (a0, a1)
    }
}
