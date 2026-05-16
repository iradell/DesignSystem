import SwiftUI

/// A single parameter for components that need to render either a
/// preloaded `Image` or a remote `URL` (decoded via `AsyncImage`).
///
/// Use instead of separate `image:` / `imageURL:` initializers — keeps
/// the call site one parameter and makes "exactly one source" the
/// type-system default. Components fall back to their own placeholder
/// when the value is `nil`.
public enum ImageSource: Equatable {
    case image(Image)
    case url(URL)
}
