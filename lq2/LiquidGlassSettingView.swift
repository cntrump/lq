
import SwiftUI

struct LiquidGlassSettingView: View {
    @Binding var parameters: LiquidGlassParameters
    @State private var selectedShapeIndex = 0
    @State private var isShapesExpanded: Bool = false
    
    var body: some View {
        List {
            Section {
                Toggle("Glass Color", isOn: $parameters.isGlassColorEnabled)
                if parameters.isGlassColorEnabled {
                    Section {
                        ColorPicker("Glass Color", selection: $parameters.glassColor)
                    }
                }
            } header: {
                Text("Glass Color")
            }
            
            Section {
                Toggle("Lighting", isOn: $parameters.isLightingEnabled)
                if parameters.isLightingEnabled {
                    Section {
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
                }
            } header: {
                Text("Lighting")
            }
            
            Section {
                Toggle("Refraction", isOn: $parameters.isRefractionEnabled)
                if parameters.isRefractionEnabled {
                    Section {
                        HStack(spacing: 16) {
                            Text("Thickness")
                            Slider(value: $parameters.thickness, in: 0...50)
                        }
                        HStack(spacing: 16) {
                            Text("Refractive Index")
                            Slider(value: $parameters.refractiveIndex, in: 1...2)
                        }
                        HStack(spacing: 16) {
                            Text("Chromatic Aberration")
                            Slider(value: $parameters.chromaticAberration, in: 0...0.2)
                        }
                    }
                }
            } header: {
                Text("Refraction")
            }
            
            Section {
                Toggle("Background Blur", isOn: $parameters.isBlurEnabled)
                if parameters.isBlurEnabled {
                    HStack(spacing: 16) {
                        Text("Blur Radius")
                        Slider(value: $parameters.blurRadius, in: 0...4)
                    }
                }
            } header: {
                Text("Background Blur")
            }
            
            Section {
                Toggle("Smooth Union", isOn: $parameters.isSmoothUnionEnabled)
                if parameters.isSmoothUnionEnabled {
                    HStack(spacing: 16) {
                        Text("Blend")
                        Slider(value: $parameters.blend, in: 0...200)
                    }
                }
            } header: {
                Text("Smooth Union")
            }
            
            Section {
                DisclosureGroup(
                    isExpanded: $isShapesExpanded,
                    content: {
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
                    },
                    label: {
                        Text("Shapes")
                    }
                    
                )
            } header: {
                Text("Shapes")
            }
        }
    }
}

#Preview {
    @Previewable @State var parameters = LiquidGlassParameters()
    LiquidGlassSettingView(parameters: $parameters)
}
