//
//  UserDefaultsProvider.swift
//  iBrowser
//
//  Created by Renato Ioshida on 18/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class UserDefaultsProvider: NSObject {
    
    static let userDefault = UserDefaults.standard
    
    static func setUserID(_ id:String){
        userDefault.setValue(id, forKey: "userID")
    }
    static func getUserID(){
        userDefault.value(forKey: "userID")
    }
    
    static func setGerenteID(_ id:String){
        userDefault.set(id, forKey: "gerenteID")
    }
    static func getGerenteID()->String?{
        return userDefault.string(forKey: "gerenteID")
    }
    static func setDispID(_ id:String){
        userDefault.set(id, forKey: "DispID")
    }
    static func getDispID()->String?{
        return userDefault.string(forKey: "DispID")
    }
}
