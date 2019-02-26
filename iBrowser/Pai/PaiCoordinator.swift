//
//  PaiCoordinator.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class PaiCoordinator: NSObject {
    
    static let PaiTabBarViewControllerName = "PaiTabBarViewController"
    static let AdicionarDeviceViewControllerName = "AdicionarDeviceViewController"

    static func pushPaiTabBarViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: PaiTabBarViewControllerName) as? PaiTabBarViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    static func pushAdicionarDeviceViewController(navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AdicionarDeviceViewControllerName) as? AdicionarDeviceViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    static func pushAdicionarDeviceViewController(qrCode:String,nome:String,nomeDisp:String,navigationController:UINavigationController?){
        if let viewController = UIStoryboard(name: AppConstants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: AdicionarDeviceViewControllerName) as? AdicionarDeviceViewController {
            viewController.qrCode = qrCode
            viewController.nome = nome
            viewController.nomeDispositivo = nomeDisp
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

}
