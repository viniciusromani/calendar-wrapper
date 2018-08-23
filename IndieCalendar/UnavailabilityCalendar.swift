import SnapKit
import SwiftDate
import UIKit

class UnavailabilityCalendar: UIView {
    
    // View
    let rightArrow = UIButton(type: .custom)
    let leftArrow = UIButton(type: .custom)
    private let month = UILabel()
    let info = UILabel()
    private let weekDayStack = UIStackView()
    private let weekDaysLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
    private let weekTitles = ["seg", "ter", "qua", "qui", "sex", "sab", "dom"]
    private let calendar = CalendarView(numberOfRows: 6, cellStyles: .unavailability)
    let selectMonth = UIButton(type: .custom)
    
    private let monthFormatter = DateFormatter()
    
    // Init
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
    
    // Build view
    private func buildView() {
        self.addViews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }
    
    private func addViews() {
        self.addSubview(leftArrow)
        self.addSubview(rightArrow)
        self.addSubview(month)
        self.addSubview(info)
        self.addSubview(self.weekDayStack)
        self.weekDaysLabels.forEach { self.weekDayStack.addArrangedSubview($0) }
        self.addSubview(calendar)
        self.addSubview(selectMonth)
    }
    
    private func formatViews() {
        self.backgroundColor = UIColor(red: 250 / 255, green: 251 / 255, blue: 252 / 255, alpha: 1)
        
        self.monthFormatter.dateFormat = "LLLL"
        
        self.leftArrow.setImage(UIImage(named: "seta")!, for: .normal)
        self.leftArrow.tintColor = UIColor(red: 16 / 255, green: 163 / 255, blue: 163 / 255, alpha: 1)
        
        self.rightArrow.setImage(UIImage(named: "seta")!, for: .normal)
        self.rightArrow.tintColor = UIColor(red: 16 / 255, green: 163 / 255, blue: 163 / 255, alpha: 1)
        self.rightArrow.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        
        self.month.font = UIFont.systemFont(ofSize: 20)
        self.month.textColor = UIColor(red: 77 / 255, green: 77 / 255, blue: 77 / 255, alpha: 1)
        self.month.textAlignment = .center
        self.month.text = "Junho 2018"
        
        self.info.font = UIFont.systemFont(ofSize: 14)
        self.info.textColor = UIColor(red: 77 / 255, green: 77 / 255, blue: 77 / 255, alpha: 1)
        self.info.textAlignment = .center
        self.info.text = "Carro indisponível em x dias"
        
        self.weekDayStack.axis = .horizontal
        self.weekDayStack.distribution = .fillEqually
        
        for (index, item) in self.weekDaysLabels.enumerated() {
            item.font = UIFont.systemFont(ofSize: 11)
            item.textAlignment = .center
            item.textColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
            item.text = self.weekTitles[index].uppercased()
        }
        
        self.selectMonth.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.selectMonth.setTitleColor(UIColor(red: 16 / 255, green: 163 / 255, blue: 163 / 255, alpha: 1), for: .normal)
        self.selectMonth.setTitle("SELECIONAR O MÊS", for: .normal)
    }
    
    private func addConstraintsToSubviews() {
        
        leftArrow.snp.makeConstraints { make in
            make.top.equalTo(self).inset(100)
            make.left.equalTo(self).inset(20)
        }
        
        rightArrow.snp.makeConstraints { make in
            make.top.equalTo(self).inset(100)
            make.right.equalTo(self).inset(20)
        }
        
        month.snp.makeConstraints { make in
            make.top.equalTo(self).inset(100)
            make.centerX.equalTo(self)
        }
        
        info.snp.makeConstraints { make in
            make.top.equalTo(self.month.snp.bottom).offset(6)
            make.left.equalTo(self).inset(30)
            make.centerX.equalTo(self)
        }
        
        weekDayStack.snp.makeConstraints { make in
            make.top.equalTo(self.info.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.centerX.equalTo(self)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.weekDayStack.snp.bottom).offset(20)
            make.left.right.equalTo(self).inset(30)
        }
        
        selectMonth.snp.makeConstraints { make in
            make.top.equalTo(self.calendar.snp.bottom).offset(30)
            make.left.right.equalTo(self).inset(30)
            make.bottom.equalTo(self).inset(320)
        }
    }
    
    func goToNextMonth() {
        calendar.calendarView.scrollToSegment(.next)
        
        guard let firstDate = calendar.calendarView.visibleDates().monthDates.first?.date else {
                return
        }
        
        let nextMonthDate = firstDate + 1.months
        self.month.text = self.monthFormatter.string(from: nextMonthDate)
    }
    
    func goToPreviousMonth() {
        calendar.calendarView.scrollToSegment(.previous)
        
        guard let firstDate = calendar.calendarView.visibleDates().monthDates.first?.date else {
            return
        }
        
        let previousMonthDate = firstDate - 1.months
        self.month.text = self.monthFormatter.string(from: previousMonthDate)
    }
}
