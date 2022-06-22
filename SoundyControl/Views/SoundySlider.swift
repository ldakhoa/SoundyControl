//
//  SoundySlider.swift
//  SoundyControl
//
//  Created by Khoa Le on 22/06/2022.
//

import SwiftUI

struct SliderComponents {
    let barLeft: SliderModifier
    let barRight: SliderModifier
    let knob: SliderModifier
}

struct SliderModifier: ViewModifier {
    enum Name {
        case barLeft
        case barRight
        case knob
    }
    
    let name: Name
    let size: CGSize
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size.width)
            .position(x: size.width * 0.5, y: size.height * 0.5)
            .offset(x: offset)
    }
}

struct SoundySlider<Component: View>: View {
    @Binding var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (SliderComponents) -> Component
    
    init(
        value: Binding<Double>,
        range: (Double, Double),
        knobWidth: CGFloat? = nil,
        _ viewBuilder: @escaping (SliderComponents) -> Component
    ) {
        _value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.view(geometry: geometry)
        }
    }
    
    private func onDragChange(_ drag: DragGesture.Value, _ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xRange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
        value -= 0.5 * width.knob // offset from center to leading edge of knob
        value = value > xRange.max ? xRange.max : value // limit to leading edge
        value = value < xRange.min ? xRange.min : value // limit to trailing edge
        value = value.convert(fromRange: (xRange.min, xRange.max), toRange: range)
        self.value = value
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xRange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xRange)
        return CGFloat(result)
    }
    
    private func view(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let drag = DragGesture(minimumDistance: 0).onChanged { drag in
            self.onDragChange(drag, frame)
        }
        
        let offSetX = self.getOffsetX(frame: frame)
        
        let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
        let barLeftSize = CGSize(
            width: CGFloat(offSetX + knobSize.width * 0.5),
            height: frame.height)
        let barRightSize = CGSize(
            width: frame.width - barLeftSize.width,
            height: frame.height)
        let modifiers = SliderComponents(
            barLeft: SliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
            barRight: SliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
            knob: SliderModifier(name: .knob, size: knobSize, offset: offSetX))
        
        return ZStack {
            viewBuilder(modifiers)
                .gesture(drag)
        }
    }
}

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}
