//
//  Home.swift
//  UI-446
//
//  Created by nyannyan0328 on 2022/02/03.
//

import SwiftUI

struct Home: View {
    @State var startAngle : Double = 0
    @State var toAngle : Double = 180
    
    @State var startProgress : CGFloat = 0
    @State var toProgress : CGFloat = 0.5
    var body: some View {
        VStack{
            
            
            HStack{
                
                VStack(spacing:10){
                    
                    Text("Today")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.black)
                    
                    Text("Good Morinig")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth:.infinity,alignment: .leading)
                
                
                Button {
                    
                } label: {
                    
                    
                    Image("p1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                
                }

                
            }
            
            
            sleepTimerSlider()
                .padding(.top,50)
            
            
            
            Button {
                
            } label: {
                
                Text("Start Sleep")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                    .background(Color("Blue"))
                    .cornerRadius(5)
                    .padding(.top,60)
            }
            
            
            
            
            HStack{
                
                
                VStack(spacing:10){
                    
                    Label {
                        
                        Text("Bed Time")
                            
                        
                    } icon: {
                        
                        Image(systemName: "moon.fill")
                    }
                    
                    
                    Text(getTime(angle:startAngle).formatted(date: .omitted, time: .shortened))
                        .font(.largeTitle.weight(.bold))
                }
                .frame(maxWidth:.infinity)
                
                VStack(spacing:10){
                    
                    Label {
                        
                        Text("Wake Up")
                            
                        
                    } icon: {
                        
                        Image(systemName: "alarm")
                    }
                    
                    
                    Text(getTime(angle:toAngle).formatted(date: .omitted, time: .shortened))
                        .font(.largeTitle.weight(.bold))
                }
                .frame(maxWidth:.infinity)

                
                
            }
            .padding()
            .background(Color.gray.opacity(0.1),in: RoundedRectangle(cornerRadius: 10))
            .padding(.top,70)
        

        }
        .padding()
        .frame(maxHeight:.infinity,alignment: .top)
    }
    
    @ViewBuilder
    func sleepTimerSlider()->some View{
        
        GeometryReader{proxy in
            
            let width = proxy.size.width
            
            
            ZStack{
                
                
                ZStack{
                    
                    ForEach(1...60,id:\.self){index in
                        
                        
                        Rectangle()
                            .fill(index % 5 == 0 ? .black : .gray)
                            .frame(width: 3, height: index % 5 == 0 ? 10 : 5)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                        
                        
                        
                        
                        
                    }
                    
                    
                    let text = [6,9,12,3]
                    
                    
                    ForEach(text.indices,id:\.self){index in
                        
                        
                        Text("\(text[index])")
                            .font(.callout.bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -90))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 90))
                        
                        
                    }
                    
                    
                }
                
                
                Circle()
                    .stroke(.gray.opacity(0.06),lineWidth: 40)
                
                
                let reversRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reversRotation / 360))
                    .stroke(Color("Blue"),style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reversRotation))
                
               
                
               
                
                
                
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .background(.white,in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                    
                        DragGesture().onChanged({ value in
                            
                            onDrag(value: value,fromeSlider: true)
                            
                        })
                    
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
                
                Image(systemName: "alarm")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -toAngle))
                    .background(.white,in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                    
                        DragGesture().onChanged({ value in
                            
                            onDrag(value: value)
                            
                        })
                    
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
                
                VStack(spacing:10){
                    
                    
                    Text("\(getTimeDifference().0)hu")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    Text("\(getTimeDifference().1)minute")
                        .foregroundColor(.gray)
                }
                .scaleEffect(1.2)
                
                
                
                
                
                
                
            }
            
            
            
            
        }
        .frame(width: getScreenBounds().width / 1.6, height: getScreenBounds().width / 1.6)
    }
    
    
    func onDrag(value : DragGesture.Value,fromeSlider : Bool = false){
        
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        
        let radius = atan2(vector.dy - 15, vector.dx - 15)
        
        var angle = radius * 180 / .pi
        
        if angle < 0{angle = 360 + angle}
        
        let progress = angle / 360
        
        
        
        if fromeSlider{
            
        
            self.startAngle = angle
            self.startProgress = progress
            
            
        }
        else{
            
            self.toAngle = angle
            self.toProgress = progress
            
            
            
           
        }
        
        
        
        
        
        
    }
    
    
    func getTime(angle : Double)->Date{
        
        
        let progress = angle / 30
        
        let hour = Int(progress)
        
        let remaindar = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        
        
        var minute = remaindar * 5
        
        
        
        minute = (minute > 55 ? 55 : minute)
        
        let formate = DateFormatter()
        
        formate.dateFormat = "hh:mm:ss"
        
        
        if let date = formate.date(from: "\(hour):\(Int(minute)):00"){
            
            return date
            
            
        }
        
        return .init()
    }
    
    
    func getTimeDifference()->(Int,Int){
        let calendar = Calendar.current
        
        let result = calendar.dateComponents([.hour,.minute], from: getTime(angle: startAngle),to: getTime(angle: toAngle))
        
        return (result.hour ?? 0,result.minute ?? 0)
        
        
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View{
    
    func getScreenBounds()->CGRect{
        
        return UIScreen.main.bounds
    }
}
