//
//  PaiViewModel.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class PaiViewModel: NSObject {
    
    static var paiListArray:NSArray{
        get{
            return self.criarPaiArray()
        }
    }
    static func criarPaiArray()->NSArray{
        let array:NSMutableArray = NSMutableArray()
        array.add(PaiModel.informationCellForIndexPath(index: 0))
        array.add(PaiModel.informationCellForIndexPath(index: 1))
        array.add(PaiModel.informationCellForIndexPath(index: 2))
        array.add(PaiModel.informationCellForIndexPath(index: 3))
        array.add(PaiModel.informationCellForIndexPath(index: 4))
        return array
    }
    

}
