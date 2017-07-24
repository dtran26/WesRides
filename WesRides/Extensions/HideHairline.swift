//
//  HideHairline.swift
//  WesRides
//
//  Created by Dan on 7/24/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation


protocol HideableHairlineViewController {
    
    func hideHairline()
    func showHairline()
}

extension HideableHairlineViewController where Self: UIViewController {
    
    func hideHairline() {
        findHairline()?.isHidden = true
    }
    
    func showHairline() {
        findHairline()?.isHidden = false
    }
    
    private func findHairline() -> UIImageView? {
        return navigationController?.navigationBar.subviews
            .flatMap { $0.subviews }
            .flatMap { $0 as? UIImageView }
            .filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
            .filter { $0.bounds.size.height <= 2 }
            .first
    }
    
}
