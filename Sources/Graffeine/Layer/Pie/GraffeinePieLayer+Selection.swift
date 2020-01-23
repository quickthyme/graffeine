import UIKit

internal extension GraffeinePieLayer {

    func resolveSelection(slice: PieSlice,
                          index: Int,
                          origRadius: CGFloat,
                          origHoleRadius: CGFloat) {
        if (data.selectedIndex == index) {
            if let color = selection.fill.color { slice.fillColor = color.cgColor }
            if let color = selection.line.color { slice.strokeColor = color.cgColor }
            if let thickness = selection.line.thickness { slice.lineWidth = thickness }

            if let selectedDiameter = selection.radial.diameter {
                slice.radius = resolveRadius(selectedDiameter)
            }

            if let selectedHoleDiameter = selection.radial.holeDiameter {
                slice.holeRadius = resolveRadius(selectedHoleDiameter)
            }
        }
    }
}
