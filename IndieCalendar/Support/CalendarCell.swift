import JTAppleCalendar
import SnapKit
import SwiftDate

enum CalendarCellSelectionMode {
    case begin(cellStyle: CalendarCellStyle)
    case end(cellStyle: CalendarCellStyle)
    case medium(cellStyle: CalendarCellStyle)
    case only(cellStyle: CalendarCellStyle)
    case none(cellStyle: CalendarCellStyle)
}

class CalendarCell: JTAppleCell {
    
    private let dayNumber = UILabel()
    private var defaultBackgroundColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
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
    
    func applyStyle(_ style: CalendarCellStyle) {
        self.isUserInteractionEnabled = style.isUserInteractionEnabled
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
        
        self.dayNumber.text = "\(incomingDate.day)"
    }
}
