#if canImport(UIKit)
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct GraffeineViewRep: UIViewRepresentable {
    typealias UIViewType = GraffeineView

    func makeUIView(context: UIViewRepresentableContext<GraffeineViewRep>) -> GraffeineView {
        return GraffeineView()
    }

    func updateUIView(_ uiView: GraffeineView, context: UIViewRepresentableContext<GraffeineViewRep>) {
        uiView.layoutSublayers(of: uiView.layer)
    }
}
