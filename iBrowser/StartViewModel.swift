//
//  StartViewModel.swift
//  iBrowser
//
//  Created by Renato Ioshida on 19/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class StartViewModel: NSObject {
    class func logarUsuario(_ email:String?,_ senha:String?, completion:@escaping (_ sucess:Bool, _ mensagemDeErro:String)->Void){
        
        if(email == "" || email == nil){
            completion(false,"Campo de e-mail vazio")
            
        }else if(senha == "" || senha == nil){
            completion(false,"Campo de senha vazio")
            
        }else{
            FirebaseProvider.sharedInstance.logarUsuario(email!, password: senha!) { (sucesso, msgDeErro) in
                completion(sucesso, msgDeErro)
            }
        }
        
    }
}
