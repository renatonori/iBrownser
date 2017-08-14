//
//  AppColors.swift
//  iBrowser
//
//  Created by Renato Ioshida on 12/05/17.
//  Copyright © 2017 Renato Ioshida. All rights reserved.
//

import Foundation
import UIKit

class AppColors: NSObject {

    static func backgroundColor()->UIColor{
        return UIColor(red: 124.0/255.0, green: 185.0/255.0, blue: 232.0/255.0, alpha: 1)
    }
    static func backgroundBlackWithAlphaColor()->UIColor{
        return UIColor(white: 0, alpha: 0.5)
    }
}
