//
//  reportsViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/23/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit

class reportsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var todosContainerView: UIView!
    @IBOutlet weak var resueltosContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Shows only default container
        todosContainerView.isHidden = false
        resueltosContainerView.isHidden = true
    }
    
    // Displays reposrt depending on segmentedControl
    @IBAction func indexChanged(_ sender: Any) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            todosContainerView.isHidden = false
            resueltosContainerView.isHidden = true
        } else {
            resueltosContainerView.isHidden = false
            todosContainerView.isHidden = true
        }
    }
    
    
    // Closes all menus and goes to homeView
    @IBAction func closePressed(_ sender: Any) {
        // Notifies the homeViewController to close menu definitely
        NotificationCenter.default.post(name: .didCloseDefinitely, object: nil)
        // Pops last profileViewController
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
