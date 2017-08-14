//
//  PaiModel.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
struct paiCell {
    var nome:String?
    var descricao:String?
    var index:Int
}
class PaiModel: NSObject {
    static func informationCellForIndexPath(index:Int)->paiCell{
        switch index {
        case 0:
            return self.criarCelulaDoPaiComNome(nome: "Dispositivos Filhos", descricao: "Gerenciar dispositivos filhos", index: index)
        case 1:
            return self.criarCelulaDoPaiComNome(nome: "Black List", descricao: "Gerenciar dispositivos filhos", index: index)
        case 2:
            return self.criarCelulaDoPaiComNome(nome: "White list", descricao: "Gerenciar dispositivos filhos", index: index)
        case 3:
            return self.criarCelulaDoPaiComNome(nome: "Notificações", descricao: "Gerenciar dispositivos filhos", index: index)
        case 4:
            return self.criarCelulaDoPaiComNome(nome: "Exceções", descricao: "Gerenciar dispositivos filhos", index: index)
        default:
            return self.criarCelulaDoPaiComNome(nome: "", descricao: "", index: index)
        }
    }
    
    static func criarCelulaDoPaiComNome(nome:String?,descricao:String?, index:Int)->paiCell{
        let pai:paiCell = paiCell(nome: nome, descricao: descricao, index: index)
        return pai
    }
}
