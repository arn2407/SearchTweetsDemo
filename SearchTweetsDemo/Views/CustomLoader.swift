//
//  CustomLoader.swift
//  SearchTweetsDemo
//
//  Created by Arun Kumar on 23/09/17.
//  Copyright © 2017 NEO. All rights reserved.
//

import Foundation
import UIKit

class CustomLoader : NSObject
{
    static let loader = CustomLoader()
    
    private lazy var view : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        return v
    }()
    private lazy var indicator : UIActivityIndicatorView = {
        let indi = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        indi.hidesWhenStopped = true
        return indi
    }()
    func showLoader()  {
        guard let window = UIApplication.shared.keyWindow else {return}
        window.addSubview(view)
        view.frame = window.bounds
        view.alpha = 0.0
        window.addSubview(indicator)

        indicator.center = view.center
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.view.alpha = 1.0
            
        }) { (isFinished) in
            if isFinished {
                self.indicator.startAnimating()
            }
        }
    }
    func hideLoader()  {
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.view.alpha = 0.0
            
        }) { (isFinished) in
            if isFinished {
                self.view.removeFromSuperview()
                self.indicator.stopAnimating()
            }
        }
    }
}
