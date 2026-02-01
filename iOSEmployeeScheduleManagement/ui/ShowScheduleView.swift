//
//  ShowScheduleScreen.swift
//  iOSEmployeeScheduleManagement
//
//  Created by Mac Pro on 1/30/26.
//

import SwiftUI

struct ShowScheduleView: View {
    var noOfEmployees:Int = 0
    var scheduleMap = [String: [String: String]]()
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Total no of employees: \(noOfEmployees)")
                
                List(DayOfWeek.allCases, id: \.self) { day in
                    ScheduleItemView(
                        day: day.rawValue,
                        shiftMap: scheduleMap[day.rawValue]!
                    )
                }
                
            }
            }.navigationBarTitle(Text("Show Schedule"), displayMode: .inline)
        }
    }
    
    struct ScheduleItemView: View {
        let day: String
        var shiftMap = [String: String]()
        
        var body: some View {
            VStack(alignment: .leading){
                Text(day).fontWeight(.bold).font(.title2)
                ForEach(Shifts.allCases.dropFirst(), id: \.self) { shift in
                    HStack{
                        Text("\(shift.rawValue)")
                        Spacer()
                        Text(shiftMap[shift.rawValue] ?? "No Employee Available")
                    }.padding(2)
                }
            }
        }
    }
    
    #Preview {
        ShowScheduleView()
    }
