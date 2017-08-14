//
//  StartCoordinatior.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit


class StartCoordinatior: NSObject {
    
    static let CadastrarViewControllerName = "CadastrarViewController"
    static let LoginViewControllerName = "LoginViewController"
    static let AtivarFilhoViewControllerName = "AtivarFilhoViewController"
    static let AtivarMDMViewControllerName = "AtivarMDMViewController"
    
    
    static func pushLoginViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: LoginViewControllerName) as? LoginViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    static func pushCadastrarViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: CadastrarViewControllerName) as? CadastrarViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    static func pushAtivacaoViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AtivarFilhoViewControllerName) as? AtivarFilhoViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    static func pushAtivarMDMViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AtivarMDMViewControllerName) as? AtivarMDMViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
