
import SwiftUI

struct LiquidGlassSettingView: View {
    @Binding var parameters: LiquidGlassParameters
    @State private var selectedShapeIndex = 0
    @State private var isShapesExpanded: Bool = false
    
    var body: some View {
        List {
            Section {
                Toggle("Glass Color", isOn: $parameters.isGlassColorEnabled)
            } header: {
                Text("Glass Color")
            }
            if parameters.isGlassColorEnabled {
                Section {
                    ColorPicker("Glass Color", selection: $parameters.glassColor)
                }
            }
            
            Section {
                Toggle("Lighting", isOn: $parameters.isLightingEnabled)
            } header: {
                Text("Lighting")
            }
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
            
            Section {
                Toggle("Refraction", isOn: $parameters.isRefractionEnabled)
            } header: {
                Text("Refraction")
            }
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
                }
            }
            
            Section {
                Toggle("Chromatic Aberration", isOn: $parameters.isChromaticAberrationEnabled)
            } header: {
                Text("Chromatic Aberration")
            }
            if parameters.isChromaticAberrationEnabled {
                Section {
                    HStack(spacing: 16) {
                        Text("Chromatic Aberration")
                        Slider(value: $parameters.chromaticAberration, in: 0...0.2)
                    }
                }
            }
            
            Section {
                Toggle("Background Blur", isOn: $parameters.isBlurEnabled)
            } header: {
                Text("Background Blur")
            }
            if parameters.isBlurEnabled {
                Section {
                    HStack(spacing: 16) {
                        Text("Blur Radius")
                        Slider(value: $parameters.blurRadius, in: 0...4)
                    }
                }
            }
            
            Section {
                Toggle("Smooth Union", isOn: $parameters.isSmoothUnionEnabled)
            } header: {
                Text("Smooth Union")
            }
            if parameters.isSmoothUnionEnabled {
                Section {
                    HStack(spacing: 16) {
                        Text("Blend")
                        Slider(value: $parameters.blend, in: 0...200)
                    }
                }
            }
            
            DisclosureGroup(
                isExpanded: $isShapesExpanded,
                content: {
                    Section {
                        Toggle("Shape 1", isOn: $parameters.isShape1Enabled)
                    } header: {
                        Text("Shape 1")
                    }
                    if parameters.isShape1Enabled {
                        // Shape 1 settings
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

                    Section {
                        Toggle("Shape 2", isOn: $parameters.isShape2Enabled)
                    } header: {
                        Text("Shape 2")
                    }
                    if parameters.isShape2Enabled {
                        // Shape 2 settings
                        // ... (similar to Shape 1 settings, but for parameters.shapes[1])
                    }

                    Section {
                        Toggle("Shape 3", isOn: $parameters.isShape3Enabled)
                    } header: {
                        Text("Shape 3")
                    }
                    if parameters.isShape3Enabled {
                        // Shape 3 settings
                        // ... (similar to Shape 1 settings, but for parameters.shapes[2])
                    }
                },
                label: {
                    Text("Shapes")
                }
            )
        }
    }
}

#Preview {
    @Previewable @State var parameters = LiquidGlassParameters()
    LiquidGlassSettingView(parameters: $parameters)
}
