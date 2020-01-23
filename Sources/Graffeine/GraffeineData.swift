import Foundation

public struct GraffeineData: Equatable {
    public var valueMax: Double?
    public var valuesHi: [Double?]
    public var valuesLo: [Double?]
    public var labels: [String?]

    public var selectedIndex: Int?

    public var values: [Double?] {
        get { return valuesHi }
        set { valuesHi = newValue }
    }

    public init() {
        valueMax = nil
        valuesHi = []
        valuesLo = []
        labels = []
        selectedIndex = nil
    }

    public init(valueMax: Double?,
                valuesHi: [Double?],
                valuesLo: [Double?],
                labels: [String?],
                selectedIndex: Int?) {
        self.valueMax = valueMax
        self.valuesHi = valuesHi
        self.valuesLo = valuesLo
        self.labels = labels
        self.selectedIndex = selectedIndex
    }

    public init(valueMax: Double?,
                valuesHi: [Double?],
                valuesLo: [Double?]) {
        self.valueMax = valueMax
        self.valuesHi = valuesHi
        self.valuesLo = valuesLo
        self.labels = []
        self.selectedIndex = nil
    }

    public init(valueMax: Double?,
                values: [Double?],
                labels: [String?],
                selectedIndex: Int?) {
        self.init(valueMax: valueMax,
                  valuesHi: values,
                  valuesLo: [],
                  labels: labels,
                  selectedIndex: selectedIndex)
    }

    public init(valueMax: Double?,
                values: [Double?],
                labels: [String?]) {
        self.init(valueMax: valueMax,
                  valuesHi: values,
                  valuesLo: [],
                  labels: labels,
                  selectedIndex: nil)
    }

    public init(valueMax: Double?,
                values: [Double?],
                selectedIndex: Int?) {
        self.init(valueMax: valueMax,
                  valuesHi: values,
                  valuesLo: [],
                  labels: [],
                  selectedIndex: selectedIndex)
    }

    public init(valueMax: Double?,
                values: [Double?]) {
        self.init(valueMax: valueMax,
                  values: values,
                  labels: [],
                  selectedIndex: nil)
    }

    public init(values: [Double?]) {
        self.init(valueMax: nil,
                  values: values)
    }

    public init(values: [Double?],
                selectedIndex: Int?) {
        self.init(valueMax: nil,
                  values: values,
                  selectedIndex: selectedIndex)
    }

    public init(values: [Double?],
                labels: [String?]) {
        self.init(valueMax: nil,
                  values: values,
                  labels: labels)
    }

    public init(labels: [String?]) {
        self.init()
        self.labels = labels
    }

    public var highest: Double {
        return valuesHi.map({ $0 ?? 0 }).max() ?? 0
    }

    public var sum: Double {
        return sumHi
    }

    public var sumHi: Double {
        return valuesHi.reduce(Double(0)) { $0 + ($1 ?? 0) }
    }

    public var sumLo: Double {
        return valuesLo.reduce(Double(0)) { $0 + ($1 ?? 0) }
    }

    public var valueMaxOrSum: Double {
        return valueMax ?? sum
    }

    public var valueMaxOrHighest: Double {
        return valueMax ?? highest
    }

    public func loValueOrZero(_ idx: Int) -> Double {
        return ((!valuesLo.isEmpty) && idx >= 0 && idx < valuesLo.count)
            ? valuesLo[idx] ?? 0.0
            : 0.0
    }

    public func labelValue(_ index: Int) -> String {
        return (index < labels.count) ? (labels[index] ?? "") : ("")
    }
}
