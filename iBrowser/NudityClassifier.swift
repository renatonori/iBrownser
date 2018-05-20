//
//  NudityClassifier.swift
//  iBrowser
//
//  Created by Renato Ioshida on 29/04/2018.
//  Copyright © 2018 Renato Ioshida. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreML

protocol NudityClassifierDelegate {
    func newImage(arrayOfImages:Array<UIImage>)
}
class NudityClassifier: NSObject {
    
    static let sharedInstance:NudityClassifier = NudityClassifier()
    var delegate:NudityClassifierDelegate?
    
    var arrayOfImages:Array<UIImage>?{
        didSet{
            if let newimages = arrayOfImages{
                self.delegate?.newImage(arrayOfImages: newimages)
            }  
        }
    }
    
    func classifyImages(withArray urlArray:Array<String>, completion:@escaping (_ safe:Int,_ unsafe:Int)->()){
        calculateRisk(withArray: urlArray) { (acceptable, notAcceptable)  in
            completion(acceptable,notAcceptable)
        }
    }
    
    private func calculateRisk(withArray urlArray:Array<String>, completion:@escaping (_ safe:Int,_ unsafe:Int)->()){
        nudityClasssifier(withArray: urlArray) { (acceptable, notAcceptable) in
            completion(acceptable,notAcceptable)
        }
    }
    
    private func nudityClasssifier(withArray urlArray:Array<String>, completion:@escaping (Int,Int)->()){
        var numberOfAcceptableImages:Int = 0
        var numberOfNotAcceptableImages:Int = 0
        var imagesCount:Int = 0
        for imgURL:String in urlArray{
            getImage(urlString: imgURL) { (resultedImage) in
                if let image = resultedImage{
                    self.getBufferedImage(withImage: image, completion: { (buferedImage) in
                        if let bufImage = buferedImage{
                            self.predictAndClassify(withBuffer: bufImage, completion: { (accepted,success) in
                                
                                if success{
                                    accepted == true ? (numberOfAcceptableImages += 1) : (numberOfNotAcceptableImages += 1)
                                }
                                callCompletion()
                            })
                        }else{
                            callCompletion()
                        }
                    })
                }else{
                    callCompletion()
                }
            }
        }
        if urlArray.count == imagesCount{
            completion(numberOfAcceptableImages,numberOfNotAcceptableImages)
        }
        func callCompletion(){
            imagesCount += 1
            if urlArray.count == imagesCount{
                completion(numberOfAcceptableImages,numberOfNotAcceptableImages)
            }
        }
    }
    
    private func getImage(urlString:String, completion:@escaping (UIImage?)->()){
        Alamofire.request(urlString).responseImage { response in
            //debugPrint(response)
            if response.result.isSuccess{
                if let image:UIImage = response.result.value {
                    //print("image downloaded: \(image)")
                    completion(image)
                }else{
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }
    }
    private func getBufferedImage(withImage image:UIImage, completion:@escaping (_ bufferedImage:CVPixelBuffer?)->()){
        let imageSize:CGSize = CGSize(width: 224, height: 224)
        
        if let buffer = image.resize(to: imageSize)?.pixelBuffer(){
            completion(buffer)
        }else{
            completion(nil)
        }
        
    }
    private func predictAndClassify(withBuffer bufferedImage:CVPixelBuffer, completion:@escaping (_ safe:Bool, _ success:Bool)->()){
        let model = Nudity()
        if let result = try? model.prediction(data: bufferedImage){
            let confidence = result.prob["\(result.classLabel)"]! * 100.0
            if result.classLabel == "SFW" && confidence >= 75.0{
                completion(true,true)
            }else{
                completion(false,true)
            }
        }else{
            completion(false,false)
        }
    }
}
