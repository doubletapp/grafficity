//
//  ViewController.swift
//  grafficity
//
//  Created by Виктор Краснов on 09/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let mapViewController = UIStoryboard(name: "MapView", bundle: nil).instantiateInitialViewController()
        self.present(mapViewController!, animated: true)
    }


}

