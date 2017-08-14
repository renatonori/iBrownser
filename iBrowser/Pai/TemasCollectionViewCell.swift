//
//  TemasCollectionViewCell.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class TemasCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nomeTema: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewBloqueio: UIView!
    
    var temaBloqueado:Bool = false
    
    func bloquearTema(){
        self.viewBloqueio.isHidden = !self.viewBloqueio.isHidden
        self.viewBloqueio.backgroundColor = AppColors.backgroundBlackWithAlphaColor()
    }
}
