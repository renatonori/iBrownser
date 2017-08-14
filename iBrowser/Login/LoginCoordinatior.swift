//
//  LoginCoordinatior.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class LoginCoordinatior: NSObject {
    static let RecuperarSenhaViewControllerName = "RecuperarSenhaViewController"
    static let DispositivosPaiViewControllerName = "DispositivosPaiViewController"
    static let NavegadorViewControllerName = "NavegadorViewController"
    
    static func pushRecuperarSenhaViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: RecuperarSenhaViewControllerName) as? RecuperarSenhaViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

    static func pushNavegadorViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: NavegadorViewControllerName) as? NavegadorViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
