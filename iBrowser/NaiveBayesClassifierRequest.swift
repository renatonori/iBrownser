//
//  NaiveBayesClassifierRequest.swift
//  iBrowser
//
//  Created by Renato Ioshida on 10/05/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class NaiveBayesClassifierRequest: NSObject {
    static let sharedInstace:NaiveBayesClassifierRequest = NaiveBayesClassifierRequest()
    
    var ref: DatabaseReference? = nil
    
    override init() {
        super.init()
        ref = databaseReference()
    }
    
    
    func databaseReference()->DatabaseReference{
    // Retrieve a previous created named app.
        guard let secondary = FirebaseApp.app(name: "secondary")
        else { assert(false, "Could not retrieve secondary app") }
    
    
    // Retrieve a Real Time Database client configured against a specific app.
      return Database.database(app: secondary).reference()
    }
    func getTrainedValues(completion:@escaping (_ naiveBayesModel:NaiveBayesClassifierModel)->Void){
        ref?.observeSingleEvent(of: .value, with: { snapshot in
            var categoryOccurrences: [Category: Int] = [:]
            var tokenOccurrences: [String: [Category: Int]] = [:]
            var trainingCount = 0
            var tokenCount = 0
            
            if let dict = snapshot.value as? NSDictionary{
                categoryOccurrences = dict["categoryOccurrences"] as! [Category : Int]
                tokenOccurrences = dict["tokenOccurrences"] as! [String : [Category : Int]]
                trainingCount = dict["trainingCount"] as! Int
                    tokenCount = dict["tokenCount"] as! Int
            }
            let nvModel = NaiveBayesClassifierModel()
            
            nvModel.categoryOccurrences = categoryOccurrences
            nvModel.tokenOccurrences = tokenOccurrences
            nvModel.trainingCount = trainingCount
            nvModel.tokenCount = tokenCount
            
            completion(nvModel)
        })
    }
}
