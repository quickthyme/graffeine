#if canImport(UIKit)
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
public struct GraffeineViewRep: UIViewRepresentable {
    public typealias UIViewType = GraffeineView

    var configClass: String?
    var apply: (GraffeineView) -> ()

    public func makeUIView(context: UIViewRepresentableContext<GraffeineViewRep>) -> GraffeineView {
        return GraffeineView(frame: .zero, configClass: self.configClass ?? "")
    }

    public func updateUIView(_ uiView: GraffeineView, context: UIViewRepresentableContext<GraffeineViewRep>) {
        apply(uiView)
        uiView.layoutSublayers(of: uiView.layer)
    }

    public init(configClass: String? = nil, apply: @escaping (GraffeineView) -> ()) {
        self.configClass = configClass
        self.apply = apply
    }
}
