import RxSwift
import SwiftDate
import UIKit

protocol CalendarSelectionManipulation {
    var selectedPeriodSubject: PublishSubject<SelectedCalendarPeriod> { get set }
    
    mutating func manipulateDateClick(_ date: Date)
    func getCellSelectionMode(for date: Date, using cellStyles: CalendarCellStyles) -> CalendarCellSelectionMode
    func triggerSubject(onDate date: Date)
    func selectedPeriodObservable() -> Observable<SelectedCalendarPeriod>
}
extension CalendarSelectionManipulation {
    func manipulateDateClick(_ date: Date) { }
    func getCellSelectionMode(for date: Date, using cellStyles: CalendarCellStyles) -> CalendarCellSelectionMode {
        return .none(cellStyle: cellStyles.disabledStyle)
    }
    func triggerSubject(onDate date: Date) { }
    func selectedPeriodObservable() -> Observable<SelectedCalendarPeriod> {
        return self.selectedPeriodSubject
    }
}

struct RangedCalendarSelection: CalendarSelectionManipulation {
    private var firstDate: Date?
    private var lastDate: Date?
    var selectedPeriodSubject: PublishSubject<SelectedCalendarPeriod> = PublishSubject<SelectedCalendarPeriod>()
    
    mutating func manipulateDateClick(_ date: Date) {
        // first click
        if firstDate == nil {
            self.firstDate = date
            return
        }
        
        // third click
        if firstDate != nil, lastDate != nil {
            self.firstDate = date
            self.lastDate = nil
            return
        }
        
        // second click
        let otherDate = (self.firstDate as NSDate?)?.copy() as? Date
        self.firstDate = min(otherDate!, date)
        self.lastDate = max(otherDate!, date)
    }
    
    func getCellSelectionMode(for date: Date, using cellStyles: CalendarCellStyles) -> CalendarCellSelectionMode {
        if firstDate == nil {
            return .none(cellStyle: cellStyles.disabledStyle)
        }
        
        if let firstDate = self.firstDate, lastDate == nil, date.isSameDay(of: firstDate) {
            return .only(cellStyle: cellStyles.selectionStyle)
        }
        
        if let firstDate = self.firstDate, let lastDate = self.lastDate {
            if date.isSameDay(of: firstDate) {
                return .begin(cellStyle: cellStyles.selectionStyle)
            } else if date.isSameDay(of: lastDate) {
                return .end(cellStyle: cellStyles.selectionStyle)
            } else if date.isDayInBetween(beginDate: firstDate, endDate: lastDate) {
                return .medium(cellStyle: cellStyles.selectionStyle)
            } else {
                return .none(cellStyle: cellStyles.disabledStyle)
            }
        }
        
        return .none(cellStyle: cellStyles.enabledStyle)
    }
    
    func triggerSubject(onDate date: Date) {
        let period: SelectedCalendarPeriod = (beginDate: self.firstDate, endDate: self.lastDate)
        self.selectedPeriodSubject.on(.next(period))
    }
}
struct SingledCalendarSelection: CalendarSelectionManipulation {
    private var currentSelectedDate: Date?
    private var selectedDates: [Date] = []
    var selectedPeriodSubject: PublishSubject<SelectedCalendarPeriod> = PublishSubject<SelectedCalendarPeriod>()
    
    mutating func manipulateDateClick(_ date: Date) {
        self.currentSelectedDate = date
        
        guard !selectedDates.contains(date) else {
            self.removeDateFromDataSource(date)
            return
        }
        
        self.selectedDates.append(date)
    }
    
    private mutating func removeDateFromDataSource(_ date: Date) {
        guard let index = self.selectedDates.index(of: date) else {
            return
        }
        self.selectedDates.remove(at: index)
    }
    
    func getCellSelectionMode(for date: Date, using cellStyles: CalendarCellStyles) -> CalendarCellSelectionMode {
        guard selectedDates.contains(date) else {
            return .none(cellStyle: cellStyles.enabledStyle)
        }
        
        return .only(cellStyle: cellStyles.selectionStyle)
    }
    
    func triggerSubject(onDate date: Date) {
        guard selectedDates.contains(date) else {
            return
        }
        
        let period: SelectedCalendarPeriod = (beginDate: date, endDate: nil)
        self.selectedPeriodSubject.on(.next(period))
    }
}



protocol CalendarStyle {
    var scrollDirection: UICollectionViewScrollDirection { get }
    var cellStyles: CalendarCellStyles { get }
    var selectionManipulation: CalendarSelectionManipulation { get }
}

protocol CalendarCellStyles {
    var enabledStyle: CalendarCellStyle { get }
    var disabledStyle: CalendarCellStyle { get }
    var selectionStyle: CalendarCellStyle { get }
}


struct UnavailabilityCellStyles: CalendarCellStyles {
    var enabledStyle: CalendarCellStyle = UnavailabilityCalendarCellEnabledStyle()
    var disabledStyle: CalendarCellStyle = UnavailabilityCalendarCellDisabledStyle()
    var selectionStyle: CalendarCellStyle = UnavailabilityCalendarCellSelectionStyle()
}

struct UnavailabilityCalendarStyle: CalendarStyle {
    var scrollDirection: UICollectionViewScrollDirection = .horizontal
    var cellStyles: CalendarCellStyles = UnavailabilityCellStyles()
    var selectionManipulation: CalendarSelectionManipulation = SingledCalendarSelection()
}


struct CheckInCellStyles: CalendarCellStyles {
    var enabledStyle: CalendarCellStyle = CheckInCalendarCellEnabledStyle()
    var disabledStyle: CalendarCellStyle = CheckInCalendarCellDisabledStyle()
    var selectionStyle: CalendarCellStyle = CheckInCalendarCellSelectionStyle()
}

struct CheckInCalendarStyle: CalendarStyle {
    var scrollDirection: UICollectionViewScrollDirection = .horizontal
    var cellStyles: CalendarCellStyles = CheckInCellStyles()
    var selectionManipulation: CalendarSelectionManipulation = RangedCalendarSelection()
}
