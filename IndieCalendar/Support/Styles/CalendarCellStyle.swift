import UIKit

enum CalendarCellStyleType {
    case checkIn
    case unavailability
    
    var enabledStyle: CalendarCellStyle {
        switch self {
        case .checkIn:
            return CheckInCalendarCellEnabledStyle()
        case .unavailability:
            return UnavailabilityCalendarCellEnabledStyle()
        }
    }
    
    var disabledStyle: CalendarCellStyle {
        switch self {
        case .checkIn:
            return CheckInCalendarCellDisabledStyle()
        case .unavailability:
            return UnavailabilityCalendarCellDisabledStyle()
        }
    }
    
    var selectionStyle: CalendarCellStyle {
        switch self {
        case .checkIn:
            return CheckInCalendarCellSelectionStyle()
        case .unavailability:
            return UnavailabilityCalendarCellSelectionStyle()
        }
    }
}

protocol CalendarCellStyle {
    var height: CGFloat { get set }
    var font: UIFont { get set }
    var textColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
    var cornerRadius: CGFloat { get set }
    var backgroundColor: UIColor { get set }
    var textAttributes: [NSAttributedStringKey: Any] { get set }
}

struct CheckInCalendarCellEnabledStyle: CalendarCellStyle {
    var height: CGFloat = 30
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor: UIColor = UIColor(red: 145 / 255, green: 145 / 255, blue: 145 / 255, alpha: 1)
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = UIColor.clear
    var cornerRadius: CGFloat = 0
    var backgroundColor: UIColor = UIColor.clear
    var textAttributes: [NSAttributedStringKey : Any] = [:]
}
struct CheckInCalendarCellDisabledStyle: CalendarCellStyle {
    var height: CGFloat = 30
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor: UIColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = UIColor.clear
    var cornerRadius: CGFloat = 0
    var backgroundColor: UIColor = UIColor.clear
    var textAttributes: [NSAttributedStringKey : Any] = [:]
}
struct CheckInCalendarCellSelectionStyle: CalendarCellStyle {
    var height: CGFloat = 30
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    var textColor: UIColor = UIColor.white
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = UIColor.clear
    var cornerRadius: CGFloat = 4
    var backgroundColor: UIColor = UIColor(red: 253 / 255, green: 127 / 255, blue: 35 / 255, alpha: 1)
    var textAttributes: [NSAttributedStringKey : Any] = [:]
}

struct UnavailabilityCalendarCellEnabledStyle: CalendarCellStyle {
    var height: CGFloat = 45
    var font: UIFont = UIFont.systemFont(ofSize: 16)
    var textColor: UIColor = UIColor(red: 77 / 255, green: 77 / 255, blue: 77 / 255, alpha: 1)
    var borderWidth: CGFloat = 1
    var borderColor: UIColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1)
    var cornerRadius: CGFloat = 4
    var backgroundColor: UIColor = UIColor.white
    var textAttributes: [NSAttributedStringKey : Any] = [:]
}
struct UnavailabilityCalendarCellDisabledStyle: CalendarCellStyle {
    var height: CGFloat = 45
    var font: UIFont = UIFont.systemFont(ofSize: 16)
    var textColor: UIColor = UIColor(red: 180 / 255, green: 180 / 255, blue: 180 / 255, alpha: 1)
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = UIColor.clear
    var cornerRadius: CGFloat = 0
    var backgroundColor: UIColor = UIColor.clear
    var textAttributes: [NSAttributedStringKey : Any] = [:]
}
struct UnavailabilityCalendarCellSelectionStyle: CalendarCellStyle {
    var height: CGFloat = 45
    var font: UIFont = UIFont.systemFont(ofSize: 16)
    var textColor: UIColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
    var borderWidth: CGFloat = 0
    var borderColor: UIColor = UIColor(red: 225 / 255, green: 225 / 255, blue: 226 / 255, alpha: 1)
    var cornerRadius: CGFloat = 4
    var backgroundColor: UIColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
    var textAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue,
                                                         NSAttributedStringKey.strikethroughColor: UIColor.black]
}
