//
//  RecuperarSenhaModelView.swift
//  iBrowser
//
//  Created by Renato Ioshida on 21/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class RecuperarSenhaModelView: NSObject {
   static func recuperarSenhaComEmail(_ email:String?,eCompletion:@escaping (_ success:Bool, _ msgDeErro:String)->Void){
        if let email = email, email != ""{
                FirebaseProvider.sharedInstance.recuperarSenha(email, completion: { (succes, msgErro) in
                    eCompletion(succes, msgErro)
                })
        }else{
            eCompletion(false, "Digite um email")
        }
        
    }
}
