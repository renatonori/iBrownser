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

class NavegadorViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var cancelButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var buscarSiteTextField: UITextField!
    
    var restricoesArray:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        cancelButtonWidth.constant = 0
        buscarSiteTextField.delegate = self
        webView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        self.buscarSiteTextField.text = "https://www.uol.com.br"

        Alamofire.request("https://www.xvideos.com/").responseString { response in
            //print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html)
            }
        }
        
//        let url = URL (string: "https://www.uol.com.br");
//        let requestObj = URLRequest(url: url!)
//        webView.loadRequest(requestObj)
        
    }
    func parseHTML(_ html:String){
        let result = HTML(html: html, encoding: .utf8)
        var allArrayOfString:Array<Array<String>> = []
        if (result != nil){
            if let teste = result?.css("a,link"){
                for link in teste{
                    if let palavras = link.text, palavras != ""{
                        let arrayDePalavras = palavras.components(separatedBy:" ")
                        if arrayDePalavras.count>1{
                            var arrayPalavraAux:Array<String> = []
                            for palavra in arrayDePalavras{
                                if !palavra.isEmpty, palavra != ""{
                                    arrayPalavraAux.append(palavra)
                                }
                            }
                            allArrayOfString.append(arrayDePalavras)
                        }
                    }
                    
                }
            }
        }
        for arrayDePalavras in allArrayOfString{
            print(arrayDePalavras)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layoutBotaoCancelar()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fazerBuscarDoSite(textField.text != nil ? textField.text! : "")
        return true
    }
    
    func loadRequest(_ url:String!){
        let url = URL(string: "")!
        XMLParserHelper.sharedInstance.parseWebSiteWithURL(url) { teste in
            
        }
//        if(!url.hasPrefix("http://") && !url.hasPrefix("https://")){
//            let teste = "https://" + url
//            let newUrl = URL (string: teste);
//            let requestObj = URLRequest(url: newUrl!)
//            webView.loadRequest(requestObj)
//        }else{
//            let newUrl = URL (string: url);
//            let requestObj = URLRequest(url: newUrl!)
//            webView.loadRequest(requestObj)
//        }
    }
    func getRestricoes(){
        FirebaseDatabaseProvider.sharedInstance.getRestricoes(UserDefaultsProvider.getDispID()!, UserDefaultsProvider.getGerenteID()!) { (array) in
            self.restricoesArray = array
        }
    }

    func fazerBuscarDoSite(_ text:String){
        layoutBotaoCancelar()
        if !text.isEmpty{
            loadRequest(text)
        }
    }
    func layoutBotaoCancelar(){
        
        if cancelButtonWidth.constant == 0{
            cancelButtonWidth.constant = 61
        }else{
            self.buscarSiteTextField.resignFirstResponder()
            cancelButtonWidth.constant = 0
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelarClicado(_ sender: Any) {
        layoutBotaoCancelar()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NavegadorViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        getRestricoes()
        let requestString = request.description
        for req in restricoesArray{
            if requestString == req{
                HUD.flash(.labeledError(title: "Acesso Negado", subtitle: "Site na lista de restrições"), delay: 0.5)
                return false
            }
        }
        
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        let request = webView.request?.url?.absoluteString
        if !(request?.isEmpty)! && buscarSiteTextField.text != request!{
            buscarSiteTextField.text = request!
        }
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let teste = self.buscarSiteTextField.text
        let stringDeBusca = "https://www.google.com.br/#q=" + teste!
        let url = URL (string: stringDeBusca);
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
        if let teste = html{
            print(teste)
        }
    }
}
