//
//  StartViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import PKHUD
class StartViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor();
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fazerLogin(){
        HUD.show(.progress)
        StartViewModel.logarUsuario(emailTextField.text, senhaTextField.text) { (sucesso, msgDeErro) in
            if !sucesso{
                HUD.hide()
                let alert:UIAlertController = AlertasProvider.alertaSimples("", msgDeErro)
                self.present(alert, animated: true, completion: nil)
            }else{
                HUD.flash(.success, delay: 0.5)
                PaiCoordinator.pushPaiTabBarViewController(navigationController: self.navigationController)
            }
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        fazerLogin()
    }
    
    @IBOutlet weak var cadastrarBotaoClicado: UIButton!

    @IBAction func cadastrarBotaoClicakdo(_ sender: Any) {
        StartCoordinatior.pushCadastrarViewController(navigationController: self.navigationController)
    }
    @IBAction func activeSonButtonClicked(_ sender: Any) {
        //ir para aticação do filho
        StartCoordinatior.pushAtivacaoViewController(navigationController: self.navigationController)
    }
    @IBAction func recuperarSenharButtonClicked(_ sender: Any) {
        LoginCoordinatior.pushRecuperarSenhaViewController(navigationController: self.navigationController)
    }
}
