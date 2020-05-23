//
//  CostumElementsForViewController.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 23/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import UIKit

class CustomViewBackgroundTranslateFromTextView: UIView {
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.initCommon()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initCommon()
    }

    private func initCommon() {
        layer.cornerRadius = 10
    }
    
}
