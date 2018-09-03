import SwiftDate
import Foundation

extension Date {
    func isBeforeToday() -> Bool {
        let calendar = Calendar.current
        let todayComponents = (calendar as NSCalendar).components([.year, .month, .day], from: Date())
        let today = calendar.date(from: todayComponents)!
        
        let otherDayComponents = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        let otherDay = calendar.date(from: otherDayComponents)!
        
        switch today.compare(otherDay) {
        case .orderedDescending:
            return true
        default:
            return false
        }
    }
    
    func isAfterToday() -> Bool {
        let calendar = Calendar.current
        let todayComponents = (calendar as NSCalendar).components([.year, .month, .day], from: Date())
        let today = calendar.date(from: todayComponents)!
        
        let otherDayComponents = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        let otherDay = calendar.date(from: otherDayComponents)!
        
        switch today.compare(otherDay) {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    
    func isBefore(date: Date) -> Bool {
        let calendar = Calendar.current
        let selfComponents = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        let selfDate = calendar.date(from: selfComponents)!
        
        let otherDateComponents = (calendar as NSCalendar).components([.year, .month, .day], from: date)
        let otherDate = calendar.date(from: otherDateComponents)!
        
        switch selfDate.compare(otherDate) {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    
    func isAfter(date: Date) -> Bool {
        let calendar = Calendar.current
        let selfComponents = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        let selfDate = calendar.date(from: selfComponents)!
        
        let otherDateComponents = (calendar as NSCalendar).components([.year, .month, .day], from: date)
        let otherDate = calendar.date(from: otherDateComponents)!
        
        switch selfDate.compare(otherDate) {
        case .orderedDescending:
            return true
        default:
            return false
        }
    }
    
    func isInBetween(beginDate: Date, endDate: Date) -> Bool {
        let selfDateInRegion = DateInRegion(self, region: .current)
        let beginDateInRegion = DateInRegion(beginDate, region: .current)
        let endDateInRegion = DateInRegion(endDate, region: .current)
        
        let timePeriod = TimePeriod(start: beginDateInRegion, end: endDateInRegion)
        return timePeriod.contains(date: selfDateInRegion)
    }
    
    func getImmediatelyBeforeDate(in sequence: Array<Date>) -> Date? {
        let before = sequence.filter { $0.isBefore(date: self) }.last
        return before
    }
    
    func getImmediatelyAfterDate(in sequence: Array<Date>) -> Date? {
        let after = sequence.filter { $0.isAfter(date: self) }.first
        return after
    }
    
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
        
        var periods: [SelectedCalendarPeriod] = []
        var currentPeriod: SelectedCalendarPeriod = (beginDate: nil, endDate: nil)
        
        let sorted = self.sorted { $0 < $1 }
        
        for (index, date) in sorted.enumerated() {
            
            if currentPeriod.beginDate == nil {
                currentPeriod.beginDate = date
                currentPeriod.endDate = date
                
                periods = self.addPeriodIfNeeded(currentIndex: index, currentPeriod, at: periods)
                continue
            } else {
                if date.day == currentPeriod.endDate!.day + 1 {
                    currentPeriod.endDate = date
                    periods = self.addPeriodIfNeeded(currentIndex: index, currentPeriod, at: periods)
                } else {
                    currentPeriod = resolveEndDateIfNeeded(in: currentPeriod)
                    
                    periods.append(currentPeriod)
                    
                    currentPeriod.beginDate = date
                    currentPeriod.endDate = date
                    
                    periods = self.addPeriodIfNeeded(currentIndex: index, currentPeriod, at: periods)
                }
            }
        }
        
        return periods
    }
    
    private func addPeriodIfNeeded(currentIndex index: Int,
                                   _ period: SelectedCalendarPeriod,
                                   at periods: [SelectedCalendarPeriod]) -> [SelectedCalendarPeriod] {
        var finalPeriods = periods
        
        if index == self.count - 1 {
            let treatedPeriod = resolveEndDateIfNeeded(in: period)
            finalPeriods.append(treatedPeriod)
        }
        
        return finalPeriods
    }
    
    private func resolveEndDateIfNeeded(in period: SelectedCalendarPeriod) -> SelectedCalendarPeriod {
        var current = period
        
        guard let begin = period.beginDate,
              let end = period.endDate else {
                return period
        }
        
        if begin.day == end.day {
            let treatedEnd = end + 1.minutes
            current.endDate = treatedEnd
        }
        
        return current
    }
}

extension Array where Element == SelectedCalendarPeriod {
    func extractDates() -> [Date] {
        var dates: [Date] = []
        
        for period in self {
            let periodDates = getDates(from: period)
            dates.append(contentsOf: periodDates)
        }
        
        return dates
    }
    
//    func extractSwiftDateTimePeriods() -> [TimePeriod] {
//        return self.compactMap { period -> TimePeriod? in
//            guard let beginDate = period.beginDate, let endDate = period.endDate else {
//                return nil
//            }
//            
//            let start = DateInRegion(beginDate, region: .current)
//            let end = DateInRegion(endDate, region: .current)
//            return TimePeriod(start: start, end: end)
//        }
//    }
    
    func getDates(from period: SelectedCalendarPeriod) -> [Date] {
        guard let begin = period.beginDate,
              let end = period.endDate else {
                return []
        }
        
        var dates: [Date] = []
        var currentDate = begin
        
        guard !currentDate.isDateEqual(to: end) else {
            return [currentDate]
        }
        
        while !currentDate.isDateEqual(to: end) {
            dates.append(currentDate)
            currentDate = currentDate + 1.days
        }
        
        dates.append(currentDate)
        
        return dates
    }
}





