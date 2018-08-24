import Foundation

extension Date {
    func isSameDay(of date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
    
    func isDayAfter(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedDescending
    }
    
    func isDayBefore(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
    }
    
    func isDayInBetween(beginDate: Date, endDate: Date) -> Bool {
        return isDayAfter(date: beginDate) && isDayBefore(date: endDate)
    }
    
    func isSameMonth(of date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .month) == .orderedSame
    }
    
    func isMonthAfter(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .month) == .orderedDescending
    }
    
    func isMonthBefore(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .month) == .orderedAscending
    }
    
    func isMonthInBetween(beginDate: Date, endDate: Date) -> Bool {
        return isMonthAfter(date: beginDate) && isMonthBefore(date: endDate)
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
}
