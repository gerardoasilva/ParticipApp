//
//  profileViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/23/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: Any) {
        // Notifies the homeViewController to close menu definitely
        NotificationCenter.default.post(name: .didCloseDefinitely, object: nil)
        // Pops last profileViewController
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
