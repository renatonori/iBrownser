//
//  FirebaseProvider.swift
//  iBrowser
//
//  Created by Renato Ioshida on 18/06/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

typealias FirebaseProviderCallback = (Bool, String) -> Swift.Void
class FirebaseProvider{
    
    static let sharedInstance:FirebaseProvider = FirebaseProvider()
    
    func configurarFirebase(){
        FirebaseApp.configure()
        self.comecarDataBaseSecundario()
    }
    func usuarioLogado()->Bool{
        return Auth.auth().currentUser != nil
    }
    func comecarDataBaseSecundario(){
        // Configure with manual options.
        let secondaryOptions = FirebaseOptions(googleAppID: "1:444921685008:ios:b0f1f6ab799fb5f9", gcmSenderID: "444921685008")
        secondaryOptions.bundleID = "ioshida.TrainGetter"
        secondaryOptions.apiKey = "AIzaSyAWBewdBjF5g1UUY8u5-J4YfA_iKbMdTto"
        secondaryOptions.clientID = "444921685008-0lr3du2tou8s8peqgp3gd2peqbmvvlqc.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://naivebayestrainer.firebaseio.com"
        secondaryOptions.storageBucket = "naivebayestrainer.appspot.com"
        
        // Configure an alternative FIRApp.
        FirebaseApp.configure(name: "secondary", options: secondaryOptions)
        

    }
    
    
    func adicionarObservadorDeAutenticacao(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.irParaLogin()
            }
        }
    }
    /** @fn sendPasswordResetWithEmail:completion:
     @brief Initiates a password reset for the given email address.
     
     @param email The email address of the user.
     @param completion Optionally; a block which is invoked when the request finishes. Invoked
     asynchronously on the main thread in the future.
     
     @remarks Possible error codes:
     <ul>
     <li>@c FIRAuthErrorCodeInvalidRecipientEmail - Indicates an invalid recipient email was
     sent in the request.
     </li>
     <li>@c FIRAuthErrorCodeInvalidSender - Indicates an invalid sender email is set in
     the console for this action.
     </li>
     <li>@c FIRAuthErrorCodeInvalidMessagePayload - Indicates an invalid email template for
     sending update email.
     </li>
     </ul>
     */
    func recuperarSenha(_ email:String, completion:@escaping FirebaseProviderCallback){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error as NSError?{
                if let erCode = AuthErrorCode(rawValue: error.code){
                    switch erCode{
                    case .invalidEmail:
                        completion(false, "E-mail invalido, verifique o e-mail digitado")
                        break
                    case .userNotFound:
                        completion(false, "E-mail não registrado, verifique o e-mail registrado")
                        break
                    case .invalidMessagePayload:
                        completion(false, "OinvalidMessagePayload")
                        break
                    default:
                        break
                    }
                }
            }else{
                completion(true, "Nova senha enviada ao E-mail escolhido")
            }
        }
    }
//    @remarks Possible error codes:
//    <ul>
//    <li>@c FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
//    </li>
//    <li>@c FIRAuthErrorCodeEmailAlreadyInUse - Indicates the email used to attempt sign up
//    already exists. Call fetchProvidersForEmail to check which sign-in mechanisms the user
//    used, and prompt the user to sign in with one of those.
//    </li>
//    <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates that email and password accounts
//    are not enabled. Enable them in the Auth section of the Firebase console.
//    </li>
//    <li>@c FIRAuthErrorCodeWeakPassword - Indicates an attempt to set a password that is
//    considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
//    dictionary object will contain more detailed explanation that can be shown to the user.
//    </li>
//    </ul>
    func cadastrarUsuario(_ email:String, password:String, completion:@escaping FirebaseProviderCallback){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error as NSError?{
                if let erCode = AuthErrorCode(rawValue: error.code){
                    switch erCode{
                    case .invalidEmail:
                        completion(false, "E-mail invalido, verifique o e-mail digitado")
                        break
                    case .weakPassword:
                        completion(false, "Senha fraca, verifique a senha digitada")
                        break
                    case .operationNotAllowed:
                        completion(false, "Operação não aceita")
                        break
                    case.emailAlreadyInUse:
                        completion(false, "E-mail já em uso, digite outro")
                        break
                    default:
                        break
                    }
                }
            }else{
                completion(true, "Usuário cadastrado com sucesso")
            }
        }
    }
//    <ul>
//    <li>@c FIRAuthErrorCodeOperationNotAllowed - Indicates that email and password
//    accounts are not enabled. Enable them in the Auth section of the
//    Firebase console.
//    </li>
//    <li>@c FIRAuthErrorCodeUserDisabled - Indicates the user's account is disabled.
//    </li>
//    <li>@c FIRAuthErrorCodeWrongPassword - Indicates the user attempted
//    sign in with an incorrect password.
//    </li>
//    <li>@c FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
//    </li>
//    </ul>
    func logarUsuario(_ email:String, password:String, completion: @escaping FirebaseProviderCallback){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error as NSError?{
                if let erCode = AuthErrorCode(rawValue: error.code){
                    switch erCode{
                    case .invalidEmail:
                        completion(false, "E-mail invalido, verifique o e-mail digitado")
                        break
                    case .wrongPassword:
                        completion(false, "Senha invalida, verifique a senha digitada")
                        break
                    case .operationNotAllowed:
                        completion(false, "Operação não aceita")
                        break
                    case.userDisabled:
                        completion(false, "Conta desabilitada, verifique com o administrador")
                        break
                    default:
                        break
                    }
                }
            }else{
                completion(true, "Usuário logado com sucesso")
            }
        }
    }
    func desconectarUsuario(){
        try! Auth.auth().signOut()
    }
}
