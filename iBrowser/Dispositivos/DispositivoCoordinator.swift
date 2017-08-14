//
//  DispositivoCoordinator.swift
//  iBrowser
//
//  Created by Renato Ioshida on 15/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class DispositivoCoordinator: NSObject {
    
    static let DispositivosTabBarViewControllerName = "DispositivosTabBarViewController"
    static let AdicionarRestricoesViewControllerName = "AdicionarRestricoesViewController"
    static let AdicionarExcecoesViewControllerName = "AdicionarExcecoesViewController"
    
    static func pushDispositivosTabBarViewController(navigationController:UINavigationController?, _ name:String, dispositivo:dispositivo){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: DispositivosTabBarViewControllerName) as? DispositivosTabBarViewController {
            viewController.title = name
            viewController.infoDispositivo = dispositivo
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    static func pushAdicionarRestricoesViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AdicionarRestricoesViewControllerName) as? AdicionarRestricoesViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    static func pushAdicionarExcecoesViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AdicionarExcecoesViewControllerName) as? AdicionarExcecoesViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
