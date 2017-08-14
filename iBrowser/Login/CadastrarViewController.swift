//
//  CadastrarViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class CadastrarViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor();
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.title = "Cadastrar"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cadastrarButtonClicked(_ sender: Any) {
        
        CadastrarUsuarioViewModel.criarUsuario(emailTextField.text, senhaTextField.text) { (success, msgErro) in
            if !success{
                let alert:UIAlertController = AlertasProvider.alertaSimples("", msgErro)
                self.present(alert, animated: true, completion: nil)
            }

        }
        
    }
}
