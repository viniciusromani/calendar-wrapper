import Foundation

extension Date {
    func isSameDay(of date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
    
    func isAfter(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedDescending
    }
    
    func isBefore(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
    }
    
    func isInBetween(beginDate: Date, endDate: Date) -> Bool {
        return isAfter(date: beginDate) && isBefore(date: endDate)
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
}
