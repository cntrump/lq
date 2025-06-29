
import SwiftUI

struct LiquidGlassDemoView: View {
    @State var parameters: LiquidGlassParameters = .init()
    @State var isSheetPresented: Bool = false
    @State private var draggingShapeIndex: Int? = nil

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isPad: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        if isPad {
            NavigationSplitView {
                LiquidGlassSettingView(parameters: $parameters)
            } detail: {
                liquidGlassView
            }
        } else {
            liquidGlassView
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            isSheetPresented = true
                        }, label: {
                            Image(systemName: "slider.horizontal.3")
                        })
                    }
                }
                .sheet(isPresented: $isSheetPresented) {
                    LiquidGlassSettingView(parameters: $parameters)
                        .presentationDetents([.medium])
                }
        }
    }
    
    @ViewBuilder
    private var liquidGlassView: some View {
        GeometryReader { geometry in
            BackgroundView()
                .gesture(drag(size: geometry.size))
                .layerEffect(
                    parameters.liquidGlassShader(size: geometry.size),
                    maxSampleOffset: .zero
                )
        }
        .ignoresSafeArea()
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





extension GeometryProxy {
    var center: CGPoint {
        .init(x: size.width * 0.5, y: size.height * 0.5)
    }
}

extension CGSize {
    var point: CGPoint {
        .init(x: width, y: height)
    }
}

extension CGPoint {
    func added(_ other: CGPoint) -> CGPoint {
        .init(x: x + other.x, y: y + other.y)
    }
    
    func rate(size: CGSize) -> CGPoint {
        .init(x: x / size.width, y: y / size.height)
    }
}

func distance(from: CGPoint, to: CGPoint) -> CGFloat {
    sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
}

#Preview {
    LiquidGlassDemoView()
}



