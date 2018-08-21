//
//  ViewController.swift
//  IndieCalendar
//
//  Created by Vinicius Romani on 16/08/18.
//  Copyright © 2018 Vinicius Romani. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
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
        self.view = calendar
    }
}

