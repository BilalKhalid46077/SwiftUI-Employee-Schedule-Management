//
//  let.swift
//  iOSEmployeeScheduleManagement
//
//  Created by Mac Pro on 2/1/26.
//



func getSchedule(scheduleList: inout [ScheduleModel]) -> [String: [String: String]] {
    var dayMap = [String: [String: String]]()
    
    // Get all days from the Days enum
    let days = DayOfWeek.allCases.map { String(describing: $0) }
    let shifts = Shifts.allCases.map { String(describing: $0) }.filter { $0 != Shifts.Off.rawValue }
    
    for day in days {
        var shiftMap = [String: String]()
        
        for shift in shifts {
            var names = ""
            
            // Filter employees already assigned to this day and shift
            let currentShiftEmployees = scheduleList.filter {
                $0.scheduleMap[day] == shift
            }.map { $0.employeeName }
            
            if !currentShiftEmployees.isEmpty {
                // Take up to 2 employees
                let initialNames = currentShiftEmployees.prefix(2)
                names = initialNames.joined(separator: ", ")
                
                if currentShiftEmployees.count < 2 {
                    // Pick an employee who isn't at capacity (5 days) and isn't working today
                    if let backupIndex = scheduleList.firstIndex(where: {
                        $0.scheduleMap.count < 5 &&
                        $0.scheduleMap[day] == nil &&
                        !currentShiftEmployees.contains($0.employeeName)
                    }) {
                        scheduleList[backupIndex].scheduleMap[day] = shift
                        names += ", \(scheduleList[backupIndex].employeeName)"
                    }
                } else if currentShiftEmployees.count > 2 {
                    // Conflict resolution: remove extra employees from this shift
                    let extras = currentShiftEmployees.dropFirst(2)
                    for extraName in extras {
                        if let extraIndex = scheduleList.firstIndex(where: { $0.employeeName == extraName }) {
                            scheduleList[extraIndex].scheduleMap.removeValue(forKey: day)
                        }
                    }
                }
            } else {
                // No employees assigned to this shift: find two available
                let availableEmployees = scheduleList.enumerated().filter { (index, employee) in
                    employee.scheduleMap.count < 5 && employee.scheduleMap[day] == nil
                }.prefix(2)
                
                var pickedNames: [String] = []
                for (index, _) in availableEmployees {
                    scheduleList[index].scheduleMap[day] = shift
                    pickedNames.append(scheduleList[index].employeeName)
                }
                names = pickedNames.isEmpty ? "No Employee Available" : pickedNames.joined(separator: ", ")
            }
            
            shiftMap[shift] = names.isEmpty ? "No Employee Available" : names
        }
        dayMap[day] = shiftMap
    }
    
    return dayMap
}
