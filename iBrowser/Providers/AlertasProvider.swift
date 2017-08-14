//
//  AlertasProvider.swift
//  iBrowser
//
//  Created by Renato Ioshida on 18/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class AlertasProvider: NSObject {
    static func alertaSimples(_ titulo:String, _ mensagem:String )->UIAlertController{
        let alert:UIAlertController = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
