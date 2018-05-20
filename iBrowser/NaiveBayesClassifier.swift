//
//  NaiveBayesClassifier.swift
//  iBrowser
//
//  Created by Renato Ioshida on 29/04/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit
import Foundation


typealias TaggedToken = (String, String?) // Can’t add tuples to an array without typealias. Compiler bug... Sigh.
func tag(text: String, scheme: String) -> [TaggedToken] {
    let options: NSLinguisticTagger.Options = [.omitWhitespace,.omitPunctuation,.omitOther]
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
                                    options: Int(options.rawValue))
    tagger.string = text
    
    var tokens: [TaggedToken] = []
    
    // Using NSLinguisticTagger
    tagger.enumerateTags(in: NSMakeRange(0, text.count), scheme:scheme, options: options) { tag, tokenRange, _, _ in
        let token = (text as NSString).substring(with: tokenRange)
        tokens.append((token, tag))
    }
    return tokens
}

func partOfSpeech(text: String) -> [TaggedToken] {
    return tag(text: text, scheme: NSLinguisticTagSchemeLexicalClass)
}
func lemmatize(text: String) -> [TaggedToken] {
    return tag(text: text, scheme: NSLinguisticTagSchemeLemma)
}

func language(text: String) -> [TaggedToken] {
    return tag(text: text, scheme: NSLinguisticTagSchemeLanguage)
}
public typealias Category = String

public class NaiveBayesClassifier {

    static let sharedInstance: NaiveBayesClassifier = NaiveBayesClassifier()
    
    var model:NaiveBayesClassifierModel{
        didSet{
            self.categoryOccurrences = model.categoryOccurrences
            self.tokenOccurrences = model.tokenOccurrences
            self.trainingCount = model.trainingCount
            self.tokenCount = model.tokenCount
        }
    }
    
    private let tokenizer: (String) -> [String]
    
    private var categoryOccurrences: [Category: Int] = [:]
    private var tokenOccurrences: [String: [Category: Int]] = [:]
    private var trainingCount = 0
    private var tokenCount = 0
    
    private let smoothingParameter = 0.0
    
    init() {
        self.tokenizer = { (text: String) -> [String] in
            
            return lemmatize(text: text).map { (token, tag) in
                if let tag = tag, tag != ""{
                    return tag
                }else{
                    return token
                }
            }
        }
        self.model = NaiveBayesClassifierModel()
    }
    
    // MARK: - Classifying
    public func classifyText(text: String) -> Category? {
        let tokensToClassify = self.clearNoEnglishToken(tokens: tokenizer(text))
        if tokensToClassify.count > 0{
            return classifyTokens(tokens: tokensToClassify)
        }else{
            return nil
        }

    }
    func clearNoEnglishToken(tokens:[String])->[String]{
        let clearedTokens:[String] = tokens
        var tokensToClear:[String] = []
        for i in 0..<tokens.count {
            let lang = detectedLangauge(tokens[i])?.lowercased()
            if lang != "english",lang != "ingles",lang != "inglês"{
                tokensToClear.append(tokens[i])
            }
        }
        let result = clearedTokens.filter { element in
            return !tokensToClear.contains(element)
        }
        
        var formatedResult:[String] = []
        
        for token in result{
            formatedResult.append(token.cleared)
        }
        
        return formatedResult
    }
    func detectedLangauge<T: StringProtocol>(_ forString: T) -> String? {
        guard let languageCode = NSLinguisticTagger.dominantLanguage(for: String(forString)) else {
            return nil
        }
        
        let detectedLangauge = Locale.current.localizedString(forIdentifier: languageCode)
        
        return detectedLangauge
    }
    func isEnglishLanguage(text:String)->Bool{
        let result = language(text: text)
        var isAcceptable = false
        for tokentagged in result{
            if let string = tokentagged.1, string == "en" {
                isAcceptable = true
            }else{
                return false
            }
        }
        return isAcceptable
    }
    public func classifyTokens(tokens: [String]) -> Category? {
        // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
        var maxCategory: Category?
        var maxCategoryScore = -Double.infinity
        for (category, _) in categoryOccurrences {
            
            let pCategory = P(category: category)
            
            let score = tokens.reduce(log(pCategory)) { (total, token) in
                // P(W=token|C=cat) = P(C=cat, W=token) / P(C=cat)
 
                return total + log((P(category:category, token) + smoothingParameter) / (pCategory + smoothingParameter + Double(tokenCount)))
            }
            //print("tokens:",tokens,"category:",category,"score:",score,"maxCategoryScore:",maxCategoryScore)
            
            if score > maxCategoryScore {
                
                maxCategory = category
                maxCategoryScore = score
                
            }
        }
        //print("TOKEN:",tokens,"CATEGORY:",maxCategory)
        return maxCategory
    }
    
    // MARK: - Probabilites
    private func P(category: Category, _ token: String) -> Double {
        return Double(tokenOccurrences[token]?[category] ?? 0) / Double(trainingCount)
    }
    
    private func P(category: Category) -> Double {
        
        return Double(totalOccurrencesOfCategory(category: category)) / Double(trainingCount)
    }
    
    // MARK: - Counting
    private func incrementToken(token: String, category: Category) {
        if tokenOccurrences[token] == nil {
            tokenCount += 1
            tokenOccurrences[token] = [:]
        }
        
        // Force unwrap to crash instead of providing faulty results.
        let count = tokenOccurrences[token]![category] ?? 0
        tokenOccurrences[token]![category] = count + 1
    }
    
    private func incrementCategory(category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category: category) + 1
    }
    
    private func totalOccurrencesOfToken(token: String) -> Int {
        if let occurrences = tokenOccurrences[token] {
            
            return occurrences.values.reduce(0,+)
        }
        return 0
    }
    
    private func totalOccurrencesOfCategory(category: Category) -> Int {
        //print("categoryOccurrences",categoryOccurrences[category] ?? 0)
        return categoryOccurrences[category] ?? 0
    }
    public var isSafe:Bool = false
    public var calculatedPorcent:Float = 0.0
    func classify(array:Array<String>, completion:( _ safe:Int,_ unsafe:Int)->Void){
        isSafe = false
        calculatedPorcent = 0.0
        var safe:Int = 0
        var unsafe:Int = 0
        for value in array{
            let result = self.classifyText(text: value)
            if let res = result{
                if res == "safe"{
                    safe += 1
                }else{
                    unsafe += 1
                }
            }

            
        }
        completion(safe,unsafe)
//        calcular(safe, unsafe)
//        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "classificationFinished")))
        
    }
    func calcular(_ safe:Int,_ unsafe:Int){
        let total = Float(safe) + Float(unsafe)
        var acceptablePorcent:Float = 0
        if total > 0{
            acceptablePorcent = (Float(safe)/Float(total)) * 100.0
            if acceptablePorcent > 75.0{
                isSafe = true
            }else{
                isSafe = false
            }
        }else{
            isSafe = true
        }
        calculatedPorcent = acceptablePorcent
    }

}

