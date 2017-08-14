//
//  ExcecoesViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class ExcecoesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var excecoesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.excecoesTableView.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
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
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func adicionarNovaExcecao(){
        DispositivoCoordinator.pushAdicionarExcecoesViewController(navigationController: self.navigationController)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Link Do site"
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
