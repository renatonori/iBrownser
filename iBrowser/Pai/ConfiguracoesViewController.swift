//
//  ConfiguracoesViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class ConfiguracoesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var configuracoesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.configuracoesTableView.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
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
            FirebaseProvider.sharedInstance.desconectarUsuario()
        }else{
            
        }
        
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
