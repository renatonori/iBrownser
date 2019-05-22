//
//  ExcecoesTableViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 16/04/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit

class ExcecoesTableViewController: UITableViewController {

    var arrayExcecoes:Array<ExcecaoModel> = []
    
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
        self.getExcecoes()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.adicionarNovaExcecao))
        
        self.tabBarController?.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getExcecoes()
    }
    
    func getExcecoes(){

        FirebaseDatabaseProvider.sharedInstance.getExcecoes(self.dipositivoKey, FirebaseDatabaseProvider.sharedInstance.getUserId()) { (array) in
            self.arrayExcecoes = array
            self.tableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayExcecoes.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    @objc func adicionarNovaExcecao(){
        let controller = AdicionarEditarViewController.getInstance()
        controller.tipoDaAcao = .excecao
        controller.dipositivoKey = dipositivoKey
        controller.isEdit = false
        controller.dimissBlock = {
            self.getExcecoes()
        }
        self.present(controller, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let obje = arrayExcecoes[indexPath.row].stringExcecao
        cell.textLabel?.text = obje
        cell.layer.borderColor = AppColors.backgroundColor().cgColor

        return cell
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let exce = arrayExcecoes[indexPath.row]
        let moreRowAction = UITableViewRowAction(style: .default, title: "Editar", handler:{action, indexpath in
            let controller = AdicionarEditarViewController.getInstance()
            controller.dipositivoKey = self.dipositivoKey
            controller.tipoDaAcao = .excecao
            controller.isEdit = true
            controller.linkPlaceholder = exce.stringExcecao!
            controller.exectionKey = exce.key!
            controller.dimissBlock = {
                self.getExcecoes()
            }
            self.present(controller, animated: true, completion: nil)
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Remover", handler:{action, indexpath in
  
            AlertasProvider.alertRemover(self, action: {
                if let excecao = exce.key{
                    FirebaseDatabaseProvider.sharedInstance.removerExcecoes(FirebaseDatabaseProvider.sharedInstance.getUserId(), excecao, completion: { _ in
                        self.getExcecoes()
                    })
                }
            })
        });
        
        return [deleteRowAction, moreRowAction];
    }
    

}
