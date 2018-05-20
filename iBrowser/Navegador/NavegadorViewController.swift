//
//  NavegadorViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import Kanna
import SafariServices
class NavegadorViewController: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet weak var situacaoSiteLabel: UILabel!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var buscarSiteTextField: UITextField!
    @IBOutlet weak var situacaoTextoSiteLabel: UILabel!
    
    var restricoesArray:Array<RestricaoModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        buscarSiteTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.show(.labeledProgress(title: "Atualizando", subtitle: ""))
        NaiveBayesClassifierRequest.sharedInstace.getTrainedValues { (result) in
            HUD.flash(.success)
            NaiveBayesClassifier.sharedInstance.model = result
        }
        
    }
    func avaliarSite(url:String?){
        guard let urlParaAvaliar = url else {
            return
        }
        self.situacaoSiteLabel.text = ""
        HUD.show(.progress)
        AvaliadorDeSite.sharedInstance.avaliarComURLString(url: urlParaAvaliar) { (acceptable,porcent,success,noResult)  in
            self.situacaoSiteLabel.isHidden = false
            if success{
                HUD.flash(.success)
                if !noResult{
                    if !acceptable{
                        let porcentString = String(format: "%2.2f", 100.0 - porcent)
                        self.situacaoSiteLabel.text = "SITE NÃO CONFIÁVEL\n" + porcentString + "% de certeza."
                        self.situacaoSiteLabel.textColor = UIColor.orange
                    }else{
                        let porcentString = String(format: "%2.2f", porcent)
                        self.situacaoSiteLabel.text = "SITE CONFIÁVEL\n" + porcentString + "% de certeza."
                        self.situacaoSiteLabel.textColor = UIColor.blue
                        
                    }
                }else{
                    self.situacaoSiteLabel.text = "SITE NÃO CONFIÁVEL\nNenhum conteúdo foi obtido para avaliação."
                    self.situacaoSiteLabel.textColor = UIColor.orange
                }

            }else{
                self.situacaoSiteLabel.text = "Não foi possivel avaliar o site, verifique a url digitada."
                self.situacaoSiteLabel.textColor = UIColor.red
                HUD.flash(.error)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.buscarSiteTextField.text != ""{
            self.avaliarSite(url: self.buscarSiteTextField.text)
        }
        return true
    }
    
    func getRestricoes(){
        //        FirebaseDatabaseProvider.sharedInstance.getRestricoes(UserDefaultsProvider.getDispID()!, UserDefaultsProvider.getGerenteID()!) { (array) in
        //            self.restricoesArray = array
        //        }
    }
    
    @IBAction func botaoAvaliarClicado(_ sender: Any) {
        if self.buscarSiteTextField.text != ""{
            self.avaliarSite(url: self.buscarSiteTextField.text)
        }
    }
    
    @IBAction func cancelarClicado(_ sender: Any) {
        self.situacaoSiteLabel.text = ""
        self.buscarSiteTextField.text = ""
    }
    
}

