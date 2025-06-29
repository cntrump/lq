
import SwiftUI

struct LiquidGlassParameters {
    var chromaticAberration: Float = 0.0
    var glassColor: Color = .init(red: 0.2, green: 0.5, blue: 1, opacity: 0.3)
    var lightAngle: Float = 0.785398
    var lightIntensity: Float = 1.0
    var ambientStrength: Float = 0.1
    var thickness: Float = 25
    var refractiveIndex: Float = 1.5
    var blend: Float = 100
    var blurRadius: Float = 2.0

    var isSmoothUnionEnabled: Bool = true
    var isRefractionEnabled: Bool = true
    var isChromaticAberrationEnabled: Bool = true
    var isLightingEnabled: Bool = true
    var isGlassColorEnabled: Bool = true
    var isBlurEnabled: Bool = true
    
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
