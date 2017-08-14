//
//  CadastrarUsuarioViewModel.swift
//  iBrowser
//
//  Created by Renato Ioshida on 18/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class CadastrarUsuarioViewModel: NSObject{
    
    class func criarUsuario(_ email:String?,_ senha:String?, completion:@escaping (_ sucess:Bool, _ mensagemDeErro:String)->Void){
        
        if(email == "" || email == nil){
            completion(false,"Campo de e-mail vazio")
            
        }else if(senha == "" || senha == nil){
            completion(false,"Campo de senha vazio")
            
        }else{
            FirebaseProvider.sharedInstance.cadastrarUsuario(email!, password: senha!) { (sucesso, msgDeErro) in
                completion(sucesso, msgDeErro)
                if(sucesso){
                    
                }
            }
        }
        
    }
    
    func criarUsuarioNoBancoComEmail(_ email:String) -> Void {
        
    }
}
