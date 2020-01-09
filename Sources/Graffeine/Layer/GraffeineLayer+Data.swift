extension GraffeineLayer {

    public struct Data: Equatable {
        public var valueMax: Double
        public var valuesHi: [Double?]
        public var valuesLo: [Double?]
        public var labels: [String?]

        public var values: [Double?] {
            get { return valuesHi }
            set { valuesHi = newValue }
        }

        public init() {
            valueMax = 100.0
            valuesHi = []
            valuesLo = []
            labels = []
        }

        public init(labels: [String?]) {
            self.init()
            self.labels = labels
        }

        public init(valueMax: Double,
                    valuesHi: [Double?],
                    valuesLo: [Double?] = [],
                    labels: [String?] = []) {
            self.valueMax = valueMax
            self.valuesHi = valuesHi
            self.valuesLo = valuesLo
            self.labels = labels
        }

        public init(valueMax: Double, values: [Double?]) {
            self.init(valueMax: valueMax, valuesHi: values)
        }

        public func loValueOrZero(_ idx: Int) -> Double {
            return ((!valuesLo.isEmpty) && idx >= 0 && idx < valuesLo.count)
                ? valuesLo[idx] ?? 0.0
                : 0.0
        }
    }
}
