import UIKit
import Graffeine

class SampleData {

    func applyDescendingBars(to graffeineView: GraffeineView) {
        if let layer = graffeineView.layer(id: SampleConfig.ID.descendingBars) {
            layer.data = GraffeineData(valueMax: 20,
                                             values: [10, 9, 8, 7, 6, 5, 4, nil, 2, 1, 0])
        }
    }

    func applyColorBars(to graffeineView: GraffeineView) {
        if let layer = graffeineView.layer(id: SampleConfig.ID.colorBars) {
            layer.data = GraffeineData(valueMax: 20,
                                             valuesHi: [10.5, 11, 12, 13, 14, 15, 16, nil, 18, 19, 20],
                                             valuesLo: [9.5, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0])
            layer.colors = SampleConfig.colorValues
        }
    }

    func applyGreenLine(to graffeineView: GraffeineView) {
        if let layer = graffeineView.layer(id: SampleConfig.ID.greenLine) {
            layer.data = GraffeineData(valueMax: 20,
                                             values: [0, 2, 1, 3, 1, 4, 2.5, 6, 9, 7, 13])
        }
    }

    func applyRedLine(to graffeineView: GraffeineView) {
        if let layer = graffeineView.layer(id: SampleConfig.ID.redLine) {
            layer.data = GraffeineData(valueMax: 20,
                                             values: [15, 16, 12, 14, 15, nil, 0, 7, 6, 8, 7])
        }
    }

    func applyVectorPlots(to graffeineView: GraffeineView) {
        if let layer = graffeineView.layer(id: SampleConfig.ID.vectorPlots) {
            layer.data = GraffeineData(valueMax: 20, values: [0, 1, 3, 4, 10, 15, 20])
        }
    }

    func applyPieSlices(to graffeineView: GraffeineView) {
        if let layer = graffeineView.layer(id: SampleConfig.ID.pie) {
            layer.data = GraffeineData(valueMax: 200, values: [20, 30, 50])
        }
    }
}
