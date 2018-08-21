import SnapKit
import JTAppleCalendar

enum CalendarCellSelectionMode {
    case begin(cellStyle: CalendarCellStyle)
    case end(cellStyle: CalendarCellStyle)
    case medium(cellStyle: CalendarCellStyle)
    case only(cellStyle: CalendarCellStyle)
    case none(cellStyle: CalendarCellStyle)
}

class CalendarCell: JTAppleCell {
    
    private let dayNumber = UILabel()
    private let dayFormater = DateFormatter()
    private var defaultBackgroundColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        self.dayFormater.dateFormat = "d"
        
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }
    
    private func addSubviews() {
        self.addSubview(self.dayNumber)
    }
    
    private func formatViews() {
        self.dayNumber.textAlignment = .center
        self.dayNumber.clipsToBounds = true
    }
    
    private func addConstraintsToSubviews() {
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        dayNumber.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
    
    private func updateMode(_ mode: CalendarCellSelectionMode) {
        switch mode {
        case .none:
            self.dayNumber.backgroundColor = self.defaultBackgroundColor
        case .begin(let cellStyle):
            self.applyStyle(cellStyle)
        case .end(let cellStyle):
            self.applyStyle(cellStyle)
        case .only(let cellStyle):
            self.applyStyle(cellStyle)
        case .medium(let cellStyle):
            self.applyStyle(cellStyle)
        }
    }
    
    func setSelection(mode: CalendarCellSelectionMode) {
        self.updateMode(mode)
    }
    
    func applyStyle(_ style: CalendarCellStyle, shouldInteract: Bool = true) {
        self.isUserInteractionEnabled = shouldInteract
        
        self.dayNumber.font = style.font
        self.dayNumber.textColor = style.textColor
        self.dayNumber.layer.borderWidth = style.borderWidth
        self.dayNumber.layer.borderColor = style.borderColor.cgColor
        self.dayNumber.layer.cornerRadius = style.cornerRadius
        self.dayNumber.backgroundColor = style.backgroundColor
        self.dayNumber.attributedText = NSAttributedString(string: self.dayNumber.text ?? "", attributes: style.textAttributes)
        self.defaultBackgroundColor = style.backgroundColor
        
        self.dayNumber.snp.makeConstraints { make in
            make.width.height.equalTo(style.height - 5)
        }
    }
    
    func removeStyle() {
        self.isUserInteractionEnabled = false
        
        self.dayNumber.backgroundColor = .clear
        self.dayNumber.layer.borderColor = UIColor.clear.cgColor
    }
    
    func setDay(with date: Date?) {
        guard let incomingDate = date else {
            self.dayNumber.text = ""
            return
        }
        
        self.dayNumber.text = self.dayFormater.string(from: incomingDate)
    }
}

class CalendarView: UIView {
    
    let calendarView = JTAppleCalendarView()
    
    // control variables
    private let cellStyles: CalendarCellStyleType
    private let numberOfRows: Int
    
    var firstDate: Date? {
        didSet {
            updateDates()
        }
    }
    var lastDate: Date? {
        didSet {
            updateDates()
        }
    }
    
    init(numberOfRows: Int, cellStyles: CalendarCellStyleType) {
        self.numberOfRows = numberOfRows
        self.cellStyles = cellStyles
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
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        self.calendarView.calendarDataSource = self
        self.calendarView.calendarDelegate = self
        self.calendarView.reloadData()
    }

    private func addConstraintsToSubviews() {
        calendarView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(CGFloat(self.numberOfRows) * self.cellStyles.enabledStyle.height)
        }
    }
}

extension CalendarView: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let firstDate = Date()
        let components = DateComponents(year: 1)
        let secondDate = Calendar.current.date(byAdding: components, to: firstDate) ?? firstDate.addingTimeInterval(60 * 60 * 24 * 365)
        //TODO: Look for a Swifty calendar API
        
        //TODO: Check inDate and outDate
        let configuration = ConfigurationParameters(startDate: firstDate,
                                                    endDate: secondDate,
                                                    numberOfRows: self.numberOfRows,
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
            let isAfterToday = date.isSameDay(of: Date()) || date.isAfter(date: Date())
            let style: CalendarCellStyle = isAfterToday ?
                self.cellStyles.enabledStyle:
                self.cellStyles.disabledStyle
            
            calendarCell.setDay(with: date)
            calendarCell.applyStyle(style, shouldInteract: isAfterToday)
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
            let selectionMode = getCellSelectionMode(for: date)
            calendarCell.setSelection(mode: selectionMode)
        default: break
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        switch cellState.dateBelongsTo {
        case .thisMonth:
            self.manipulateNewClick(onDate: date)
        default: break
        }
    }
    
    // Helpers
    
    private func getCellSelectionMode(for date: Date) -> CalendarCellSelectionMode {
        if firstDate == nil {
            return .none(cellStyle: self.cellStyles.disabledStyle)
        }
        
        if let firstDate = self.firstDate, lastDate == nil, date.isSameDay(of: firstDate) {
            return .only(cellStyle: self.cellStyles.selectionStyle)
        }
        
        if let firstDate = self.firstDate, let lastDate = self.lastDate {
            if date.isSameDay(of: firstDate) {
                return .begin(cellStyle: self.cellStyles.selectionStyle)
            } else if date.isSameDay(of: lastDate) {
                return .end(cellStyle: self.cellStyles.selectionStyle)
            } else if date.isInBetween(beginDate: firstDate, endDate: lastDate) {
                return .medium(cellStyle: self.cellStyles.selectionStyle)
            } else {
                return .none(cellStyle: self.cellStyles.disabledStyle)
            }
        }
        
        return .none(cellStyle: self.cellStyles.enabledStyle)
    }
    
    private func manipulateNewClick(onDate date: Date) {
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
}
