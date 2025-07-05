
import SwiftUI

struct LiquidGlassParameters {
    var isGlassColorEnabled: Bool = true
    var glassColor: Color = .init(red: 1, green: 1, blue: 1, opacity: 0.6)

    var isLightingEnabled: Bool = true
    var lightAngle: Float = 0.785398
    var lightIntensity: Float = 2.5
    var ambientStrength: Float = 0.1

    var isRefractionEnabled: Bool = true
    var thickness: Float = 25.0
    var refractiveIndex: Float = 1.5
    var chromaticAberration: Float = 0.0

    var isBlurEnabled: Bool = true
    var blurRadius: Float = 2.0

    var isSmoothUnionEnabled: Bool = true
    var blend: Float = 100
    
    var shapes: [Shape] = [
        .init(
            type: .squircle,
            position: .init(x: 0.5, y: 0.5),
            size: .init(width: 200, height: 200),
            cornerRadius: 80
        ),
        .init(
            type: .roundedRectangle,
            position: .init(x: 0.2, y: 0.8),
            size: .init(width: 160, height: 80),
            cornerRadius: 40
        ),
        .init(
            type: .ellipse,
            position: .init(x: 0.8, y: 0.2),
            size: .init(width: 150, height: 150),
            cornerRadius: 0
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
    
    mutating func minimumize() {
        isGlassColorEnabled = true
        isLightingEnabled = false
        isLightingEnabled = false
        isRefractionEnabled = false
        isBlurEnabled = false
        isSmoothUnionEnabled = false
    }
    
    func liquidGlassShader(size: CGSize) -> Shader {
        ShaderLibrary.liquidGlass(
            .float2(.init(x: size.width, y: size.height)),
            .float(chromaticAberration),
            .color(glassColor),
            .float(lightAngle),
            .float(lightIntensity),
            .float(ambientStrength),
            .float(thickness),
            .float(refractiveIndex),
            .float(shapes[0].type.rawValue),
            .float2(shapes[0].center(size: size)),
            .float2(shapes[0].size),
            .float(shapes[0].cornerRadius),
            .float(isSmoothUnionEnabled ? shapes[1].type.rawValue : 0.0),
            .float2(shapes[1].center(size: size)),
            .float2(shapes[1].size),
            .float(shapes[1].cornerRadius),
            .float(isSmoothUnionEnabled ? shapes[2].type.rawValue : 0.0),
            .float2(shapes[2].center(size: size)),
            .float2(shapes[2].size),
            .float(shapes[2].cornerRadius),
            .float(blend),
            .float(blurRadius),
            .float(isSmoothUnionEnabled ? 1.0 : 0.0),
            .float(isRefractionEnabled ? 1.0 : 0.0),
            .float(isLightingEnabled ? 1.0 : 0.0),
            .float(isGlassColorEnabled ? 1.0 : 0.0),
            .float(isBlurEnabled ? 1.0 : 0.0)
        )
    }
}
