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
    func adicionarFilho(_ nome:String,_ dispNome:String, completion:@escaping (_ codeQR:String, _ success:Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            let key =  referenciaPai.child(uid).childByAutoId().key
            let dictAllValues = ["gerente":uid,
                                 "foiLido":0,
                                 "nome":nome,
                                 "dispoNome":dispNome] as [String : Any]
            
            self.referenciaPai.child(uid).child("dispositivos").child(key).setValue(dictAllValues) { (error, database) in
                completion(String(key+";"+uid),error != nil)
            }
        }
        
    }
    func removerFilho(_ dispKey:String,completion:@escaping (_ finished:Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(dispKey).setValue(nil) { (error, reference) in
                completion(error != nil)
            }
            
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
    func removerDevice(_ deviceID:String,completion:@escaping (Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(deviceID).setValue(nil) { (error, reference) in
                completion(error == nil)
            }
        }
    }
    func editarDevice(_ deviceID:String,_ nome:String,nomeDisp:String,completion:@escaping (Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(deviceID).updateChildValues(["nome":nome,"dispoNome":nomeDisp]) { (error, reference) in
                completion(error == nil)
            }
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
    func setBloquear(_ deviceID:String,_ bloquear:Bool){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(deviceID).child("bloquear").setValue(bloquear)
        }
    }
    func getBloquearStatus(_ deviceID:String, completion:@escaping (Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(deviceID).child("bloquear").observe(.value, with: { snapshot in
                if(snapshot.exists()){
                    if let bloq = snapshot.value as? Bool{
                        completion(bloq)
                    }else{
                        completion(false)
                    }
                }else{
                    completion(false)
                }
            })
        }
    }
    
    func adicionarExcecoes(_ deviceID:String,_ gerenteID:String, _ link:String, completion:@escaping (_ finished:Bool)->Void){
        
        let key = self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("excecoes").childByAutoId().key
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("excecoes").child(key).setValue(["link":link]) { (error, reference) in
            completion(error != nil)
        }
        
        
    }
    func editarExcecoes(_ deviceID:String,_ gerenteID:String,_ key:String,_ link:String, completion:@escaping(_ finished:Bool)->Void){
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("excecoes").child(key).updateChildValues(["link":link]) { (error, referente) in
            completion(error != nil)
        }
    }
    
    func getExcecoes(_ deviceID:String,_ gerenteID:String,completion:@escaping (_ devices:Array<ExcecaoModel>)->Void){
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("excecoes").observe(.value, with: { snapshot in
            if(snapshot.exists()){
                if let teste = snapshot.value as? NSDictionary{
                    var array:Array<ExcecaoModel> = []
                    for key in teste.allKeys{
                        if let keyExc = key as? String, let dict = teste.object(forKey: key) as? NSDictionary{
                            let link = dict.value(forKey: "link") as? String ?? ""
                            let excecao = ExcecaoModel()
                            excecao.stringExcecao = link
                            excecao.key = keyExc
                            array.append(excecao)
                        }
                    }
                    completion(array)
                }
                
            }else{
                
            }
        })
        
    }
    
    func removerExcecoes(_ userID:String, _ restrictionID:String,completion:@escaping (Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(userID).child("excecoes").child(restrictionID).setValue(nil) { (error, reference) in
                completion(error == nil)
            }
        }
    }
    func adicionarRestricao(_ deviceID:String,_ gerenteID:String, _ link:String,completion:@escaping (_ finished:Bool)->Void){
        let key = self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").childByAutoId().key
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").child(key).setValue((["link":link])) { (error, referente) in
            completion(error != nil)
        }
        
    }
    func editarRestricao(_ deviceID:String,_ gerenteID:String,_ key:String,_ link:String, completion:@escaping(_ finished:Bool)->Void){
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").child(key).updateChildValues(["link":link]) { (error, referente) in
            completion(error != nil)
        }
    }
    func removerRestricao(_ userID:String, _ restrictionID:String,completion:@escaping (Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(userID).child("restricoes").child(restrictionID).setValue(nil) { (error, reference) in
                completion(error == nil)
            }
        }
    }
    func getBloqueio(_ userID:String, completion:@escaping (Bool)->Void){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(userID).child("bloquear").observe(.value, with: { snapshot in
                if snapshot.exists(){
                    if let isActive = snapshot.value as? Bool{
                        completion(isActive)
                    }else{
                        completion(false)
                    }
                }
                
            })
        }
    }
    func setBloqueio(_ userID:String, _ restrictionID:String, _ newValue:Bool){
        if let uid = Auth.auth().currentUser?.uid{
            self.referenciaPai.child(uid).child("dispositivos").child(userID).child("isActive").setValue(newValue)
        }
    }
    func getRestricoes(_ deviceID:String,_ gerenteID:String,completion:@escaping (_ devices:Array<RestricaoModel>)->Void){
        
        self.referenciaPai.child(gerenteID).child("dispositivos").child(deviceID).child("restricoes").observe(.value, with: { snapshot in
            if(snapshot.exists()){
                if let teste = snapshot.value as? NSDictionary{
                    var array:Array<RestricaoModel> = []
                    for key in teste.allKeys{
                        if let keyString = key as? String,
                            let dict = teste.object(forKey: key) as? NSDictionary{
                            let link = dict.value(forKey: "link") as? String ?? ""
                            let restricao = RestricaoModel()
                            restricao.stringRestricao = link
                            restricao.key = keyString
                            array.append(restricao)
                        }
                    }
                    completion(array)
                }
                
            }else{
                
            }
        })
        
    }
}
