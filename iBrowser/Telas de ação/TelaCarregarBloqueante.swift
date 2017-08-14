//
//  TelaCarregarBloqueante.swift
//  iBrowser
//
//  Created by Renato Ioshida on 05/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class TelaCarregarBloqueante: NSObject {
    
    fileprivate var view:UIView = UIView()
    fileprivate var window:UIWindow = UIApplication.shared.keyWindow!
    fileprivate var refresher:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override init() {
        super.init()
        view = UIView(frame: window.frame)

        view.alpha = 0
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        refresher.center = view.center;
        view.addSubview(refresher)
        refresher.startAnimating()
    }
    
    static let sharedInstance: TelaCarregarBloqueante = {
        let instance = TelaCarregarBloqueante()
        return instance
    }()
    
    static func adicionarTelaBloqueante(){

        TelaCarregarBloqueante.sharedInstance.window.addSubview(TelaCarregarBloqueante.sharedInstance.view)
        
        
    }
}
