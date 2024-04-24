//
//  ContentView.swift
//  BusAlarmApp
//
//  Created by 中村優希 on 2024/04/10.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var showTimetableButton = true
    @State private var showTimetableText = false
    @State private var showSetTimetableText = false
    @State private var showBusButton = true
    @State private var showBusText = false
    @State private var showSelectBusText = false
    @State private var showAlarmButton = true
    @State private var showAlarmText = false
    @State private var showSetAlarmText = false
    
    @State private var departureBusStopName: String = ""
    @State private var arrivalBusStopName: String = ""
    
    @State private var showSetGoingTimeText = false
    @State private var showSetReturningTimeText = false
    @State private var goingDepartureHour: Int = 07
    @State private var goingDepartureMin: Int = 45
    @State private var goingArrivalHour: Int = 08
    @State private var goingArrivalMin: Int = 30
    @State private var returningDepartureHour: Int = 07
    @State private var returningDepartureMin: Int = 50
    @State private var returningArrivalHour: Int = 08
    @State private var returningArrivalMin: Int = 30
    @State private var goingTimeArray: [[Int]] = []
    @State private var returningTimeArray: [[Int]] = []
    
    @State private var selectedGoingBuses: [String: [Int]] = [:]
    @State private var selectedReturningBuses: [String: [Int]] = [:]
    
    @State private var travelTimeToBusStop: Int = 10
    
    @State private var toritsuText = false
    
    let daysOfWeek: [String] = ["月", "火", "水", "木", "金", "土", "日"]

    
    
    func hideAllButton() {
        showTimetableButton = false
        showBusButton = false
        showAlarmButton = false
    }
    
    func hideAllText() {
        showTimetableText = false
        showSetTimetableText = false
        showBusText = false
        showSelectBusText = false
        showSetAlarmText = false
        showAlarmText = false
        showSetGoingTimeText = false
        showSetReturningTimeText = false
        toritsuText = false
    }
    
    func calculateTimeUntilNextAlarm() -> (hours: Int, minutes: Int)? {
        let currentDate = Date()
        let calendar = Calendar.current
        
        guard let nextAlarmTime = getNextAlarmTime() else {
            return nil
        }
        
        let components = calendar.dateComponents([.hour, .minute], from: currentDate, to: nextAlarmTime)
        
        guard let hours = components.hour, let minutes = components.minute else {
            return nil
        }
        
        return (hours, minutes)
    }
    
    func getNextAlarmTime() -> Date? {
        return Calendar.current.date(byAdding: .hour, value: 1, to: Date())
    }
    
    func setToritsuTimetable() {
        departureBusStopName = "南大沢"
        arrivalBusStopName = "日野"
        
        goingTimeArray.append([07, 45, 08, 30])
        goingTimeArray.append([08, 40, 09, 10])
        goingTimeArray.append([09, 20, 09, 50])
        goingTimeArray.append([09, 50, 10, 20])
        goingTimeArray.append([10, 40, 11, 10])
        goingTimeArray.append([12, 20, 12, 50])
        goingTimeArray.append([13, 00, 13, 30])
        goingTimeArray.append([13, 50, 14, 20])
        goingTimeArray.append([14, 40, 15, 10])
        goingTimeArray.append([15, 30, 16, 00])
        goingTimeArray.append([15, 55, 16, 20])
        goingTimeArray.append([17, 10, 17, 40])
        goingTimeArray.append([17, 30, 18, 05])
        goingTimeArray.append([18, 45, 19, 25])
        
        returningTimeArray.append([07, 50, 08, 30])
        returningTimeArray.append([08, 40, 09, 10])
        returningTimeArray.append([09, 10, 09, 40])
        returningTimeArray.append([09, 50, 10, 20])
        returningTimeArray.append([10, 40, 11, 10])
        returningTimeArray.append([12, 20, 12, 50])
        returningTimeArray.append([13, 00, 13, 30])
        returningTimeArray.append([13, 50, 14, 20])
        returningTimeArray.append([14, 40, 15, 10])
        returningTimeArray.append([15, 20, 15, 50])
        returningTimeArray.append([16, 20, 16, 50])
        returningTimeArray.append([16, 30, 17, 00])
        returningTimeArray.append([18, 10, 18, 40])
        returningTimeArray.append([18, 30, 19, 10])

    }
    
    var body: some View {
        VStack {
            if showTimetableButton {
                Button(action: {
                    hideAllButton()
                    hideAllText()
                    toritsuText = true
                }) {
                    Text("時刻表の設定")
                }
                .buttonStyle(CustomButtonStyle())
            }
            
            if toritsuText {
                Text ("都立大学キャンパス連絡バスですか？")
                    .padding()
                
                HStack {
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        setToritsuTimetable()
                        showTimetableButton = true
                        showBusButton = true
                        showAlarmButton = true
                    }) {
                        Text("はい")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        if departureBusStopName == "" || arrivalBusStopName == "" {
                            showSetTimetableText = true
                        }
                        else {
                            showTimetableText = true
                        }
                    }) {
                        Text("いいえ")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                .padding()
            }
            
            if showSetTimetableText {
                Text("出発地点と到着地点の最寄りのバス停の名前をそれぞれ入力してください。")
                    .padding()
                
                HStack {
                    Text("出発")
                        .padding(.trailing, 5)
                    TextField("出発地点の最寄りのバス停", text: $departureBusStopName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 0)
                
                HStack {
                    Text("到着")
                        .padding(.trailing, 5)
                    TextField("到着地点の最寄りのバス停", text: $arrivalBusStopName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 0)
                
                HStack {
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showSetGoingTimeText = true
                    }) {
                        Text("確定")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showTimetableButton = true
                        showBusButton = true
                        showAlarmButton = true
                    }) {
                        Text("戻る")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
            }
            
            if showSetGoingTimeText {
                Text("行きの発着時刻を入力してください。")
                    .padding()
                
                HStack {
                    Text(departureBusStopName)
                        .padding(.trailing, 5)
                    TextField("出発時刻（時）", value: $goingDepartureHour, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(":")
                        .padding(.trailing, 5)
                    TextField("出発時刻（分）", value: $goingDepartureMin, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("→")
                        .padding(.trailing, 5)
                    TextField("到着時刻（時）", value: $goingArrivalHour, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(":")
                        .padding(.trailing, 5)
                    TextField("到着時刻（分）", value: $goingArrivalMin, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(arrivalBusStopName)
                        .padding(.trailing, 5)
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 0)
                
                Button(action: {
                    let times = [goingDepartureHour, goingDepartureMin, goingArrivalHour, goingArrivalMin]
                    goingTimeArray.append(times)
                }) {
                    Text("登録")
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
                
                ForEach(goingTimeArray.indices, id: \.self) { index in
                    let times = goingTimeArray[index]
                    HStack {
                        Text("\(departureBusStopName)")
                            .padding(.trailing, 5)
                        Text("\(times[0]):\(String(format: "%02d", times[1]))")
                            .padding(.trailing, 5)
                        Text("→")
                            .padding(.trailing, 5)
                        Text("\(times[2]):\(String(format: "%02d", times[3]))")
                            .padding(.trailing, 5)
                        Text("\(arrivalBusStopName)")
                            .padding(.trailing, 5)
                    }
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 0)
                }
                
                if goingTimeArray.count > 0 {
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showSetReturningTimeText = true
                    }) {
                        Text("帰りの発着時刻の入力に進む")
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                    )
                }
            }
            
            if showSetReturningTimeText {
                Text("帰りの発着時刻を入力してください。")
                    .padding()
                
                HStack {
                    Text(arrivalBusStopName)
                        .padding(.trailing, 5)
                    TextField("出発時刻（時）", value: $returningDepartureHour, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(":")
                        .padding(.trailing, 5)
                    TextField("出発時刻（分）", value: $returningDepartureMin, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("→")
                        .padding(.trailing, 5)
                    TextField("到着時刻（時）", value: $returningArrivalHour, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(":")
                        .padding(.trailing, 5)
                    TextField("到着時刻（分）", value: $returningArrivalMin, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(departureBusStopName)
                        .padding(.trailing, 5)
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 0)
                
                Button(action: {
                    let times = [returningDepartureHour, returningDepartureMin, returningArrivalHour, returningArrivalMin]
                    returningTimeArray.append(times)
                }) {
                    Text("登録")
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
                
                ForEach(returningTimeArray.indices, id: \.self) { index in
                    let times = returningTimeArray[index]
                    HStack {
                        Text("\(arrivalBusStopName)")
                            .padding(.trailing, 5)
                        Text("\(times[0]):\(String(format: "%02d", times[1]))")
                            .padding(.trailing, 5)
                        Text("→")
                            .padding(.trailing, 5)
                        Text("\(times[2]):\(String(format: "%02d", times[3]))")
                            .padding(.trailing, 5)
                        Text("\(departureBusStopName)")
                            .padding(.trailing, 5)
                    }
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 0)
                }
                
                if goingTimeArray.count > 0 {
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showTimetableText = true
                    }) {
                        Text("発着時刻の入力を終了する")
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                    )
                }
            }
            
            if showTimetableText {
                Text("時刻表はこちらです。")
                    .padding()
                
                ForEach(goingTimeArray.indices, id: \.self) { index in
                    let times = goingTimeArray[index]
                    HStack {
                        Text("\(departureBusStopName)")
                            .padding(.trailing, 5)
                        Text("\(times[0]):\(String(format: "%02d", times[1]))")
                            .padding(.trailing, 5)
                        Text("→")
                            .padding(.trailing, 5)
                        Text("\(times[2]):\(String(format: "%02d", times[3]))")
                            .padding(.trailing, 5)
                        Text("\(arrivalBusStopName)")
                            .padding(.trailing, 5)
                    }
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 0)
                }
                
                ForEach(returningTimeArray.indices, id: \.self) { index in
                    let times = returningTimeArray[index]
                    HStack {
                        Text("\(arrivalBusStopName)")
                            .padding(.trailing, 5)
                        Text("\(times[0]):\(String(format: "%02d", times[1]))")
                            .padding(.trailing, 5)
                        Text("→")
                            .padding(.trailing, 5)
                        Text("\(times[2]):\(String(format: "%02d", times[3]))")
                            .padding(.trailing, 5)
                        Text("\(departureBusStopName)")
                            .padding(.trailing, 5)
                    }
                    .padding([.leading, .trailing], 16)
                    .padding([.top, .bottom], 0)
                }
                
                Button(action: {
                    hideAllButton()
                    hideAllText()
                    showTimetableButton = true
                    showBusButton = true
                    showAlarmButton = true
                }) {
                    Text("戻る")
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
            }
            
            if showBusButton {
                Button(action: {
                    hideAllButton()
                    hideAllText()
                    
                    let allBusesSelected = daysOfWeek.allSatisfy { day in
                        selectedGoingBuses[day] != nil && selectedReturningBuses[day] != nil
                    }
                    if allBusesSelected {
                        showBusText = true
                    } else {
                        showSelectBusText = true
                    }
                }) {
                    Text("バスの選択")
                }
                .buttonStyle(CustomButtonStyle())
            }
            
            if showSelectBusText {
                Text("曜日ごとに乗るバスを選択してください。")
                    .padding()
                
                ForEach(daysOfWeek, id: \.self) { day in
                    VStack {
                        HStack  {
                            // Going Bus Picker
                            Picker(selection: Binding(
                                get: {
                                    // Check if there is a selected bus for the current day
                                    if let selectedBus = selectedGoingBuses[day] {
                                        // Find the index of the selected bus in the goingTimeArray
                                        if let index = goingTimeArray.firstIndex(where: { $0 == selectedBus }) {
                                            return index
                                        }
                                    }
                                    // If no selected bus or index found, return 0 (or any other default index)
                                    return 0
                                },
                                set: { newValue in
                                    // Set the selected bus for the current day based on the index
                                    selectedGoingBuses[day] = goingTimeArray[newValue]
                                }
                            )) {
                                ForEach(goingTimeArray.indices, id: \.self) { index in
                                    let times = goingTimeArray[index]
                                    Text(formatTime(times))
                                        .tag(index) // Tag with index instead of times
                                }
                            } label: {
                                Text("行きのバス選択 (\(day))")
                            }
                            .pickerStyle(MenuPickerStyle())

                            // Returning Bus Picker
                            Picker(selection: Binding(
                                get: {
                                    if let selectedBus = selectedReturningBuses[day] {
                                        if let index = returningTimeArray.firstIndex(where: { $0 == selectedBus }) {
                                            return index
                                        }
                                    }
                                    return 0
                                },
                                set: { newValue in
                                    selectedReturningBuses[day] = returningTimeArray[newValue]
                                }
                            )) {
                                ForEach(returningTimeArray.indices, id: \.self) { index in
                                    let times = returningTimeArray[index]
                                    Text(formatTime(times))
                                        .tag(index)
                                }
                            } label: {
                                Text("帰りのバス選択 (\(day))")
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
                Button(action: {
                    hideAllButton()
                    hideAllText()
                    showBusText = true
                }) {
                    Text("バスの選択を終了する。")
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
            }
            
            if showBusText {
                VStack {
                    Text("曜日ごと乗るバスはこちらです。")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    ForEach(daysOfWeek, id: \.self) { day in
                        if let goingBus = selectedGoingBuses[day] {
                            Text("\(day) 行きのバス: \(formatTime(goingBus))").padding(.bottom, 5)
                        }
                        if let returningBus = selectedReturningBuses[day] {
                            Text("\(day) 帰りのバス: \(formatTime(returningBus))").padding(.bottom, 5)
                        }
                    }
                    
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showTimetableButton = true
                        showBusButton = true
                        showAlarmButton = true
                    }) {
                        Text("戻る")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
            }
            
            if showAlarmButton {
                Button(action: {
                    hideAllButton()
                    hideAllText()
                    showSetAlarmText = true
                }) {
                    Text("徒歩時間の設定")
                }
                .buttonStyle(CustomButtonStyle())
            }
            
            if showSetAlarmText {
                Text("出発時刻の何分前にアラームを鳴らすか設定してください。")
                    .padding()
                
                HStack {
                    TextField("", value: $travelTimeToBusStop, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("分前")
                        .padding(.trailing, 5)
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 0)
                
                HStack {
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showAlarmText = true
                    }) {
                        Text("確定")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    
                    Button(action: {
                        hideAllButton()
                        hideAllText()
                        showTimetableButton = true
                        showBusButton = true
                        showAlarmButton = true
                    }) {
                        Text("戻る")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
            }
            
            if showAlarmText {
                if let timeUntilNextAlarm = calculateTimeUntilNextAlarm() {
                    let hours = timeUntilNextAlarm.hours
                    let minutes = timeUntilNextAlarm.minutes
                    Text("次のアラームは \(hours) 時間 \(minutes) 分後です。")
                        .padding()
                } else {
                    Text("次のアラームが見つかりませんでした。")
                        .padding()
                }
                
                Button(action: {
                    hideAllButton()
                    hideAllText()
                    showTimetableButton = true
                    showBusButton = true
                    showAlarmButton = true
                }) {
                    Text("戻る")
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
            }
        }
        .padding()
    }
    
    
    func formatTime(_ times: [Int]) -> String {
        let departureTime = String(format: "%02d:%02d", times[0], times[1])
        let arrivalTime = String(format: "%02d:%02d", times[2], times[3])
        return "\(departureTime) → \(arrivalTime)"
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .font(.largeTitle)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
