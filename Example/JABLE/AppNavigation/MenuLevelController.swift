//
//  MenuLevelController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class MenuLevelViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? AppNavigationController  else {return}
        let sideMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-alt32_32"), style: .plain, target: nav, action: Selector(("sideMenuButtonDidPress")))
        self.navigationItem.leftBarButtonItem = sideMenuButton
        self.navigationItem.setLeftBarButton(sideMenuButton, animated: false)
    }
}
