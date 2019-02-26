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

class DispositivosPaiViewController: CustomViewController,UITableViewDataSource,UITableViewDelegate {
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
        paiCell.key = disp.key
        
        if paiCell.status.text != "Registrado"{
            paiCell.status.textColor = UIColor.red
        }
        
        return paiCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let disp:dispositivo = dispositivos[indexPath.row]
        DispositivoCoordinator.pushDispositivosTabBarViewController(navigationController: navigationController,disp.nomeFilho, dispositivo: disp);
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
        
        let controller = AdicionarEditarViewController.getInstance()
        controller.tipoDaAcao = .device
        controller.isEdit = false
        controller.addDeviceBlock = { qrCode,nome,nomeDisp, sucess in
            PaiCoordinator.pushAdicionarDeviceViewController(qrCode:qrCode, nome: nome, nomeDisp: nomeDisp, navigationController: self.tabBarController?.navigationController)
        }

        self.present(controller, animated: true, completion: nil)
//        
//        AlertasProvider.alertAdicionarDisp(self, placeholders: ["Nome do Dispositivo","Tipo do Dispositivo"], textFields: ["",""]) { (newValues) in
//            let name = newValues[0]
//            let nomeDisp = newValues[1]
//   
//        }

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let disp:dispositivo = dispositivos[indexPath.row]
        let moreRowAction = UITableViewRowAction(style: .default, title: "Editar", handler:{action, indexpath in
            self.editar(disp.dispositivoNome, disp.nomeFilho, disp.key)
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Remover", handler:{action, indexpath in
            self.deletar(disp.key)
        });
        return [deleteRowAction, moreRowAction];
    }
    func deletar(_ key:String){
        AlertasProvider.alertRemover(self) {
            
        }
    }
    func editar(_ nome:String, _ tipo:String, _ key:String){
        let controller = AdicionarEditarViewController.getInstance()
        controller.tipoDaAcao = .device
        controller.isEdit = true
        controller.dipositivoKey = key
        controller.nomeDispositivoPlaceholder = nome
        controller.dispositivoPlaceholder = tipo
        controller.dimissBlock = {
            self.refresh(sender: self)
        }
        self.present(controller, animated: true, completion: nil)

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
