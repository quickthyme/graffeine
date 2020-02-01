import Foundation

public struct GraffeineData: Equatable {

    public struct HiLoPair<T: Equatable>: Equatable {
        public var hi: T
        public var lo: T
        public init(hi: T, lo: T) {
            self.hi = hi
            self.lo = lo
        }
    }

    public struct Selected: Equatable {
        public var index: Int?
        public var labels: [String?]

        public init(index: Int?, labels: [String?]) {
            self.index = index; self.labels = labels
        }

        public init() {
            self.init(index: nil, labels: [])
        }
    }

    public var valueMax: Double?
    public var valueMin: Double?
    public var values: HiLoPair<[Double?]>
    public var labels: [String?]
    public var selected: Selected

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

    public init() {
        self.valueMax = nil
        self.valueMin = nil
        self.values = HiLoPair<[Double?]>(hi: [], lo: [])
        self.labels = []
        self.selected = Selected()
    }

    public init(valueMax: Double?,
                valueMin: Double?,
                values: HiLoPair<[Double?]>,
                labels: [String?],
                selected: Selected) {

        self.valueMax = valueMax
        self.valueMin = valueMin
        self.values = values
        self.labels = labels
        self.selected = selected
    }

    public init(valueMax: Double? = nil,
                valueMin: Double? = nil,
                valuesHi: [Double?] = [],
                valuesLo: [Double?] = [],
                labels: [String?] = [],
                selectedLabels: [String?] = [],
                selectedIndex: Int? = nil) {

        self.valueMax = valueMax
        self.valueMin = valueMin
        self.values = HiLoPair<[Double?]>(hi: valuesHi, lo: valuesLo)
        self.labels = labels
        self.selected = Selected(index: selectedIndex,
                                 labels: selectedLabels)
    }

    public init(coordinates: [(x: Double, y: Double)],
                labels: [String?],
                selectedLabels: [String?],
                selectedIndex: Int?) {

        let sXY = GraffeineData.invertPairs(coordinates)

        self.init(valueMax: nil,
                  valuesHi: sXY.0,
                  valuesLo: sXY.1,
                  labels: labels,
                  selectedLabels: selectedLabels,
                  selectedIndex: selectedIndex)
    }

    public init(coordinates: [(x: Double, y: Double)],
                labels: [String?],
                selectedIndex: Int?) {

        self.init(coordinates: coordinates,
                  labels: labels,
                  selectedLabels: [],
                  selectedIndex: selectedIndex)
    }

    public init(coordinates: [(x: Double, y: Double)],
                selectedIndex: Int?) {

        self.init(coordinates: coordinates,
                  labels: [],
                  selectedIndex: selectedIndex)
    }

}
