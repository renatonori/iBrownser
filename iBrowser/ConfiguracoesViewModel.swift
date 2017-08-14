//
//  ConfiguracoesViewModel.swift
//  iBrowser
//
//  Created by Renato Ioshida on 20/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit



class ConfiguracoesViewModel: NSObject {
    static var confArray:Array<config>{
        get{
            return self.criarArray()
        }
    }
    
    class func criarArray()->Array<config>{
        var array:Array<config> = []
        
        array.append(config(nome: "Editar Senha", viewControllerToGo: EditarPerfilConfiguracoesViewController()))
        //array.append(config(nome: "Notificações", viewControllerToGo: NotificacoesConfiguracoesViewController()))
        array.append(config(nome: "Sair", viewControllerToGo: nil))
        
        return array
    }
}
