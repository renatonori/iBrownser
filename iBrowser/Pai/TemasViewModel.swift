//
//  TemasViewModel.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class TemasViewModel: NSObject {
    static func pegarTemas()->Array<temas>{
        var array:Array<temas> = []
        array.append(temas.init(name: "Noticias", imageName: "temas-noticias"))
        array.append(temas.init(name: "Esportes", imageName: "temas-esportes"))
        array.append(temas.init(name: "Entretenimento", imageName: "temas-entretenimento"))
        array.append(temas.init(name: "Conteúdo Adulto", imageName: "temas-adulto"))
        return array;
     }
    
    
    static func themesColorArray()->Array<UIColor>{
        var array:Array<UIColor> = []
        array.append(UIColor(red: 167.0/255.0, green: 234.0/255.0, blue: 134.0/255.0, alpha: 1))
        array.append(UIColor(red: 234.0/255.0, green: 217.0/255.0, blue: 134.0/255.0, alpha: 1))
        array.append(UIColor(red: 234.0/255.0, green: 134.0/255.0, blue: 134.0/255.0, alpha: 1))
        array.append(UIColor(red: 234.0/255.0, green: 134.0/255.0, blue: 217.0/255.0, alpha: 1))
        return array
    }
}
