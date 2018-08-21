import UIKit

enum CalendarType {
    case plain
    case weekDaysHeader(style: WeekDaysHeaderStyle)
}


protocol WeekDaysHeaderStyle {
    var font: UIFont { get set }
    var textColor: UIColor { get set }
}
struct IndieWeekDaysHeader: WeekDaysHeaderStyle {
    var font: UIFont = UIFont.systemFont(ofSize: 11)
    var textColor: UIColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
}


protocol CalendarStyle {
    var type: CalendarType { get set }
}
struct IndieCalendar: CalendarStyle {
    var type: CalendarType = .weekDaysHeader(style: IndieWeekDaysHeader())
}
