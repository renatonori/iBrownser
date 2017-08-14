//
//  TemasViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 09/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit




class TemasViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var temasCollectionView: UICollectionView!
    var temasArray:Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width:(temasCollectionView.frame.width) - 4, height: (temasCollectionView.frame.height/5) - 5)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 5
        temasCollectionView.collectionViewLayout = layout
        self.view.backgroundColor = AppColors.backgroundColor()
        self.temasCollectionView.backgroundColor = AppColors.backgroundColor()
        // Do any additional setup after loading the view.
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TemasViewModel.pegarTemas().count
    }


    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TemasCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "temaCell", for: indexPath) as! TemasCollectionViewCell

        let tema:temas = TemasViewModel.pegarTemas()[indexPath.row]
        cell.nomeTema.text = tema.name
        //cell.imageView.image = UIImage.init(named: tema.imageName)
        cell.backgroundColor = TemasViewModel.themesColorArray()[indexPath.row]
        cell.labelView.layer.cornerRadius = 10
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:TemasCollectionViewCell = collectionView.cellForItem(at: indexPath) as! TemasCollectionViewCell
        cell.bloquearTema()
        
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
