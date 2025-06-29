
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
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                parameters.minimumize()
                            }, label: {
                                Image(systemName: "eraser")
                            })
                        }
                    }
            } detail: {
                liquidGlassView
            }
        } else {
            NavigationView {
                liquidGlassView
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                isSheetPresented = true
                            }, label: {
                                Image(systemName: "slider.horizontal.3")
                            })
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                parameters.minimumize()
                            }, label: {
                                Image(systemName: "slider.horizontal.3")
                            })
                        }
                    }
                    .sheet(isPresented: $isSheetPresented) {
                        NavigationView {
                            LiquidGlassSettingView(parameters: $parameters)
                                .navigationTitle("Settings")
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    }
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



