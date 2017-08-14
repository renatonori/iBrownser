//
//  RecuperarSenhaViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class RecuperarSenhaViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppColors.backgroundColor();
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func recuperarSenhaButtonClicked(_ sender: Any) {
        
        
        RecuperarSenhaModelView.recuperarSenhaComEmail(emailTextField.text) { (success, msg) in
            let alert:UIAlertController = AlertasProvider.alertaSimples("", msg)
            self.present(alert, animated: true, completion: nil)
        }
       // self.navigationController?.popViewController(animated: true);
    }
 

}
