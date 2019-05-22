    //
//  RestricoesTableViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 16/04/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit

class RestricoesTableViewController: UITableViewController {

    var userID:String?
    
    var arrayRest:Array<RestricaoModel> = []
    
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
        self.tableView.backgroundColor = AppColors.backgroundColor()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        // Do any additional setup after loading the view.
    }
    @objc func refresh(sender:Any){
        getRestricoes()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.adicionarNovaRestricao))
        
        self.tabBarController?.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRestricoes()
    }
    func getRestricoes(){

        self.tableView.refreshControl?.beginRefreshing()
        FirebaseDatabaseProvider.sharedInstance.getRestricoes(self.dipositivoKey, FirebaseDatabaseProvider.sharedInstance.getUserId()) { (array) in
            self.tableView.refreshControl?.endRefreshing()
            self.arrayRest = array
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRest.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    @objc func adicionarNovaRestricao(){
        let controller = AdicionarEditarViewController.getInstance()
        controller.tipoDaAcao = .restricao
        controller.dipositivoKey = dipositivoKey
        controller.isEdit = false
        controller.dimissBlock = {
            self.getRestricoes()
        }
        self.present(controller, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let obje = arrayRest[indexPath.row].stringRestricao ?? ""
        cell.textLabel?.text = obje
        cell.layer.borderColor = AppColors.backgroundColor().cgColor
        return cell
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rest = arrayRest[indexPath.row]
        let moreRowAction = UITableViewRowAction(style: .default, title: "Editar", handler:{action, indexpath in
            let controller = AdicionarEditarViewController.getInstance()
            controller.dipositivoKey = self.dipositivoKey
            controller.tipoDaAcao = .restricao
            controller.isEdit = true
            controller.linkPlaceholder = rest.stringRestricao!
            controller.restrictionKey = rest.key!
            controller.dimissBlock = {
                self.getRestricoes()
            }
            self.present(controller, animated: true, completion: nil)
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Remover", handler:{action, indexpath in
            
            AlertasProvider.alertRemover(self, action: {
                if let restricao = rest.key{
                    FirebaseDatabaseProvider.sharedInstance.removerRestricao(FirebaseDatabaseProvider.sharedInstance.getUserId(), restricao, completion: { _ in
                        self.getRestricoes()
                    })
                }
            })
        });
        
        return [deleteRowAction, moreRowAction];
    }

}
