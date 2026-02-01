//
//  AddScheduleScreen.swift
//  iOSEmployeeScheduleManagement
//
//  Created by Mac Pro on 1/30/26.
//

import SwiftUI

struct AddScheduleView: View {
    @State private var employeeName: String = ""
    @State private var scheduleMap = [String: String]()
    @State private var scheduleList: [ScheduleModel] = []
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Add Schedule").fontWeight(.semibold)
                HStack {
                    Text("Employee Name")
                    TextField("Enter name",
                              text: $employeeName
                    ).padding().textFieldStyle(.roundedBorder)
                }.padding()
                List(DayOfWeek.allCases, id: \.self) { day in
                    AddShiftView(
                        day: day.rawValue,
                        onShiftSelect:  { shift in
                            scheduleMap[day.rawValue] = shift // Add value
                        }
                    )
                } .id(refreshID)
                
                Button("Add Schedule") {
                    // Add Schedule In List
                    if(!employeeName.isEmpty
                       && scheduleMap.count < 6
                    ){
                        scheduleList.append(
                            ScheduleModel(employeeName:employeeName, scheduleMap: scheduleMap
                                         )
                        )
                        scheduleMap.removeAll()
                        employeeName = ""
                        self.refreshID = UUID()
                    }
                }.padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    
                    NavigationLink(destination: ShowScheduleView(
                        noOfEmployees: scheduleList.count,
                        scheduleMap: getSchedule(scheduleList: &scheduleList)
                    )
                                   
                    ) {
                        // Go to Schedule Screen
                        Text("Show Schedule")
                    }.padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Spacer()
            }
        }
    }
}

struct AddShiftView: View {
    let day: String
    @State private var selectedOption = Shifts.allCases[0].rawValue
    let onShiftSelect: (String) -> Void
    
    var body: some View {
        HStack{
            Text(day).fontWeight(.bold)
            Spacer()
            Picker("", selection: $selectedOption) {
                ForEach(Shifts.allCases, id: \.self) { shift in
                    Text(shift.rawValue).tag(shift.rawValue)
                }
            }
            .onChange(of: selectedOption) { oldValue, newValue in
                onShiftSelect(newValue)
            }
            .pickerStyle(.menu)
        }.padding(5)
    }
}


#Preview {
    AddScheduleView()
}
