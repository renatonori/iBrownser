//
//  NotificacoesViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class NotificacoesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var notificacoesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.notificacoesTableView.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Link Do site"
        cell.detailTextLabel?.text = "Tema"
        cell.layer.borderColor = AppColors.backgroundColor().cgColor
        cell.layer.borderWidth = 3
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var moreRowAction = UITableViewRowAction(style: .default, title: "Adc. Exceção", handler:{action, indexpath in
            
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
