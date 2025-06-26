import SwiftUI

struct BackgroundView: View {
    @State private var index = 0
    private let resources: [ImageResource?] = [.photo1, .photo2, .photo3, nil]
    private let text = "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。"
    
    var body: some View {
        ZStack {
            if let resource = resources[index] {
                Image(resource)
                    .resizable()
                    .scaledToFill()
            } else {
                Text([String](repeating: text, count: 50).joined())
                    .font(.system(size: CGFloat(24)))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(UIColor.label))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemBackground))
            }
        }
        .onTapGesture(count: 2) {
            index = (index + 1) % resources.count
        }
    }
}
