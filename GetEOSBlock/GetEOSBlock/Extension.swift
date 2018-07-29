//
//  Extension.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/29/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func simpleAlert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)
        return alertController
    }
}


extension UIViewController {
    
    func handleNetworkManagerErrors(error: APIError) {
        
        switch error {
            
        case .networkError(let networkErrorDescription):
            let networkErrorAlert = UIAlertController.simpleAlert(withTitle: "Error", message: networkErrorDescription)
            self.present(networkErrorAlert, animated: true, completion: nil)
        case .parsingJSONError:
            let parsingJSONError = UIAlertController.simpleAlert(withTitle: "Error", message: "There was a problem with the server")
            self.present(parsingJSONError, animated: true, completion: nil)
            
        default:
            let networkErrorAlert = UIAlertController.simpleAlert(withTitle: "Error", message: "There was a problem with the server")
            self.present(networkErrorAlert, animated: true, completion: nil)
        }
    }
}
