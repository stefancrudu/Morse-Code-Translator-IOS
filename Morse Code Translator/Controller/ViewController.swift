//
//  ViewController.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 21/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewBackgroundTextView: UIView!
    @IBOutlet weak var viewBackgroundTranslatedLabel: UIView!
    @IBOutlet weak var translateFromTextView: UITextView!
    @IBOutlet weak var translatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViewComponents()
    }

    @IBAction func translatePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func clearTranslateFromTextViewPressed(_ sender: UIButton) {
        
    }
    
}

//MARK: - UITextViewDelegate
extension ViewController {
    
    private func customViewComponents()
    {
        viewBackgroundTextView.layer.cornerRadius = 10
        
        translateFromTextView.text = Constants.fromTextView.placeholderFromTextView
        translateFromTextView.textColor = UIColor(named: Constants.colors.placeholderColorLight)
        
        viewBackgroundTranslatedLabel.layer.borderColor = UIColor(named: Constants.colors.mainColor)?.cgColor
        viewBackgroundTranslatedLabel.layer.borderWidth = 3
        viewBackgroundTranslatedLabel.layer.cornerRadius = 10
        
        translatedLabel.text = Constants.fromTextView.placeholderTranslatedLabel
    }
    
}
