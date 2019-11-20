//
//  CustomNavController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/17/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Makes navBar transparent
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
}
