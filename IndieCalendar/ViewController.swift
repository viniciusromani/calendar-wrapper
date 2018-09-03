//
//  ViewController.swift
//  IndieCalendar
//
//  Created by Vinicius Romani on 16/08/18.
//  Copyright © 2018 Vinicius Romani. All rights reserved.
//

import UIKit
import SwiftDate
import JTAppleCalendar

class ViewController: UIViewController {
    
    private var unavailabilityCalendar: UnavailabilityCalendar!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        let calendar = UnavailabilityCalendar()
        
        calendar.leftArrow.addTarget(self, action: #selector(onLeftArrow), for: .touchUpInside)
        calendar.rightArrow.addTarget(self, action: #selector(onRightArrow), for: .touchUpInside)
        calendar.selectMonth.addTarget(self, action: #selector(onSelectMonth), for: .touchUpInside)
        
        self.unavailabilityCalendar = calendar
        
        self.view = calendar
    }
    
    @objc func onLeftArrow() {
        self.unavailabilityCalendar.goToPreviousMonth()
    }
    
    @objc func onRightArrow() {
        self.unavailabilityCalendar.goToNextMonth()
    }
    
    @objc func onSelectMonth() {
        self.unavailabilityCalendar.calendar.insertAlreadySelectedDates([Date() + 2.days,
                                                                         Date() + 3.days,
                                                                         Date() + 4.days,
                                                                         Date() + 5.days,
                                                                         Date() + 10.days])
        
    }
}
