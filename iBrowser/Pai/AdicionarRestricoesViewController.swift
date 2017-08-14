//
//
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit

class AdicionarRestricoesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var restricoesTableViewController: UITableView!
    
    @IBOutlet weak var linkDoSite: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.restricoesTableViewController.backgroundColor = AppColors.backgroundColor()
        self.title = "Adicionar Restrição"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teste:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        teste.textLabel?.text = "TEMA"
        
        return teste
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
