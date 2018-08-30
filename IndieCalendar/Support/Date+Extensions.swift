import SwiftDate
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
    
    func isSameYear(of date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .year) == .orderedSame
    }
    
    func isYearAfter(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .year) == .orderedDescending
    }
    
    func isYearBefore(date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .year) == .orderedAscending
    }
    
    func isYearInBetween(beginDate: Date, endDate: Date) -> Bool {
        return isMonthAfter(date: beginDate) && isMonthBefore(date: endDate)
    }
    
    func isDateEqual(to date: Date) -> Bool {
        return self.isSameDay(of: date)
            && self.isSameMonth(of: date)
            && self.isSameYear(of: date)
    }
    
    func isDateInBetween(beginDate: Date, endDate: Date) -> Bool {
        return self.isDayInBetween(beginDate: beginDate, endDate: endDate)
            && (self.isSameMonth(of: beginDate) || self.isSameMonth(of: endDate))
            && (self.isSameYear(of: beginDate) || self.isSameYear(of: endDate))
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
}

extension Array where Element == Date {
    func extractPeriods() -> [SelectedCalendarPeriod] {
        
        
        for date in self {
            
            let y = self.first { date.day == $0.day + 1 }
            
            
            
            
            print("tchau")
        }
    
        
        print("oi")
        return []
    }
    
    private func findPeriods() {
        let x = self.filter { $0.day == $0.day + 1 }
        
    }
}
