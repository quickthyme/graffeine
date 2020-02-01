import UIKit
import Graffeine

class SampleConfig: GraffeineViewConfig {

    enum ID: Hashable {
        case topGutter, rightGutter, bottomGutter, leftGutter, bgGrid, fgGrid
        case colorBars, descendingBars, rgbaBars, redLine, greenLine, vectorPlots, pie, pieLabels
    }

    static let colorValues: [UIColor] = [.black, .brown, .red, .orange, .yellow, .green,
                                         .blue, .brown, .lightGray, .darkGray, .black]

    static let colorNames: [String] = ["black1", "brown1", "red", "orange", "yellow", "green",
                                       "blue", "brown2", "lightGray", "darkGray", "black2"]

    required init(_ graffeineView: GraffeineView) {
        super.init(graffeineView)

        let unitMargin: CGFloat = 6.0

        graffeineView.layers = [

            GraffeineHorizontalLabelLayer(id: ID.topGutter, height: 16, region: .topGutter),

            GraffeineVerticalLabelLayer(id: ID.rightGutter, width: 16, region: .rightGutter),

            GraffeineHorizontalLabelLayer(id: ID.bottomGutter, height: 26, region: .bottomGutter)
                .apply ({
                    $0.unitText.colors = [.purple]
                    $0.labelAlignment.horizontal = .centerLeftRight
                    $0.data = GraffeineData(labels: ["low", "medium", "high"])
                }),

            GraffeineVerticalLabelLayer(id: ID.leftGutter, width: 64, region: .leftGutter)
                .apply ({
                    $0.rowMargin = unitMargin
                    $0.unitText.colors = Self.colorValues
                    $0.data = GraffeineData(labels: Self.colorNames)
                }),

            GraffeineGridLineLayer(id: ID.bgGrid)
                .apply ({
                    $0.unitLine.colors = [.lightGray]
                    $0.unitLine.dashPattern = [1, 3]
                    $0.unitLine.thickness = 0.5
                    $0.data = GraffeineData(valueMax: 20, valuesHi: [2, 4, 6, 8, 12, 14, 16, 18])
                }),

            GraffeineBarLayer(id: ID.colorBars)
                .apply ({
                    $0.flipXY = true
                    $0.unitColumn.margin = unitMargin
                }),

            GraffeineBarLayer(id: ID.descendingBars)
                .apply ({
                    $0.unitColumn.margin = unitMargin
                    $0.unitFill.colors = [.purple]
                }),

            GraffeineLineLayer(id: ID.redLine)
                .apply ({
                    $0.unitLine.colors = [.red]
                    $0.unitColumn.margin = unitMargin
                    $0.unitLine.thickness = 4.0
                    $0.unitLine.join = .miter
                }),

            GraffeineLineLayer(id: ID.greenLine)
                .apply ({
                    $0.unitLine.colors = [.green]
                    $0.unitColumn.margin = unitMargin
                    $0.unitLine.thickness = 10.0
                    $0.unitLine.join = .round
                }),

            GraffeinePlotLayer(id: ID.vectorPlots)
                .apply ({
                    $0.unitFill.colors = [.black]
                    $0.unitColumn.margin = unitMargin
                    $0.diameter = .explicit(8.0)
                    $0.unitLine.thickness = 2.0
                    $0.unitLine.colors = [.brown]
                }),

            GraffeineRadialSegmentLayer(id: ID.pie)
                .apply ({
                    $0.unitFill.colors = [.darkGray, .lightGray]
                }),

            GraffeineRadialLabelLayer(id: ID.pieLabels)
                .apply ({
                    $0.unitText.colors = [.lightGray]
                }),

            GraffeineGridLineLayer(id: ID.fgGrid)
                .apply ({
                    $0.unitLine.colors = [.darkGray]
                    $0.unitLine.thickness = 1.0
                    $0.data = GraffeineData(valueMax: 20, valuesHi: [0, 10, 20])
                })
        ]
    }
}
