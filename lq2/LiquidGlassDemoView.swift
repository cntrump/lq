
import SwiftUI

struct LiquidGlassDemoView: View {
    @State var parameters: LiquidGlassParameters = .init()
    @State var isSheetPresented: Bool = false
    @State private var draggingShapeIndex: Int? = nil

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .regular {
            // iPad
            NavigationSplitView {
                settingsView(titleDisplayMode: .large)
            } detail: {
                liquidGlassView
            }
        } else {
            // iPhone
            NavigationView {
                liquidGlassView
                    .toolbar {
                        presentSheetItem
                    }
                    .sheet(isPresented: $isSheetPresented) {
                        NavigationView {
                            settingsView(titleDisplayMode: .inline)
                        }
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var liquidGlassView: some View {
        GeometryReader { proxy in
            BackgroundView()
                .position(
                    x: proxy.frame(in: .local).midX,
                    y: proxy.frame(in: .local).midY
                )
                .gesture(drag(size: proxy.size))
                .layerEffect(
                    parameters.liquidGlassShader(size: proxy.size),
                    maxSampleOffset: .zero
                )
        }
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder
    private func settingsView(titleDisplayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        LiquidGlassSettingView(parameters: $parameters)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        parameters.minimumize()
                    }, label: {
                        Image(systemName: "minus.circle")
                    })
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(titleDisplayMode)
    }
    
    @ToolbarContentBuilder
    private var presentSheetItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                isSheetPresented = true
            }, label: {
                Image(systemName: "slider.horizontal.3")
            })
        }
    }
    
    
    private func drag(size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if draggingShapeIndex == nil {
                    let distances = parameters.shapes.map { shape in
                        distance(from: shape.center(size: size), to: value.location)
                    }
                    if let minIndex = distances.indices.min(by: { distances[$0] < distances[$1] }) {
                        // Only start dragging if the touch is close enough to the center of the shape
                        if distances[minIndex] < max(parameters.shapes[minIndex].size.width, parameters.shapes[minIndex].size.height) * 0.5 {
                            draggingShapeIndex = minIndex
                        }
                    }
                }
                
                if let index = draggingShapeIndex {
                    parameters.shapes[index].position = value.location.rate(size: size)
                }
            }
            .onEnded { _ in
                draggingShapeIndex = nil
            }
    }
}


fileprivate extension CGPoint {
    func rate(size: CGSize) -> CGPoint {
        .init(x: x / size.width, y: y / size.height)
    }
}

fileprivate func distance(from: CGPoint, to: CGPoint) -> CGFloat {
    sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
}

#Preview {
    LiquidGlassDemoView()
}



