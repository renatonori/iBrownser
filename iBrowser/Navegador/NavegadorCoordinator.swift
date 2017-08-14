//
//  NavegadorCoordinator.swift
//  iBrowser
//
//  Created by Renato Ioshida on 04/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class NavegadorCoordinator: NSObject {
    
    static let NavegadorViewControllerName = "NavegadorViewController"
    static let AtivarMDMViewController = "AtivarMDMViewController"
    
    static func pushNavegadorViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: NavegadorViewControllerName) as? NavegadorViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    static func pushAtivarMDMViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AtivarMDMViewController) as? AtivarMDMViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

