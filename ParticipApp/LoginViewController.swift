//
//  LoginViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/21/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    var cornerR: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = cornerR
    }
    

}
