//
//  AtivarMDMViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 04/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class AtivarMDMViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var fazerRegistroBotaoClicado: UIButton!

    @IBAction func fazerRegistroBotaoClicado(_ sender: Any) {
        LoginCoordinatior.pushNavegadorViewController(navigationController: self.navigationController)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
