//
//  DispositivosPaiViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 24/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

struct dispositivo{
    var key:String = ""
    var dispositivoNome:String = ""
    var nomeFilho:String = ""
    var status:String = ""
}

class DispositivosPaiViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var topViewWithImage: UIView!
    @IBOutlet weak var dispositivosTableView: UITableView!
    var dispositivos:Array<dispositivo> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColors.backgroundColor()
        self.dispositivosTableView.backgroundColor = AppColors.backgroundColor()
        self.topViewWithImage.backgroundColor = AppColors.backgroundColor()

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        refreshControl.clipsToBounds = true
        
        dispositivosTableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Dispositivos"
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.adicionarDispositivo))
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButton
        
        self.refreshControl.beginRefreshing()
        self.refresh(sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh(sender:AnyObject) {
        FirebaseDatabaseProvider.sharedInstance.getDevices { (dicionarios) in
            
            self.dispositivos = dicionarios
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.dispositivosTableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dispositivos.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paiCell:PaiTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaiTableViewCell", for: indexPath) as! PaiTableViewCell
        
        let disp:dispositivo = dispositivos[indexPath.row]
        
        paiCell.name.text = disp.nomeFilho
        paiCell.dispositivo.text = disp.dispositivoNome
        paiCell.status.text = disp.status
        
        if paiCell.status.text != "Registrado"{
            paiCell.status.textColor = UIColor.red
        }
        
        return paiCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let disp:dispositivo = dispositivos[indexPath.row]
        DispositivoCoordinator.pushDispositivosTabBarViewController(navigationController: navigationController,disp.nomeFilho, dispositivo: disp);
        FirebaseDatabaseProvider.sharedInstance.adicionarPai()
    }
    func okayAlert(){
        let okayAlertController = UIAlertController(title: "Complete antes de continuar", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {
            alert -> Void in
            
        })
        okayAlertController.addAction(okayAction)
        self.present(okayAlertController, animated: true, completion: nil)
    }
    
    func adicionarDispositivo(){
        let alertController = UIAlertController(title: "Complete Todos os campos", message: "", preferredStyle: .alert)
        
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
            
            PaiCoordinator.pushAdicionarDeviceViewController(nome: name, nomeDisp: nomeDisp, navigationController: self.tabBarController?.navigationController)
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nome do Dispositivo"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Tipo do Dispositivo"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let moreRowAction = UITableViewRowAction(style: .default, title: "Editar", handler:{action, indexpath in
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Remover", handler:{action, indexpath in
            
        });
        
        return [deleteRowAction, moreRowAction];
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
