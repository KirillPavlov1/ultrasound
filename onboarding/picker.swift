//
//  picker.swift
//  ultrasound
//
//  Created by Кирилл on 02.09.2021.
//

import Foundation
import SwiftUI

struct CustomPicker : UIViewRepresentable{
    @Binding var value: CGPoint
    @Binding var myUnit : ToneOutputUnit
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }
    class Coordinator : NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
        var parent: CustomPicker
        init(parent1 : CustomPicker)
        {
            parent = parent1
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return data.count
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth - 100 , height: 60))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            label.text = String(data[row])
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 23, weight: .bold)
            view.addSubview(label)
            return view
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.value.y = CGFloat(data[row])
            self.parent.myUnit.setFrequency(freq: Double(self.parent.value.y))
        }
    }
}

var data = [1600, 3600, 6600, 9600, 12500, 18500, 22500, 25000]
