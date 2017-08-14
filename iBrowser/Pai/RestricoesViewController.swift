//
//  RestricoesViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class RestricoesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var restricoesTableView: UITableView!
    var arrayRest:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.restricoesTableView.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.adicionarNovaRestricao))

        getRestricoes()
        self.tabBarController?.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    func getRestricoes(){
        let teste = self.tabBarController as? DispositivosTabBarViewController
        let value = teste?.getInfoDispositivo()
        let dispID = value?.key
        FirebaseDatabaseProvider.sharedInstance.getRestricoes(dispID!, FirebaseDatabaseProvider.sharedInstance.getUserId()) { (array) in
            self.arrayRest = array
            self.restricoesTableView.reloadData()
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRest.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func adicionarNovaRestricao(){
        let alertController = UIAlertController(title: "Complete para adicionar uma restrição!", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Adicionar", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let teste = self.tabBarController as? DispositivosTabBarViewController
            let value = teste?.getInfoDispositivo()
            let dispID = value?.key
            FirebaseDatabaseProvider.sharedInstance.adicionarRestricao(dispID!,FirebaseDatabaseProvider.sharedInstance.getUserId() , firstTextField.text!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Insira o link do site"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let obje = arrayRest[indexPath.row]
        cell.textLabel?.text = obje
        cell.layer.borderColor = AppColors.backgroundColor().cgColor
        cell.layer.borderWidth = 3
       return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var moreRowAction = UITableViewRowAction(style: .default, title: "Editar", handler:{action, indexpath in
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: .default, title: "Remover", handler:{action, indexpath in
            
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
