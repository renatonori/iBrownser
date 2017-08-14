//
//  FirebaseDatabaseProvider.swift
//  iBrowser
//
//  Created by Renato Ioshida on 18/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class FirebaseDatabaseProvider: NSObject {
    static let sharedInstance:FirebaseDatabaseProvider = FirebaseDatabaseProvider()
    
    let referencia:DatabaseReference = Database.database().reference()
    let referenciaPai = Database.database().reference().child("gerentes")
    
    func getUserId()->String{
        return (Auth.auth().currentUser?.uid)!
    }
    func adicionarFilho(_ nome:String,_ dispNome:String)->(String){
        if let uid = Auth.auth().currentUser?.uid{
            let key =  referenciaPai.child(uid).childByAutoId().key
            self.referenciaPai.child(uid).child("dispositivos").child(key).child("gerente").setValue(uid)
            self.referenciaPai.child(uid).child("dispositivos").child(key).child("foiLido").setValue(0)
            self.referenciaPai.child(uid).child("dispositivos").child(key).child("nome").setValue(nome)
            self.referenciaPai.child(uid).child("dispositivos").child(key).child("dispoNome").setValue(dispNome)
            return String(key+";"+uid)
        }
        return ""
    }
    func removerFilho(_ userID:String){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(userID).setValue(nil)
        }
    }
    func esperandoDispositivoFilhoLinkar(_ filhoID:String, completion:@escaping (_ success:Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            referenciaPai.child(uid).child("dispositivos").child(filhoID).observe(.value, with: { snapshot in
                if(snapshot.exists()){
                    if let teste = snapshot.value as? NSDictionary{
                        if let foiLido = teste.value(forKey: "foiLido") as? NSNumber{
                            completion(foiLido == NSNumber(integerLiteral: 1))
                        }
                    }
                }
            })
        }
    }
    func linkLido(_ filhoID:String,_ gerenteID:String)->Bool{
        referenciaPai.child(gerenteID).child("dispositivos").child(filhoID).updateChildValues(["foiLido":1])
        return false
    }
    
    func getDevices(completion:@escaping (_ devices:Array<dispositivo>)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            referenciaPai.child(uid).child("dispositivos").observe(.value, with: { snapshot in
                if(snapshot.exists()){
                    if let teste = snapshot.value as? NSDictionary{
                        var array:Array<dispositivo> = []
                        for key in teste.allKeys{
                            if let dict = teste.object(forKey: key) as? NSDictionary{
                                let nome = dict.value(forKey: "nome") as? String ?? ""
                                let dispoNome = dict.value(forKey: "dispoNome") as? String ?? ""
                                let disp:dispositivo = dispositivo(key: key as! String, dispositivoNome: dispoNome, nomeFilho: nome, status: "")
                                array.append(disp)
                            }
                        }
                        completion(array)
                    }
                    
                }else{
                    
                }
            })
        }
    }
    func adicionarPai(){
        if let uid = Auth.auth().currentUser?.uid{
            referenciaPai.child(uid).observe(.value, with: { snapshot in
                if(!snapshot.exists()){
                    self.referenciaPai.child(uid).child("email").setValue(Auth.auth().currentUser?.email)
                    
                }
            })
        }
        
    }
    
    func adicionarRestricao(_ deviceID:String,_ gerenteID:String, _ link:String){
        //referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).observe(.value, with: { snapshot in
           // if(snapshot.exists()){
                let key = self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").childByAutoId().key
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").child(key).setValue(["link":"https://"+link])
            //}
        //})
        
    }
    func getRestricoes(_ deviceID:String,_ gerenteID:String,completion:@escaping (_ devices:Array<String>)->Void){
        
            self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").observe(.value, with: { snapshot in
                if(snapshot.exists()){
                    if let teste = snapshot.value as? NSDictionary{
                        var array:Array<String> = []
                        for key in teste.allKeys{
                            if let dict = teste.object(forKey: key) as? NSDictionary{
                                let link = dict.value(forKey: "link") as? String ?? ""
                                array.append(link)
                            }
                        }
                        completion(array)
                    }
                    
                }else{
                    
                }
            })

    }
}
