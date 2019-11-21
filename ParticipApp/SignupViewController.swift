//
//  SignupViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/21/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var RegisterButton: UIButton!
    
    var cornerR: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RegisterButton.layer.cornerRadius = cornerR
        
    }

}
