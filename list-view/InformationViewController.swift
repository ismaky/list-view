//
//  InformationViewController.swift
//  list-view
//
//  Created by Ismael on 16/03/23.
//

import UIKit

class InformationViewController: UIViewController {
    
    var album: Album! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}
