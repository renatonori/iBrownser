
//
//  BloquearConteudoAdultoViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 23/04/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit
import PKHUD
class BloquearConteudoAdultoViewController: UIViewController {

    @IBOutlet weak var buttonBackground: UIView!
    @IBOutlet weak var bloquearButton: UIButton!
    @IBOutlet weak var blockSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    var dipositivoKey:String!{
        get{
            guard let tabController = self.tabBarController as? DispositivosTabBarViewController else{
                return ""
            }
            return tabController.getKey()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        
        setButton(withStatus: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseDatabaseProvider.sharedInstance.getBloqueio(self.dipositivoKey) { (bloqueado) in
            self.setButton(withStatus: bloqueado)
            HUD.flash(.success)
        }
    }
    func setButton(withStatus:Bool){
        if withStatus{
            self.bloquearButton.setTitle("DESBLOQUEAR", for: .normal)
        }else{
            self.bloquearButton.setTitle("BLOQUEAR", for: .normal)
        }
        self.blockSwitch.isOn = withStatus
    }
    @IBAction func switchChange(_ sender: Any) {
        if let switchItem = sender as? UISwitch{

            FirebaseDatabaseProvider.sharedInstance.setBloquear(self.dipositivoKey, switchItem.isOn)
            self.setButton(withStatus: switchItem.isOn)
        }
       
    }
    
}
