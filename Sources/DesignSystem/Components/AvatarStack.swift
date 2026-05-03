import SwiftUI

// MARK: - Avatar

public struct Avatar: View {
    private let image: Image?
    private let imageURL: URL?
    private let size: CGFloat
    private let showBorder: Bool

    public init(image: Image? = nil, imageURL: URL? = nil, size: CGFloat = 40, showBorder: Bool = true) {
        self.image = image
        self.imageURL = imageURL
        self.size = size
        self.showBorder = showBorder
    }

    public var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let loaded):
                        loaded
                            .resizable()
                            .scaledToFill()
                    case .empty, .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            showBorder ? Circle().stroke(Color.white, lineWidth: 2) : nil
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var placeholder: some View {
        Circle()
            .fill(Colors.glassBg)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundStyle(Colors.textMuted)
            )
    }
}

// MARK: - Avatar Stack (overlapping avatars + count)

public struct AvatarStack: View {
    private let images: [Image]
    private let count: Int
    private let avatarSize: CGFloat

    public init(images: [Image] = [], count: Int, avatarSize: CGFloat = 28) {
        self.images = images
        self.count = count
        self.avatarSize = avatarSize
    }

    public var body: some View {
        HStack(spacing: -8) {
            ForEach(0..<min(images.count, 2), id: \.self) { index in
                Avatar(image: images[index], size: avatarSize)
            }

            if images.count < 2 {
                ForEach(0..<(2 - images.count), id: \.self) { _ in
                    Avatar(size: avatarSize)
                }
            }

            if count > 2 {
                Text("+\(count - 2)")
                    .font(Typography.captionSmall)
                    .foregroundStyle(Color(hex: 0x94A3B8))
                    .frame(width: avatarSize, height: avatarSize)
                    .background(Color(hex: 0xF1F5F9).opacity(0.6))
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
            }
        }
    }
}

// MARK: - Previews

#Preview("Avatars") {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            Avatar(size: 40)
            Avatar(size: 28)
        }

        AvatarStack(count: 44)
    }
    .padding(32)
    .background(Colors.onboardingGradient)
}
