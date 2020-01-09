import UIKit
import Graffeine

class SampleConfig: GraffeineViewConfig {

    enum ID: Hashable {
        case topGutter, rightGutter, bottomGutter, leftGutter
        case bgGrid, fgGrid, colorBars, descendingBars, rgbaBars, redLine, greenLine
    }

    static let colorValues: [UIColor] = [.black, .brown, .red, .orange, .yellow, .green,
                                         .blue, .brown, .lightGray, .darkGray, .black]

    static let colorNames: [String] = ["black1", "brown1", "red", "orange", "yellow", "green",
                                       "blue", "brown2", "lightGray", "darkGray", "black2"]

    required init(_ graffeineView: GraffeineView) {
        super.init(graffeineView)

        let unitMargin: CGFloat = 6.0

        graffeineView.layers = [

            GraffeineHorizontalGutter(id: ID.topGutter, height: 16, region: .topGutter),

            GraffeineVerticalGutter(id: ID.rightGutter, width: 16, region: .rightGutter),

            GraffeineHorizontalGutter(id: ID.bottomGutter, height: 26, region: .bottomGutter)
                .apply ({
                    $0.colors = [.purple]
                    $0.labelAlignmentMode = .centerLeftRight
                    $0.data = GraffeineLayer.Data(labels: ["low", "medium", "high"])
                }),

            GraffeineVerticalGutter(id: ID.leftGutter, width: 64, region: .leftGutter)
                .apply ({
                    $0.rowMargin = unitMargin
                    $0.colors = Self.colorValues
                    $0.data = GraffeineLayer.Data(labels: Self.colorNames)
                }),

            GraffeineGridLineLayer(id: ID.bgGrid)
                .apply ({
                    $0.colors = [.lightGray]
                    $0.dashPattern = [1, 3]
                    $0.thickness = 0.5
                    $0.data = GraffeineLayer.Data(valueMax: 20, values: [2, 4, 6, 8, 12, 14, 16, 18])
                }),

            GraffeineBarLayer(id: ID.colorBars)
                .apply ({
                    $0.flipXY = true
                    $0.barMargin = unitMargin
                }),

            GraffeineBarLayer(id: ID.descendingBars)
                .apply ({
                    $0.barMargin = unitMargin
                    $0.colors = [.purple]
                }),

            GraffeineLineLayer(id: ID.redLine)
                .apply ({
                    $0.colors = [.red]
                    $0.unitMargin = unitMargin
                    $0.thickness = 4.0
                    $0.lineJoin = .miter
                }),

            GraffeineLineLayer(id: ID.greenLine)
                .apply ({
                    $0.colors = [.green]
                    $0.unitMargin = unitMargin
                    $0.thickness = 10.0
                    $0.lineJoin = .round
                }),

            GraffeineGridLineLayer(id: ID.fgGrid)
                .apply ({
                    $0.colors = [.darkGray]
                    $0.thickness = 1.0
                    $0.data = GraffeineLayer.Data(valueMax: 20, values: [0, 10, 20])
                })
        ]
    }
}
