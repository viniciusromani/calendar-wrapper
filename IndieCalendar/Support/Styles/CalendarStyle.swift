import RxSwift
import SwiftDate
import UIKit

protocol CalendarSelectionManipulation {
    associatedtype T
    var selectedPeriodSubject: PublishSubject<T> { get set }
    var alreadySelectedDates: [Date] { get set }
    
    init(alreadySelectedDates: [Date])
    
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
        let firstEqualDate = alreadySelectedDates.first { date.isDateEqual(to: $0) }
        return firstEqualDate != nil
    }
}

typealias SelectedCalendarPeriod = (beginDate: Date?, endDate: Date?)
struct RangedCalendarSelection: CalendarSelectionManipulation {
    typealias T = SelectedCalendarPeriod
    var alreadySelectedDates: [Date] = []
    var selectedPeriodSubject: PublishSubject<SelectedCalendarPeriod> = PublishSubject<SelectedCalendarPeriod>()
    
    private var firstDate: Date?
    private var lastDate: Date?
    
    init(alreadySelectedDates: [Date]) {
        self.alreadySelectedDates = alreadySelectedDates
    }
    
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
        guard date.isToday || date.isAfterToday() else {
            return .none(cellStyle: cellStyles.disabledStyle)
        }
        
        guard !isDateAlreadySelected(date) else {
            return .only(cellStyle: cellStyles.selectedStyle)
        }
        
        if firstDate == nil {
            return .none(cellStyle: cellStyles.disabledStyle)
        }
        
        if let firstDate = self.firstDate, lastDate == nil {
            guard !date.isSameDay(of: firstDate) else {
                return .only(cellStyle: cellStyles.selectionStyle)
            }
            
            guard let selectionMode = self.getCellSelectionModeWithFirstDate(for: date, using: cellStyles) else {
                return .only(cellStyle: cellStyles.selectedStyle)
            }
            
            return selectionMode
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
extension RangedCalendarSelection {
    private func getCellSelectionModeWithFirstDate(for currentDate: Date,
                                                   using styles: CalendarCellStyles) -> CalendarCellSelectionMode? {
        
        guard let firstDate = self.firstDate else {
            return nil
        }
        
        let sorted = alreadySelectedDates.sorted { $0 < $1 }
        
        let immediatelyBefore = firstDate.getImmediatelyBeforeDate(in: alreadySelectedDates) ?? sorted.first
        let immediatelyAfter = firstDate.getImmediatelyAfterDate(in: alreadySelectedDates) ?? sorted.last
        
        guard let selectedFirst = immediatelyBefore, let selectedLast = immediatelyAfter else {
            return nil
        }
        
        if firstDate.isBefore(date: selectedFirst) {
            let previous = self.getCellSelectionMode(forPrevious: currentDate, using: styles)
            return previous
        }
        
        if firstDate.isInBetween(beginDate: selectedFirst, endDate: selectedLast) {
            let inBetween = self.getCellSelectionMode(forInBetween: currentDate, using: styles)
            return inBetween
        }
        
        if firstDate.isAfter(date: selectedLast) {
            let next = self.getCellSelectionMode(forNext: currentDate, using: styles)
            return next
        }
        
        return nil
    }
    
    private func getCellSelectionMode(forPrevious currentDate: Date,
                                      using styles: CalendarCellStyles) -> CalendarCellSelectionMode? {
        let sorted = alreadySelectedDates.sorted { $0 < $1 }
        guard let selectedFirst = sorted.first,
              let selectedLast = sorted.last else {
                return nil
        }
        
        if currentDate.isBefore(date: selectedFirst) {
            return .only(cellStyle: styles.enabledStyle)
        }
        if currentDate.isAfter(date: selectedLast) {
            return .only(cellStyle: styles.selectedStyle)
        }
        
        return nil
    }
    
    private func getCellSelectionMode(forInBetween currentDate: Date,
                                      using styles: CalendarCellStyles) -> CalendarCellSelectionMode? {
        
        guard let firstDate = self.firstDate,
              let selectedFirst = firstDate.getImmediatelyBeforeDate(in: alreadySelectedDates),
              let selectedLast = firstDate.getImmediatelyAfterDate(in: alreadySelectedDates) else {
                return nil
        }
        
        if currentDate.isAfter(date: selectedFirst) {
            return .only(cellStyle: styles.enabledStyle)
        }
        if currentDate.isBefore(date: selectedLast) {
            return .only(cellStyle: styles.selectedStyle)
        }
        
        return nil
    }
    
    private func getCellSelectionMode(forNext currentDate: Date,
                                      using styles: CalendarCellStyles) -> CalendarCellSelectionMode? {
        let sorted = alreadySelectedDates.sorted { $0 < $1 }
        guard let selectedFirst = sorted.first, let selectedLast = sorted.last else {
            return nil
        }
        
        if currentDate.isBefore(date: selectedFirst) {
            return .only(cellStyle: styles.selectedStyle)
        }
        if currentDate.isAfter(date: selectedLast) {
            return .only(cellStyle: styles.enabledStyle)
        }
        
        return nil
    }
}
struct SingledCalendarSelection: CalendarSelectionManipulation {
    typealias T = [Date]
    var alreadySelectedDates: [Date]
    var selectedPeriodSubject: PublishSubject<[Date]> = PublishSubject<[Date]>()
    
    private var selectedDates: [Date] = []
    
    init(alreadySelectedDates: [Date]) {
        self.alreadySelectedDates = alreadySelectedDates
    }
    
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
    var alreadySelectedDates: [Date] { get set }
    var numberOfRows: Int { get }
    
    init(alreadySelectedDates: [Date])
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
    var alreadySelectedDates: [Date]
    lazy var selectionManipulation: SingledCalendarSelection = SingledCalendarSelection(alreadySelectedDates: self.alreadySelectedDates)
    var numberOfRows: Int = 6
    
    required init(alreadySelectedDates: [Date]) {
        self.alreadySelectedDates = alreadySelectedDates
    }
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
    var alreadySelectedDates: [Date]
    lazy var selectionManipulation: RangedCalendarSelection = RangedCalendarSelection(alreadySelectedDates: self.alreadySelectedDates)
    var numberOfRows: Int = 6
    
    required init(alreadySelectedDates: [Date]) {
        self.alreadySelectedDates = alreadySelectedDates
    }
}
