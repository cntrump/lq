
import SwiftUI

struct LiquieGlassDemoView: View {
    @State var parameters: LiquidGlassParameters = .init()
    @State var isSheetPresented: Bool = false
    @State private var draggingShapeIndex: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            BackgroundView()
                .gesture(drag(size: geometry.size))
                .layerEffect(
                    ShaderLibrary.liquidGlass(
                        .float2(geometry.size.point),
                        .float(parameters.chromaticAberration),
                        .color(parameters.glassColor),
                        .float(parameters.lightAngle),
                        .float(parameters.lightIntensity),
                        .float(parameters.ambientStrength),
                        .float(parameters.thickness),
                        .float(parameters.refractiveIndex),
                        .float(parameters.shapes[0].type.rawValue),
                        .float2(parameters.shapes[0].center(size: geometry.size)),
                        .float2(parameters.shapes[0].size),
                        .float(parameters.shapes[0].cornerRadius),
                        .float(parameters.shapes[1].type.rawValue),
                        .float2(parameters.shapes[1].center(size: geometry.size)),
                        .float2(parameters.shapes[1].size),
                        .float(parameters.shapes[1].cornerRadius),
                        .float(parameters.shapes[2].type.rawValue),
                        .float2(parameters.shapes[2].center(size: geometry.size)),
                        .float2(parameters.shapes[2].size),
                        .float(parameters.shapes[2].cornerRadius),
                        .float(parameters.blend),
                        .float(parameters.blurRadius)
                    ),
                    maxSampleOffset: .zero
                )
        }
        .ignoresSafeArea()
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
            LiquidGlassSettingSheet(parameters: $parameters)
                .presentationDetents([.medium])
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

struct LiquidGlassParameters {
    var chromaticAberration: Float = 0.0
    var glassColor: Color = .init(red: 0.2, green: 0.5, blue: 1, opacity: 0.3)
    var lightAngle: Float = 0.785398
    var lightIntensity: Float = 1.0
    var ambientStrength: Float = 0.1
    var thickness: Float = 25
    var refractiveIndex: Float = 1.5
    var blend: Float = 100
    var blurRadius: Float = 0.0
    
    var shapes: [Shape] = [
        .init(
            type: .squircle,
            position: .init(x: 0.5, y: 0.5),
            size: .init(width: 200, height: 200),
            cornerRadius: 80
        ),
        .init(
            type: .squircle,
            position: .init(x: 0.2, y: 0.8),
            size: .init(width: 100, height: 100),
            cornerRadius: 50
        ),
        .init(
            type: .squircle,
            position: .init(x: 0.8, y: 0.2),
            size: .init(width: 150, height: 150),
            cornerRadius: 75
        )
    ]
    
    struct Shape {
        var type: ShapeType
        var position: CGPoint
        var size: CGSize
        var cornerRadius: Float
        
        func center(size: CGSize) -> CGPoint {
            .init(x: position.x * size.width, y: position.y * size.height)
        }
    }
    
    enum ShapeType: Float, CaseIterable, Identifiable {
        case squircle = 1
        case ellipse = 2
        case roundedRectangle = 3
        
        var id: Self { self }
        
        var name: String {
            switch self {
            case .squircle: "Squircle"
            case .ellipse: "Ellipse"
            case .roundedRectangle: "Rounded Rectangle"
            }
        }
    }
}

struct LiquidGlassSettingSheet: View {
    @Binding var parameters: LiquidGlassParameters
    @State private var selectedShapeIndex = 0
    
    var body: some View {
        NavigationView {
            List {
                Section("Global") {
                    HStack(spacing: 16) {
                        Text("Thickness")
                        Slider(value: $parameters.thickness, in: 0...50)
                    }
                    HStack(spacing: 16) {
                        Text("Refractive Index")
                        Slider(value: $parameters.refractiveIndex, in: 1...2)
                    }
                    HStack(spacing: 16) {
                        Text("Blend")
                        Slider(value: $parameters.blend, in: 0...200)
                    }
                    HStack(spacing: 16) {
                        Text("Chromatic Aberration")
                        Slider(value: $parameters.chromaticAberration, in: 0...0.2)
                    }
                    HStack(spacing: 16) {
                        Text("Blur Radius")
                        Slider(value: $parameters.blurRadius, in: 0...4)
                    }
                    ColorPicker("Glass Color", selection: $parameters.glassColor)
                }
                Section("Light") {
                    HStack(spacing: 16) {
                        Text("Angle")
                        Slider(value: $parameters.lightAngle, in: 0...Float.pi * 2)
                    }
                    HStack(spacing: 16) {
                        Text("Intensity")
                        Slider(value: $parameters.lightIntensity, in: 0...2)
                    }
                    HStack(spacing: 16) {
                        Text("Ambient Strength")
                        Slider(value: $parameters.ambientStrength, in: 0...1)
                    }
                }
                
                Section("Shapes") {
                    Picker("Shape", selection: $selectedShapeIndex) {
                        ForEach(parameters.shapes.indices, id: \.self) { index in
                            Text("Shape \(index + 1)").tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Type", selection: $parameters.shapes[selectedShapeIndex].type) {
                        ForEach(LiquidGlassParameters.ShapeType.allCases) { type in
                            Text(type.name).tag(type)
                        }
                    }
                    HStack(spacing: 16) {
                        Text("Width")
                        Slider(value: $parameters.shapes[selectedShapeIndex].size.width, in: 0...200)
                    }
                    HStack(spacing: 16) {
                        Text("Height")
                        Slider(value: $parameters.shapes[selectedShapeIndex].size.height, in: 0...200)
                    }
                    if parameters.shapes[selectedShapeIndex].type != .ellipse {
                        HStack(spacing: 16) {
                            Text("Corner Radius")
                            Slider(value: $parameters.shapes[selectedShapeIndex].cornerRadius, in: 0...Float(min(parameters.shapes[selectedShapeIndex].size.width, parameters.shapes[selectedShapeIndex].size.height) / 2))
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
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
    LiquieGlassDemoView()
}



