import JTAppleCalendar
import RxSwift
import SnapKit
import SwiftDate

class CalendarView<Style: CalendarStyle>: UIView {
    let calendarView = JTAppleCalendarView()
    
    var beginCalendarDate: Date
    var endCalendarDate: Date
    
    // control variables
    let calendarStyle: Style
    private var cellStyles: CalendarCellStyles!
    private var selectionManipulation: Style.SelectionManipulation!
    
    private let scrolledDateSubject = BehaviorSubject<Date>(value: Date())
    
    init(beginCalendarDate: Date = Date(),
         endCalendarDate: Date = Date() + 1.years,
         calendarStyle: Style) {
        self.calendarStyle = calendarStyle
        self.cellStyles = calendarStyle.cellStyles
        self.selectionManipulation = calendarStyle.selectionManipulation
        self.beginCalendarDate = beginCalendarDate
        self.endCalendarDate = endCalendarDate
        super.init(frame: .zero)
        self.buildView()
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDates() {
        calendarView.reloadData()
    }
    
    private func buildView() {
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(self.calendarView)
    }
    
    private func formatViews() {
        self.backgroundColor = .clear
        
        self.calendarView.backgroundColor = .clear
        self.calendarView.showsVerticalScrollIndicator = false
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.scrollDirection = self.calendarStyle.scrollDirection
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        self.calendarView.calendarDataSource = self
        self.calendarView.calendarDelegate = self
        self.calendarView.reloadData()
    }
    
    private func addConstraintsToSubviews() {
        calendarView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }
}

extension CalendarView: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let configuration = ConfigurationParameters(startDate: self.beginCalendarDate,
                                                    endDate: self.endCalendarDate,
                                                    numberOfRows: self.calendarStyle.numberOfRows,
                                                    calendar: Calendar(identifier: .gregorian),
                                                    generateInDates: .forAllMonths,
                                                    generateOutDates: .tillEndOfGrid,
                                                    firstDayOfWeek: .monday)
        return configuration
    }
}

extension CalendarView: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let calendarCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "", for: indexPath)
        }
        
        switch cellState.dateBelongsTo {
        case .thisMonth:
            let isAfterToday = date.isToday || date.isAfterToday()
            let style: CalendarCellStyle = isAfterToday ?
                self.cellStyles.enabledStyle:
                self.cellStyles.disabledStyle
            
            calendarCell.setDay(with: date)
            calendarCell.applyStyle(style)
        default:
            calendarCell.setDay(with: nil)
            calendarCell.removeStyle()
        }
        
        self.calendar(calendar, willDisplay: calendarCell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return calendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let calendarCell = cell as? CalendarCell else {
            return
        }
        
        switch cellState.dateBelongsTo {
        case .thisMonth:
            let selectionMode = self.selectionManipulation.getCellSelectionMode(for: date, using: self.cellStyles)
            calendarCell.setSelection(mode: selectionMode)
        default: break
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        switch cellState.dateBelongsTo {
        case .thisMonth:
            self.selectionManipulation.manipulateDateClick(date)
            self.selectionManipulation.triggerSubject()
            self.calendarView.reloadData()
        default: break
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date ?? Date()
        
        guard date < self.endCalendarDate else {
            return
        }
        
        self.scrolledDateSubject.on(.next(date))
    }
}

// Helpers

extension CalendarView {
    
    func scrolledDateObservable() -> Observable<Date> {
        return self.scrolledDateSubject
    }
    
    func insertAlreadySelectedDates(_ dates: [Date]) {
        self.selectionManipulation.alreadySelectedDates = dates
        self.calendarView.reloadDates(dates)
    }
}

