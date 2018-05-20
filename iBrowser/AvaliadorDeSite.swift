//
//  AvaliadorDeSite.swift
//  iBrowser
//
//  Created by Renato Ioshida on 29/04/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class AvaliadorDeSite: NSObject {
    
    static let sharedInstance: AvaliadorDeSite = AvaliadorDeSite()
    
    
    
    func avaliarComURLString(url:String, completion:@escaping (Bool,Double,Bool,Bool)->()){
        Alamofire.request(self.adicionarPrefixo(url: url)).responseString { response in
            if let html = response.result.value {
                self.comecarAvaliacao(withHTML: html, completion: { (acceptable,porcent,noResult) in
                    completion(acceptable,porcent,true,noResult)
                })
            }else{
                completion(false,0,false,false)
            }
        }
    }
    private func adicionarPrefixo(url:String)->String{
        if url.hasPrefix("http://") || url.hasPrefix("https://"){
            return url
        }else{
            return "https://" + url
        }
    }
    
    private func comecarAvaliacao(withHTML:String, completion:@escaping (Bool,Double,Bool)->()){
        

        if let imageArray = parseHTML(html: withHTML), let textArray = parseHTMLText(html: withHTML){
            NudityClassifier.sharedInstance.classifyImages(withArray: imageArray) { (safe, unsafe) in
                NaiveBayesClassifier.sharedInstance.classify(array: textArray, completion: { (textSafe,textUnsafe) in
                    self.calculateSafatyValue(safe, unsafe, textSafe, textUnsafe, completion: { (isSafe, porcent, noResult)  in
                        completion(isSafe,porcent,noResult)
                    })
                })
            }
        }
    }
    private func calculateSafatyValue(_ imageSafe:Int,_ imageUnsafe:Int,_ textSafe:Int,_ textUnsafe:Int, completion:(_ isSafe:Bool, _ certainPorcentResult:Double, _ noResult:Bool)->Void){


        
        let textTotal = textSafe + textUnsafe
        let imageTotal = imageSafe + imageUnsafe
        
        if textTotal == 0, imageTotal != 0{
            let imageSafePorcent = avaliateImage(imageSafe, imageUnsafe)
            let imageIsSafe = imageSafePorcent >= 75.0
            
            completion(imageIsSafe, imageSafePorcent,false)
        }else if imageTotal == 0, textTotal != 0{
            let textSafePorcent = avaliateText(textSafe, textUnsafe)
            let textIsSafe = textSafePorcent >= 75.0
            
            completion(textIsSafe, textSafePorcent,false)
        }else if imageTotal == 0, textTotal == 0{
            completion(true,0,true)
        }else{
            let textSafePorcent = avaliateText(textSafe, textUnsafe)
            let imageSafePorcent = avaliateImage(imageSafe, imageUnsafe)
            
            let imageIsSafe = imageSafePorcent >= 75.0
            let textIsSafe = textSafePorcent >= 75.0
            
            let finalSafe = imageIsSafe && textIsSafe
            
            let finalPorcent = (imageSafePorcent + textSafePorcent)/2
            
            completion(finalSafe, finalPorcent,false)
        }
    }
    func avaliateText(_ textSafe:Int,_ textUnsafe:Int)->Double{
        let textTotal = textSafe + textUnsafe
        let result = Double(textSafe)/Double(textTotal) * 100
        return result
    }
    func avaliateImage(_ imageSafe:Int,_ imageUnsafe:Int) -> Double{
        let imageTotal = imageSafe + imageUnsafe
        let result = Double(imageSafe)/Double(imageTotal) * 100
        return result
    }
    private func parseHTMLText(html:String)->Array<String>?{
        do{
            let result = try HTML(html: html, encoding: .utf8)
            let resultBody = result.body
            var arrayOfText:Array<String> = []
            if let resBody = resultBody{
                for link in resBody.xpath("//a"){
                    if let palavras = link.text, palavras != ""{
                        let palavrasFiltradas = palavras.cleared
                        let palavraParaAdicionar = palavrasFiltradas.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !palavraParaAdicionar.isEmpty{
                            arrayOfText.append(palavraParaAdicionar)
                        }
                    }
                }
                
            }
            return arrayOfText
        }catch{
            return nil
        }
    }
    private func parseHTML(html:String)->Array<String>?{
        do{
            let result = try HTML(html: html, encoding: .utf8)
            let resultBody = result.body
            var arrayOfLink:Array<String> = []
            if let resBody = resultBody{
                for link in resBody.xpath("//img"){

                    if let linkSRC = link["src"]{
                        if !arrayOfLink.contains(linkSRC){
                            arrayOfLink.append(linkSRC)
                        }
                    }
                    if let linkDataSRC = link["data-src"]{
                        if !arrayOfLink.contains(linkDataSRC){
                            arrayOfLink.append(linkDataSRC)
                        }
                    }
                }
                
            }
            return arrayOfLink
        }catch{
            return nil
        }
    }
    
}
extension String {
    var cleared: String {
        let bar = self.folding(options: .diacriticInsensitive, locale: .current)
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        return String(bar.filter {okayChars.contains($0) }).lowercased()
    }
}
