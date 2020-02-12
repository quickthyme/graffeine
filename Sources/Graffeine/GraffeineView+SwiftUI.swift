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

    public func makeUIView(context: UIViewRepresentableContext<GraffeineViewRep>) -> GraffeineView {
        return GraffeineView(frame: .zero, configClass: self.configClass ?? "")
    }

    public func updateUIView(_ uiView: GraffeineView, context: UIViewRepresentableContext<GraffeineViewRep>) {
        uiView.layerDataInput = layerDataInput
        uiView.layoutSublayers(of: uiView.layer)
    }

    public init(configClass: String? = nil, layerDataInput: Binding<[GraffeineView.LayerData]>) {
        self.configClass = configClass
        self._layerDataInput = layerDataInput
    }
}
