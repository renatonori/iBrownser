//
//  AdicionarDeviceViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 08/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import PKHUD
class AdicionarDeviceViewController: UIViewController {

    var nome:String = ""
    var nomeDispositivo:String = "" 
    var qrcodeImage: CIImage!
    weak var timer:Timer?
    
    var dispID:String = ""
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.backgroundColor()
        self.title = "Adicionar Filho"
        // Do any additional setup after loading the view.
        gerarQRCode()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
        verificarAntesDeSair()
    }
    func verificarAntesDeSair(){
        FirebaseDatabaseProvider.sharedInstance.esperandoDispositivoFilhoLinkar(dispID) { (succes) in
            if !succes{
                FirebaseDatabaseProvider.sharedInstance.removerFilho(self.dispID)
            }
        }
    }
    func esperandoLeitura()
    {
        FirebaseDatabaseProvider.sharedInstance.esperandoDispositivoFilhoLinkar(dispID) { (succes) in
            if succes{
                self.timer?.invalidate()
                HUD.flash(.labeledSuccess(title: "Dispositivo vinculado", subtitle: ""), delay: 0.5)
                
            }
        }

    }
    func ativarTimeDeLeitura(){
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.esperandoLeitura()
        }
    }
    func gerarQRCode(){
        if qrcodeImage == nil {
            
            let qrCode = FirebaseDatabaseProvider.sharedInstance.adicionarFilho(nome, nomeDispositivo)
            dispID = qrCode.components(separatedBy: ";").first ?? ""
            let data = qrCode.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            
            qrCodeImageView.image = UIImage(ciImage: qrcodeImage)
            
            ativarTimeDeLeitura()
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
