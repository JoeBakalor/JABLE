//
//  ViewController.swift
//  JABLE
//
//  Created by jmbakalor@gmail.com on 03/01/2018.
//  Copyright (c) 2018 jmbakalor@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bleManager.startScanning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

