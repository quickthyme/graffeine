#if canImport(UIKit)
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
public struct GraffeineViewRep: UIViewRepresentable {
    public typealias UIViewType = GraffeineView
    public var configClass: String?

    @Binding public var layerDataInput: [GraffeineView.LayerData]

    public var onSelect: GraffeineView.OnSelect?

    public func makeUIView(context: UIViewRepresentableContext<GraffeineViewRep>) -> GraffeineView {
        let view = GraffeineView(frame: .zero, configClass: self.configClass ?? "")
        view.onSelect = onSelect
        return view
    }

    public func updateUIView(_ uiView: GraffeineView, context: UIViewRepresentableContext<GraffeineViewRep>) {
        uiView.layerDataInput = layerDataInput
        uiView.layoutSublayers(of: uiView.layer)
    }

    public init(configClass: String? = nil,
                layerDataInput: Binding<[GraffeineView.LayerData]>,
                onSelect: GraffeineView.OnSelect? = nil) {
        self.configClass = configClass
        self._layerDataInput = layerDataInput
        self.onSelect = onSelect
    }
}
