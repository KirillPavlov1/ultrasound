//
//  waves.swift
//  onboarding
//
//  Created by Кирилл on 28.08.2021.
//

import SwiftUI

class ScoreModel: ObservableObject {
    @Published var score1 = 5
    @Published var score2 = 7
}



struct Wave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let wavelength = width / frequency
        let oneOverMidWidth = 1 / midWidth
        
        path.move(to: CGPoint(x: 0, y: midHeight * 1.5))
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let distanceFromMidWidth = x - midWidth
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            let parabola = -(normalDistance * normalDistance) + 1
            let sine = sin(relativeX + phase)
            let y = parabola * strength * sine + midHeight * 1.5
            path.addLine(to: CGPoint(x: x, y: y))
        }
        return Path(path.cgPath)
    }
}
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
struct settings: View{
    //@State private var favoriteColor = 0
    @Binding var myUnit : ToneOutputUnit
    @Binding var value: CGPoint
    var body: some View{
        ZStack{
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [ Color(red: 0.302, green: 0.765, blue: 1), Color(red: 0.173, green: 0.459, blue: 0.945)]), startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 1)))
            .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
            CustomPicker(value: $value,  myUnit: $myUnit)
            Spacer()
            HStack{
                Link("Privacy Policy", destination: URL(string: "http://cbdapps-srl.tilda.ws/privacypolicy")!)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                Text("          |          ")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                Link("Terms Of Use", destination: URL(string: "http://cbdapps-srl.tilda.ws/termsofuse")!)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.bottom, 5)
            }
        }
    }
       
    func colorChange(_ tag: CGFloat) {
        self.myUnit.setFrequency(freq: Double(tag))
    }
}

struct wave: View{
    @State private var phase = 0.0
    @Binding var value: CGPoint
    @State private var start = true
    var initialCenter = CGPoint()
    @Binding var myUnit : ToneOutputUnit
    
    func button()
    {
        if (self.start)
        {
            myUnit.setFrequency(freq: Double(self.value.y))
            myUnit.enableSpeaker()
            myUnit.setToneTime(t: 20000)
            self.start = false
        }
        else
        {
            self.start = true
            myUnit.stop()
        }
    }
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                    self.value = CGPoint(x: self.value.x + (value.location.x - value.startLocation.x), y: self.value.y + ((value.startLocation.y - value.location.y) / 5))
                    if (self.value.y > 25000)
                    {
                        self.value.y = 25000
                    }
                    else if (self.value.y < 0)
                    {
                        self.value.y = 0
                    }
                    self.myUnit.setFrequency(freq: Double(self.value.y))
                }
                .onEnded{ value in
                    
                    self.value = CGPoint(x: self.value.x + (value.location.x - value.startLocation.x), y: self.value.y + ((value.startLocation.y - value.location.y) / 5))
                    if (self.value.y > 25000)
                    {
                        self.value.y = 25000
                    }
                    else if (self.value.y < 0)
                    {
                        self.value.y = 0
                    }
                    myUnit.setFrequency(freq: Double(self.value.y))
                }
        }
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: UIScreen.screenHeight / 8){
           Spacer()
          // Spacer()
        
        Text("\(Int(value.y))")
            .foregroundColor(.white)
            .font(.largeTitle)
           // Spacer()
           // Spacer()
        ZStack {
                        ForEach(4..<8) { i in
                        let x = 1500 / (i * i)
                            Wave(strength: Double(x), frequency: Double(self.value.y) / 500 , phase: self.phase)
                            .stroke(Color.white, lineWidth: 2)
                        }
                
            }
            Spacer()
            Button(action: {self.button()})
            {
                start ? Text("Start")
                    .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight / 17)
                    .foregroundColor(.white)
                    : Text("Stop")
                    .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight / 17)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.screenWidth * 0.85)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color(red: 0.302, green: 0.765, blue: 1))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 2)
            )
            .cornerRadius(12)
           
            .font(.largeTitle)
           Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [ Color(red: 0.302, green: 0.765, blue: 1), Color(red: 0.173, green: 0.459, blue: 0.945)]), startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 1)))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.phase = -.pi * 2
            }
        
        }
        .gesture(
            simpleDrag
        )
    }
}


struct main: View {
    @StateObject var viewRouter: ViewRouter
    @State var value: CGPoint = CGPoint(x: 0, y: 165)
    @State var myUnit = ToneOutputUnit()
    var body: some View{
        TabView{
            wave(value: $value, myUnit: $myUnit)
                .tabItem {
                                    Label("Sound", systemImage: "waveform.path.ecg")
                                }

            settings(myUnit: $myUnit, value: $value)
                .tabItem {
                                    Label("Settings", systemImage: "square.and.pencil")
                                }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}
struct main_Previews: PreviewProvider {
    static var previews: some View {
        main(viewRouter: ViewRouter())
    }
}
