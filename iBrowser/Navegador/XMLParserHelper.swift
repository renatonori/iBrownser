//
//  XMLParserHelper.swift
//  iBrowser
//
//  Created by Renato Ioshida on 25/08/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class XMLParserHelper: NSObject {
    
    static let sharedInstance = XMLParserHelper()
    
    var parser = XMLParser()
    
    func parseWebSiteWithURL(_ url:URL!, completionHandler:@escaping (Bool) -> ()){
        parser.delegate = self
        let urlTeste = URL(string:"https://api.androidhive.info/pizza/?format=xml")!
        parser = XMLParser(contentsOf: urlTeste)!
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
        } else {
            print("parse failure!")
        }
    }
    
}

extension XMLParserHelper:XMLParserDelegate{
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        
    }
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        
    }
    func parser(_ parser: XMLParser, foundComment comment: String) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
}
