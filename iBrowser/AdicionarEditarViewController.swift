//
//  AdicionarRestricaoOuExcecoesViewController.swift
//  iBrowser
//
//  Created by Renato Ioshida on 20/08/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit
import PKHUD

enum AcoesTipo{
    case restricao
    case device
    case excecao
}

class AdicionarEditarViewController: UIViewController {
    
    static func getInstance() -> AdicionarEditarViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let vc = storyboard.instantiateViewController(withIdentifier: "AdicionarEditarViewController") as! AdicionarEditarViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    

    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var nomeDoDispositivoTextField: UITextField!
    @IBOutlet weak var adicionarUIButton: UIButton!
    @IBOutlet weak var dispositivoTextField: UITextField!
    @IBOutlet weak var cancelarUIButton: UIButton!
    @IBOutlet weak var salvarUIButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var tipoDaAcao:AcoesTipo = .excecao
    var isEdit:Bool = false
    
    var dipositivoKey:String!
    
    var exectionKey:String = ""
    var restrictionKey:String = ""
    var despositivoKey:String = ""
    
    var linkPlaceholder = ""
    var nomeDispositivoPlaceholder = ""
    var dispositivoPlaceholder = ""
    var dimissBlock:(()->Void)? = nil
    var addDeviceBlock:((_ qrCode:String,_ nome:String, _ nomeDoDispositivo:String,_ finished:Bool)->Void)? = nil
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.boxView.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dimissBlock?()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch self.tipoDaAcao {
        case .device:
            self.configurarDispositivos()
            break
        case .excecao:
            self.configurarExcecoes()
            break
        case .restricao:
            self.configurarExcecoes()
            break
        }
        self.configurarTitulo()
    }
    func configurarTitulo(){
        switch self.tipoDaAcao {
        case .device:
            if isEdit{
                self.titleLabel.text = "Editar Dispositivo"
            }else{
                self.titleLabel.text = "Adicionar Dipositivo"
            }
            break
        case .excecao:
            if isEdit{
                self.titleLabel.text = "Editar Exceção"
            }else{
                self.titleLabel.text = "Adicionar Exceção"
            }
            
            break
        case .restricao:
            if isEdit{
                self.titleLabel.text = "Editar Restrição"
            }else{
                self.titleLabel.text = "Adicionar Restrição"
            }
            
            break
        }
    }

    func configurarExcecoes(){
        self.linkTextField.text = self.linkPlaceholder
        self.dispositivoTextField.isHidden = true
        self.nomeDoDispositivoTextField.isHidden = true
        if self.isEdit{
            self.adicionarUIButton.isHidden = true
        }else{
            self.salvarUIButton.isHidden = true
        }
    }
    func configurarDispositivos(){
        self.nomeDoDispositivoTextField.text = self.nomeDispositivoPlaceholder
        self.dispositivoTextField.text  = self.dispositivoPlaceholder
        self.linkTextField.isHidden = true
        if self.isEdit{
            self.adicionarUIButton.isHidden = true
        }else{
            self.salvarUIButton.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adicionarClickado(_ sender: Any) {
        self.salvarAction()
    }
    @IBAction func cancelarClickado(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func salvarClickado(_ sender: Any) {
        self.adicionarAction()
    }
    func adicionarAction(){
        switch self.tipoDaAcao {
        case .device:
            self.verificarAdicaoDispositivo()
            break
        case .excecao:
            self.verificarAdicaoExcecaoRestricao()
            break
        case .restricao:
            self.verificarAdicaoExcecaoRestricao()
            break
        }
    }
    func salvarAction(){
        switch self.tipoDaAcao {
        case .device:
            self.verificarAdicaoDispositivo()
            break
        case .excecao:
            self.verificarAdicaoExcecaoRestricao()
            break
        case .restricao:
            self.verificarAdicaoExcecaoRestricao()
            break
        }
    }
    private func adicionarPrefixo(url:String)->String{
        if url.hasPrefix("http://") || url.hasPrefix("https://"){
            return url
        }else{
            return "https://" + url
        }
    }
    func verificarAdicaoDispositivo(){
        guard let nome = self.nomeDoDispositivoTextField.text, nome.count > 0,
            let dispNome = dispositivoTextField.text, dispNome.count > 0 else{
                HUD.flash(.labeledError(title: "Complete todos os campos antes de continuar", subtitle: ""), onView: nil, delay: 2, completion: nil)
                return
        }
        self.adicionarEditarDispositivo(nome, nomeDisp: dispNome)
    }
    func adicionarEditarDispositivo(_ nome:String, nomeDisp:String){
        if self.isEdit{
            FirebaseDatabaseProvider.sharedInstance.editarDevice(self.dipositivoKey, nome, nomeDisp: nomeDisp) { (result) in
                self.dismiss(animated: true, completion: nil)
                self.dimissBlock?()
            }
        }else{
            FirebaseDatabaseProvider.sharedInstance.adicionarFilho(nome, nomeDisp) { (qrCode,success)  in
                self.dismiss(animated: true, completion: nil)
                self.addDeviceBlock?(qrCode,nome,nomeDisp,success)
            }
        }
    }
    func verificarAdicaoExcecaoRestricao(){
        guard let linkAdicionado = self.linkTextField.text, linkAdicionado.count > 0 else{
            HUD.flash(.labeledError(title: "Insira uma URL para poder continuar", subtitle: ""), onView: nil, delay: 2, completion: nil)
            return
        }
        let urlComPrefixo = self.adicionarPrefixo(url: linkAdicionado)
        
        self.mostrarAlerta(urlComPrefixo)
        
    }
    
    
    func mostrarAlerta(_ urlString:String){
        let alertController = UIAlertController(title: "Antes de continuar verifique a URL", message: "Caso a URL não esteja correta pode ocasionar mal funcionamento", preferredStyle: .alert)
        let titleSave = self.isEdit ? "Salvar" : "Adicionar"
        let saveAction = UIAlertAction(title: titleSave, style: .default, handler: {
            alert -> Void in
            
            if self.tipoDaAcao == .restricao{
                if self.isEdit{
                    FirebaseDatabaseProvider.sharedInstance.editarRestricao(self.dipositivoKey, FirebaseDatabaseProvider.sharedInstance.getUserId(), self.restrictionKey, urlString, completion: { (result) in
                        self.dismiss(animated: true, completion: nil)
                        self.dimissBlock?()
                    })
                }else{
                    FirebaseDatabaseProvider.sharedInstance.adicionarRestricao(self.dipositivoKey,FirebaseDatabaseProvider.sharedInstance.getUserId() , urlString, completion: { result in
                        self.dismiss(animated: true, completion: nil)
                        self.dimissBlock?()
                        
                    })
                }
            }else{
                if self.isEdit{
                    FirebaseDatabaseProvider.sharedInstance.editarExcecoes(self.dipositivoKey, FirebaseDatabaseProvider.sharedInstance.getUserId(), self.exectionKey, urlString, completion: { (result) in
                        self.dismiss(animated: true, completion: nil)
                        self.dimissBlock?()
                    })
                }else{
                FirebaseDatabaseProvider.sharedInstance.adicionarExcecoes(self.dipositivoKey,FirebaseDatabaseProvider.sharedInstance.getUserId() , urlString, completion: { result in
                        self.dismiss(animated: true, completion: nil)
                        self.dimissBlock?()
                    })
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
