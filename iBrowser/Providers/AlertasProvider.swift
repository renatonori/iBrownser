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
    static func alertAdicionarDisp(_ controller:UIViewController,placeholders:[String],textFields:[String], action: @escaping ([String])->Void){
        let alertController = UIAlertController(title: "Complete Todos os campos", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            guard let alertTextFields = alertController.textFields else{
                return
            }
            var newValues:[String] = []
            for textField in alertTextFields{
                guard let text = textField.text, text != "" else{
                    self.erroSemTextoAlert(controller)
                    return
                }
                newValues.append(text)
            }
            action(newValues)
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in})
        
        for (placeholder,text) in zip(placeholders,textFields){
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = placeholder
                textField.text = text
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    static func alertRemover(_ controller:UIViewController,action: @escaping ()->Void){
        let okayAlertController = UIAlertController(title: "Deseja realmente remover?", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            action()
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in})
        
        okayAlertController.addAction(okayAction)
        okayAlertController.addAction(cancelAction)
        
        controller.present(okayAlertController, animated: true, completion: nil)
    }
    static func alertEditar(_ controller:UIViewController,placeholders:[String],textFields:[String], action: @escaping ([String])->Void){
        let alertController = UIAlertController(title: "Edite os Campos", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            guard let alertTextFields = alertController.textFields else{
                return
            }
            var newValues:[String] = []
            for textField in alertTextFields{
                guard let text = textField.text, text != "" else{
                    self.erroSemTextoAlert(controller)
                    return
                }
                newValues.append(text)
            }
            action(newValues)
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in})
        
        for (placeholder,text) in zip(placeholders,textFields){
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = placeholder
                textField.text = text
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    static func erroSemTextoAlert(_ controller:UIViewController){
        let okayAlertController = UIAlertController(title: "Complete antes de continuar", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            
        })
        okayAlertController.addAction(okayAction)
        
        controller.present(okayAlertController, animated: true, completion: nil)
    }
}
