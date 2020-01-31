import Foundation

extension GraffeineData {

    public init(valueMax: Double?,
                valuesHi: [Double?],
                valuesLo: [Double?],
                labels: [String?],
                selectedIndex: Int?) {

        self.init(valueMax: valueMax,
                  valuesHi: valuesHi,
                  valuesLo: valuesLo,
                  labels: labels,
                  selectedLabels: [],
                  selectedIndex: selectedIndex)
    }

    public init(valueMax: Double?,
                valuesHi: [Double?],
                valuesLo: [Double?],
                selectedIndex: Int?) {

        self.init(valueMax: valueMax,
                  valuesHi: valuesHi,
                  valuesLo: valuesLo,
                  labels: [],
                  selectedIndex: selectedIndex)
    }

    public init(valueMax: Double?,
                valuesHi: [Double?],
                valuesLo: [Double?]) {

        self.init(valueMax: valueMax,
                  valuesHi: valuesHi,
                  valuesLo: valuesLo,
                  labels: [],
                  selectedIndex: nil)
    }

    public init(valueMax: Double?,
                values: [Double?],
                labels: [String?],
                selectedLabels: [String?],
                selectedIndex: Int?) {

        self.init(valueMax: valueMax,
                  valuesHi: values,
                  valuesLo: [],
                  labels: labels,
                  selectedLabels: selectedLabels,
                  selectedIndex: selectedIndex)
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

    public init(values: [Double?],
                labels: [String?],
                selectedIndex: Int?) {

        self.init(valueMax: nil,
                  values: values,
                  labels: labels,
                  selectedIndex: selectedIndex)
    }

    public init(values: [Double?],
                labels: [String?],
                selectedLabels: [String?],
                selectedIndex: Int?) {

        self.init(valueMax: nil,
                  valuesHi: values,
                  valuesLo: [],
                  labels: labels,
                  selectedLabels: selectedLabels,
                  selectedIndex: selectedIndex)
    }

    public init(labels: [String?]) {
        self.init()
        self.labels = labels
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
                  selectedLabels: [],
                  selectedIndex: selectedIndex)
    }

    public init(coordinates: [(x: Double, y: Double)],
                selectedIndex: Int?) {

        let sXY = GraffeineData.invertPairs(coordinates)

        self.init(valueMax: nil,
                  valuesHi: sXY.0,
                  valuesLo: sXY.1,
                  labels: [],
                  selectedLabels: [],
                  selectedIndex: selectedIndex)
    }
}
