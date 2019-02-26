//
//  ConfiguracoesViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import PKHUD
class ConfiguracoesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var configuracoesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.configuracoesTableView.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.setRightBarButton(nil, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfiguracoesViewModel.confArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let config:config = ConfiguracoesViewModel.confArray[indexPath.row]

        cell.textLabel?.text = config.nome
        
        if indexPath.row == ConfiguracoesViewModel.confArray.count - 1{
            cell.textLabel?.textColor = UIColor.red
        }else{
            cell.accessoryType = .disclosureIndicator
        }
        cell.layer.borderColor = AppColors.backgroundColor().cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == ConfiguracoesViewModel.confArray.count - 1{
            guard FirebaseProvider.sharedInstance.desconectarUsuario() else{
                HUD.flash(.error)
                return
            }
            HUD.flash(.success)
            
            if let navigation = self.navigationController, let firtsViewController = navigation.viewControllers.first{
                navigation.setViewControllers([firtsViewController], animated: true)
            }
        }else{
            
        }
        
    }
    func editarSenha(){
        let alertController = UIAlertController(title: "Digite a nova senha", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            guard let name = firstTextField.text, name != "" else{
                self.okayAlert()
                return
            }
            guard let nomeDisp = secondTextField.text, nomeDisp != "" else{
                self.okayAlert()
                return
            }
            
            if name == nomeDisp{
                
            }else{
                self.okayAlert()
            }
            

        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nova Senha"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Repita a Nova Senha"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func okayAlert(){
        let okayAlertController = UIAlertController(title: "Complete antes de continuar", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            
        })
        okayAlertController.addAction(okayAction)
        self.present(okayAlertController, animated: true, completion: nil)
    }
    
    func senhaIncorreta(){
        let okayAlertController = UIAlertController(title: "Confira as Senhas Digitas", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            
        })
        okayAlertController.addAction(okayAction)
        self.present(okayAlertController, animated: true, completion: nil)
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
