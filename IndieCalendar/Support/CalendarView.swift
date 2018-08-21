import Cartography
import JTAppleCalendar

enum CalendarCellSelectionMode {
    case begin, end, medium, only, none
}

class CalendarCell: JTAppleDayCellView {

    var defaultTextColor: UIColor = .appColor(.defaultGray)

    let dayNumber = UILabel()
    let backgroundView = UIView()

    var isToday: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func buildView() {
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }

    fileprivate func addSubviews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.dayNumber)
    }

    fileprivate func formatViews() {
        self.dayNumber.textAlignment = .center
        self.dayNumber.font = .mediumFont(14)


        self.backgroundView.isHidden = true
    }

    fileprivate func addConstraintsToSubviews() {
        let verticalMargin: CGFloat = UIScreen.main.valueForSize(3, mediumSize: 3, defaultSize: 6, plusSize: 6)
        let backgroundMargin: CGFloat = UIScreen.main.valueForSize(2, mediumSize: 2, defaultSize: 3, plusSize: 3)

        self.translatesAutoresizingMaskIntoConstraints = true

        constrain(self, dayNumber, backgroundView) { view, number, background in
            number.top == view.top + verticalMargin
            number.left == view.left
            number.right == view.right
            number.bottom == view.bottom - verticalMargin

            background.top == view.top + backgroundMargin
            background.left == view.left + 2
            background.right == view.right - 2
            background.bottom == view.bottom - backgroundMargin
            background.center == view.center
//            background.height == background.width ~ 900
        }
    }

    var selectedMode = CalendarCellSelectionMode.none {
        didSet {
            self.updateMode(self.selectedMode)
        }
    }

    func updateMode(_ mode: CalendarCellSelectionMode) {
        self.backgroundView.isHidden = false

        let radius: CGFloat = 4

        switch mode {
        case .none:
            if self.isToday {
                self.backgroundView.backgroundColor = .appColor(.lighterGray)
                self.backgroundView.roundCorner([.allCorners], radius: radius)
            } else {
                self.backgroundView.isHidden = true
            }
        case .begin, .end, .only, .medium:
            self.backgroundView.backgroundColor = .appColor(.defaultOrange)
            self.backgroundView.roundCorner([.allCorners], radius: radius)
        }

        switch mode {
        case .none:
            self.dayNumber.textColor = self.defaultTextColor
        default:
            self.dayNumber.textColor = .white
        }
    }

    func setSelected(_ mode: CalendarCellSelectionMode) {
        self.selectedMode = mode
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateMode(self.selectedMode)
    }
}

class CalendarHeader: JTAppleHeaderView {
    let monthName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buildView()
    }

    fileprivate func buildView() {
        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }

    fileprivate func addSubviews() {
        self.addSubview(self.monthName)
    }

    fileprivate func formatViews() {
        self.monthName.textAlignment = .center
        self.monthName.font = .mediumFont(14)
        self.monthName.textColor = .appColor(.defaultGray)
    }

    fileprivate func addConstraintsToSubviews() {
        constrain(self, monthName) { view, number in
            number.top == view.top
            number.left == view.left
            number.right == view.right
            number.bottom == view.bottom
        }
    }
}

class CalendarView: UIView {

    let weekDayStack = UIStackView()
    let weekDaysLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
    let weekTitles = ["seg", "ter", "qua", "qui", "sex", "sab", "dom"]

    let divider = UIView()

    let calendarView = JTAppleCalendarView()

    var onDatesChange: ((Date?, Date?) -> Void)?

    let dateFormater = DateFormatter()
    let dayFormater = DateFormatter()
    let monthFormater = DateFormatter()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

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
    
    func updateDates() {
        calendarView.reloadData()
    }
    
    func callOnDatesChange() {
        self.onDatesChange?(self.firstDate, self.lastDate)
    }

    init() {
        super.init(frame: CGRect.zero)
        self.buildView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func buildView() {
        dateFormater.dateFormat = "yyyy mm dd"
        dayFormater.dateFormat = "d"
        monthFormater.dateFormat = "MMMM  yyyy"
        monthFormater.locale = Locale(identifier: "pt-BR")

        self.addSubviews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }

    fileprivate func addSubviews() {
        self.backgroundColor = .red
        self.addSubview(self.calendarView)

        self.addSubview(self.weekDayStack)
        self.weekDaysLabels.forEach { self.weekDayStack.addArrangedSubview($0) }

        self.addSubview(self.divider)
    }

    fileprivate func formatViews() {
        self.backgroundColor = .white

        self.calendarView.direction = .vertical
        self.calendarView.registerCellViewClass(type: CalendarCell.self)
        self.calendarView.registerHeaderView(classTypeNames: [CalendarHeader.self])
        self.calendarView.cellInset = CGPoint.zero

        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.reloadData()

        self.weekDayStack.axis = .horizontal
        self.weekDayStack.distribution = .fillEqually

        for (index, item) in self.weekDaysLabels.enumerated() {
            item.font = .boldFont(10)
            item.textAlignment = .center
            item.textColor = .appColor(.defaultGray)
            item.text = self.weekTitles[index].uppercased()
        }

        self.divider.backgroundColor = .appColor(.lightGray)
    }

    fileprivate func addConstraintsToSubviews() {
        let margin: CGFloat = 20
        constrain(self, calendarView, weekDayStack, divider) { view, calendar, week, divider in
            week.top == view.top + 15
            week.left == calendar.left
            week.right == calendar.right
            week.bottom == divider.top - 7
            week.height == 20

            calendar.left == view.left + margin
            calendar.right == view.right - margin
            calendar.bottom == view.bottom

            divider.left == view.left + margin
            divider.right == view.right - margin
            divider.bottom == calendar.top
            divider.height == 1

        }
    }
}



extension CalendarView: JTAppleCalendarViewDataSource {
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let fifteenMinutes = DateComponents(minute: 15)
        let firstDate = Calendar.current.date(byAdding: fifteenMinutes, to: Date()) ?? Date().addingTimeInterval(60 * 15)
        let components = DateComponents(year: 1)
        let secondDate = Calendar.current.date(byAdding: components, to: firstDate) ?? firstDate.addingTimeInterval(60 * 60 * 24 * 365)
        //TODO: Look for a Swifty calendar API

        //TODO: Check inDate and outDate
        let configuration = ConfigurationParameters(startDate: firstDate,
                                                    endDate: secondDate,
                                                    numberOfRows: 6,
                                                    calendar: self.calendar,
                                                    generateInDates: .forAllMonths,
                                                    generateOutDates: .tillEndOfGrid,
                                                    firstDayOfWeek: .monday)
        
        return configuration
    }
}

extension CalendarView: JTAppleCalendarViewDelegate {
    // swiftlint:disable cyclomatic_complexity
    func calendar(_ calendar: JTAppleCalendarView,
                  willDisplayCell cell: JTAppleDayCellView,
                  date: Date,
                  cellState: CellState) {

        guard let calendarCell = cell as? CalendarCell else {
            return
        }

        if date.isBeforeToday() {
            calendarCell.defaultTextColor = .appColor(.lightGray)
        } else {
            calendarCell.defaultTextColor = .appColor(.defaultGray)
        }

        calendarCell.isToday = Calendar.current.isDateInToday(date)

        switch cellState.dateBelongsTo {
        case .thisMonth:
            let day = dayFormater.string(from: date)
            calendarCell.dayNumber.text = day


            if date.isBeforeToday() {
                calendarCell.setSelected(.none)
            } else if firstDate == nil {
                calendarCell.setSelected(.none)
            } else if let firstDate = self.firstDate, lastDate == nil {
                calendarCell.setSelected(date.compare(firstDate) == .orderedSame ? .only : .none)
            } else if let firstDate = self.firstDate, let lastDate = self.lastDate {
                if date.compare(firstDate) == .orderedSame {
                    calendarCell.setSelected(.begin)
                } else if date.compare(lastDate) == .orderedSame {
                    calendarCell.setSelected(.end)
                } else if date.compare(firstDate) == .orderedDescending && date.compare(lastDate) == .orderedAscending {
                    calendarCell.setSelected(.medium)
                } else {
                    calendarCell.setSelected(.none)
                }
            }

        default:
            calendarCell.setSelected(.none)
            calendarCell.dayNumber.text = ""
        }
    }

    func calendar(_ calendar: JTAppleCalendarView,
                  sectionHeaderIdentifierFor range: (start: Date, end: Date),
                  belongingTo month: Int) -> String {
        return String(describing: CalendarHeader.self)
    }

    func calendar(_ calendar: JTAppleCalendarView,
                  sectionHeaderSizeFor range: (start: Date, end: Date),
                  belongingTo month: Int) -> CGSize {

        return CGSize(width: calendar.bounds.width, height: 40)
    }
    
    func calendar(_ calendar: JTAppleCalendarView,
                  willDisplaySectionHeader header: JTAppleHeaderView,
                  range: (start: Date, end: Date),
                  identifier: String) {

        guard let calendarHeader = header as? CalendarHeader else {
            return
        }

        calendarHeader.monthName.text = monthFormater.string(from: range.start).capitalized
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        guard !date.isBeforeToday() else {
            return
        }

        switch cellState.dateBelongsTo {
        case .thisMonth:
            if firstDate == nil {
                self.firstDate = date
            } else if lastDate == nil {
                let otherDate = (firstDate as NSDate?)?.copy() as? Date
                self.firstDate = min(otherDate!, date)
                self.lastDate = max(otherDate!, date)
            } else {
                self.firstDate = date
                self.lastDate = nil
            }
            
            callOnDatesChange()

        default:
            break
        }
    }
}
