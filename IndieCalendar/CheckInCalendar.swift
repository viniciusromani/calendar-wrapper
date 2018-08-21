import SnapKit
import UIKit

class CheckInCalendar: UIView {
    
    // View
    private let info = UILabel()
    private let calendar = CalendarView(numberOfRows: 6)
    
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
        self.addSubview(info)
        self.addSubview(calendar)
    }
    
    private func formatViews() {
        self.backgroundColor = UIColor(red: 250 / 255, green: 251 / 255, blue: 252 / 255, alpha: 1)
        
        self.info.font = UIFont.systemFont(ofSize: 16)
        self.info.textColor = UIColor(red: 77 / 255, green: 77 / 255, blue: 77 / 255, alpha: 1)
        self.info.textAlignment = .center
        self.info.text = "Em quais dias seu carro estará indisponível?"
    }
    
    private func addConstraintsToSubviews() {
        info.snp.makeConstraints { make in
            make.top.top.equalTo(self).inset(100)
            make.left.right.equalTo(self).inset(20)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.info).offset(50)
            make.left.right.bottom.equalTo(self).inset(30)
        }
    }
}
