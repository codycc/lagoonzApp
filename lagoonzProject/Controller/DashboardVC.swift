//
//  DashboardVC.swift
//  lagoonzProject
//
//  Created by Cody Condon on 2017-08-28.
//  Copyright © 2017 Cody Condon. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var myPartiesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPartiesBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

  

}
