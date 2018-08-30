import RxSwift
import SwiftDate
import UIKit

protocol CalendarSelectionManipulation {
    associatedtype T
    var selectedPeriodSubject: PublishSubject<T> { get set }
    var alreadySelectedDates: [Date] { get }
    
    mutating func manipulateDateClick(_ date: Date)
    func getCellSelectionMode(for date: Date, using cellStyles: CalendarCellStyles) -> CalendarCellSelectionMode
    func triggerSubject()
    func selectedPeriodObservable() -> Observable<T>
}
extension CalendarSelectionManipulation {
    func manipulateDateClick(_ date: Date) { }
    func getCellSelectionMode(for date: Date, using cellStyles: CalendarCellStyles) -> CalendarCellSelectionMode {
        return .none(cellStyle: cellStyles.disabledStyle)
    }
    func triggerSubject() { }
    func selectedPeriodObservable() -> Observable<T> {
        return self.selectedPeriodSubject
    }
    
    internal func isDateAlreadySelected(_ date: Date) -> Bool {
        let isAlreadySelected = alreadySelectedDates.map { alreadySelectedDate -> Bool in
            return date.isDateEqual(to: alreadySelectedDate)
            }.first ?? false
        
        return isAlreadySelected
    }
}

typealias SelectedCalendarPeriod = (beginDate: Date?, endDate: Date?)
struct RangedCalendarSelection: CalendarSelectionManipulation {
    typealias T = SelectedCalendarPeriod
    var alreadySelectedDates: [Date] = [Date()]
    var selectedPeriodSubject: PublishSubject<SelectedCalendarPeriod> = PublishSubject<SelectedCalendarPeriod>()
    
    private var firstDate: Date?
    private var lastDate: Date?
    
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
        guard !isDateAlreadySelected(date) else {
            return .only(cellStyle: cellStyles.selectedStyle)
        }
        
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
    
    func triggerSubject() {
        let period: SelectedCalendarPeriod = (beginDate: self.firstDate, endDate: self.lastDate)
        self.selectedPeriodSubject.on(.next(period))
    }
}
struct SingledCalendarSelection: CalendarSelectionManipulation {
    typealias T = [Date]
    var alreadySelectedDates: [Date] = [Date()]
    var selectedPeriodSubject: PublishSubject<[Date]> = PublishSubject<[Date]>()
    
    private var selectedDates: [Date] = []
    
    mutating func manipulateDateClick(_ date: Date) {
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
        guard !isDateAlreadySelected(date) else {
            return .only(cellStyle: cellStyles.selectedStyle)
        }
        
        guard selectedDates.contains(date) else {
            return .none(cellStyle: cellStyles.enabledStyle)
        }
        
        return .only(cellStyle: cellStyles.selectionStyle)
    }
    
    func triggerSubject() {
        self.selectedPeriodSubject.on(.next(self.selectedDates))
    }
}



protocol CalendarStyle: class {
    associatedtype SelectionManipulation: CalendarSelectionManipulation
    var scrollDirection: UICollectionViewScrollDirection { get }
    var cellStyles: CalendarCellStyles { get }
    var selectionManipulation: SelectionManipulation { get }
}
protocol CalendarCellStyles {
    var enabledStyle: CalendarCellStyle { get }
    var disabledStyle: CalendarCellStyle { get }
    var selectionStyle: CalendarCellStyle { get }
    var selectedStyle: CalendarCellStyle { get }
}


struct UnavailabilityCellStyles: CalendarCellStyles {
    var enabledStyle: CalendarCellStyle = UnavailabilityCalendarCellEnabledStyle()
    var disabledStyle: CalendarCellStyle = UnavailabilityCalendarCellDisabledStyle()
    var selectionStyle: CalendarCellStyle = UnavailabilityCalendarCellSelectionStyle()
    var selectedStyle: CalendarCellStyle = UnavailabilityCalendarCellSelectedStyle()
}
class UnavailabilityCalendarStyle: CalendarStyle {
    typealias SelectionManipulation = SingledCalendarSelection
    var scrollDirection: UICollectionViewScrollDirection = .horizontal
    var cellStyles: CalendarCellStyles = UnavailabilityCellStyles()
    var selectionManipulation: SingledCalendarSelection = SingledCalendarSelection()
}


struct CheckInCellStyles: CalendarCellStyles {
    var enabledStyle: CalendarCellStyle = CheckInCalendarCellEnabledStyle()
    var disabledStyle: CalendarCellStyle = CheckInCalendarCellDisabledStyle()
    var selectionStyle: CalendarCellStyle = CheckInCalendarCellSelectionStyle()
    var selectedStyle: CalendarCellStyle = CheckInCalendarCellSelectedStyle()
}
class CheckInCalendarStyle: CalendarStyle {
    typealias SelectionManipulation = RangedCalendarSelection
    var scrollDirection: UICollectionViewScrollDirection = .horizontal
    var cellStyles: CalendarCellStyles = CheckInCellStyles()
    var selectionManipulation: RangedCalendarSelection = RangedCalendarSelection()
}
