import SnapKit
import SwiftDate
import UIKit
import RxSwift

class UnavailabilityCalendar: UIView {
    
    // View
    let rightArrow = UIButton(type: .custom)
    let leftArrow = UIButton(type: .custom)
    private let month = UILabel()
    let info = UILabel()
    private let weekDayStack = UIStackView()
    private let weekDaysLabels = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
    private let weekTitles = ["seg", "ter", "qua", "qui", "sex", "sab", "dom"]
    let calendarStyle = UnavailabilityCalendarStyle()
    lazy var calendar = CalendarView(numberOfRows: 6, calendarStyle: self.calendarStyle)
    let selectMonth = UIButton(type: .custom)
    private let variableMonth = BehaviorSubject<String>(value: "")
    private let disposeBag = DisposeBag()
    
    // Init
    init() {
        super.init(frame: CGRect.zero)
        self.buildView()
        
        self.calendar.selectedPeriodObservable().subscribe(onNext: { (beginDate, endDate) in
            print("selected! \(beginDate) dateee \(endDate)")
        }).disposed(by: self.disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let navigation = UIView()
    private let navTitle = UILabel()
    
    // Build view
    private func buildView() {
        self.addViews()
        self.formatViews()
        self.addConstraintsToSubviews()
    }
    
    private func addViews() {
        self.addSubview(navigation)
        self.navigation.addSubview(navTitle)
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
        self.navigation.backgroundColor = UIColor.white
        self.navigation.layer.masksToBounds = false
        self.navigation.layer.shadowColor = UIColor.black.cgColor
        self.navigation.layer.shadowOpacity = 0.1
        self.navigation.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.navTitle.text = "Title"
        self.navTitle.textColor = UIColor.black
        
        self.backgroundColor = UIColor(red: 250 / 255, green: 251 / 255, blue: 252 / 255, alpha: 1)
        
        self.leftArrow.setImage(UIImage(named: "seta")!, for: .normal)
        self.leftArrow.tintColor = UIColor(red: 16 / 255, green: 163 / 255, blue: 163 / 255, alpha: 1)
        
        self.rightArrow.setImage(UIImage(named: "seta")!, for: .normal)
        self.rightArrow.tintColor = UIColor(red: 16 / 255, green: 163 / 255, blue: 163 / 255, alpha: 1)
        self.rightArrow.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        
        self.month.font = UIFont.systemFont(ofSize: 20)
        self.month.textColor = UIColor(red: 77 / 255, green: 77 / 255, blue: 77 / 255, alpha: 1)
        self.month.textAlignment = .center
        self.month.text = Date().monthName(.default) + " \(Date().year)"
        
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
        
        navigation.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(44 + 40)
        }
        
        navTitle.snp.makeConstraints { make in
            make.centerX.equalTo(self.navigation)
            make.centerY.equalTo(self.navigation).inset(40 / 2)
        }
        
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
    }
    
    func goToPreviousMonth() {
        calendar.calendarView.scrollToSegment(.previous)
    }
}
