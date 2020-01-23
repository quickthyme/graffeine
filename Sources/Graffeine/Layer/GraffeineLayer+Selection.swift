import UIKit

extension GraffeineLayer {

    public struct SelectionResult {
        public let point: CGPoint
        public let data: GraffeineData
        public let layer: GraffeineLayer
        public init(point: CGPoint, data: GraffeineData, layer: GraffeineLayer) {
            self.point = point; self.data = data; self.layer = layer
        }
    }

    public struct Selection {
        public var isEnabled: Bool = false
        public var fill:   Fill   = Fill()
        public var line:   Line   = Line()
        public var text:   Text   = Text()
        public var radial: Radial = Radial()

        public struct Fill {
            public var color: UIColor? = nil
        }

        public struct Line {
            public var color: UIColor? = nil
            public var thickness: CGFloat? = nil
        }

        public struct Text {
            public var color: UIColor? = nil
        }

        public struct Radial {
            public var diameter: DimensionalUnit? = nil
            public var holeDiameter: DimensionalUnit? = nil
        }
    }

    open func applySelectionState(_ layer: CALayer, index: Int) {
        guard (data.selectedIndex == index) else { return }

        if let shape = layer as? CAShapeLayer {
            if let color = selection.fill.color { shape.fillColor = color.cgColor }
            if let color = selection.line.color { shape.strokeColor = color.cgColor }
            if let thickness = selection.line.thickness { shape.lineWidth = thickness }
        }

        if let text = layer as? CATextLayer {
            if let color = selection.fill.color { text.backgroundColor = color.cgColor }
            if let color = selection.line.color { text.borderColor = color.cgColor }
            if let color = selection.text.color { text.foregroundColor = color.cgColor }
            if let thickness = selection.line.thickness { text.borderWidth = thickness }
        }
    }

    open func findSelected(_ point: CGPoint) -> SelectionResult? {
        guard (self.selection.isEnabled),
            let sublayers = self.sublayers
            else { return nil }

        var result: SelectionResult? = nil

        for (index, layer) in sublayers.enumerated() {

            if let shape = layer as? CAShapeLayer,
                let shapePath = shape.path,
                (shapePath.contains(point)) {

                let shapeFrame = shapePath.boundingBoxOfPath
                let shapeCenter = CGPoint(x: shapeFrame.origin.x + (shapeFrame.size.width  / 2),
                                          y: shapeFrame.origin.y + (shapeFrame.size.height / 2))

                var selectionData = self.data
                selectionData.selectedIndex = index

                result = SelectionResult(
                    point: shapeCenter,
                    data: selectionData,
                    layer: self
                )
            }
        }

        return result
    }
}
