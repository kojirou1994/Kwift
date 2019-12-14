#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    @inlinable
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

}
#endif
