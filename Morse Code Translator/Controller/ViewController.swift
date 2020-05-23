//
//  ViewController.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 21/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewBackgroundTranslateFromTextView: CustomViewBackgroundTranslateFromTextView!
    @IBOutlet weak var viewBackgroundTranslatedLabel: CustomViewBackgroundTranslatedLabel!
    @IBOutlet weak var translateFromTextView: UITextView!
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateFromTextView.delegate = self
    }

    @IBAction func translatePressed(_ sender: UIButton) {
        if let text = translateFromTextView.text, text.isEmpty {
            self.resetUI()
        }else{
            translatedLabel.text = translateFromTextView.text
        }
        translateFromTextView.endEditing(true)
    }
    
    @IBAction func clearTranslateFromTextViewPressed(_ sender: UIButton) {
        self.resetUI()
    }
    
    @IBAction func useLightButtonPressed(_ sender: UIButton) {
        print("useLightButtonPressed")
    }
    
    @IBAction func playSoundButtonPressed(_ sender: UIButton) {
        print("playSoundButtonPressed")
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        print("shareButtonPressed")
    }
    
    
    private func resetUI() {
        translateFromTextView.text = Constants.placeholders.placeholderTranslateFromTextView
        translateFromTextView.textColor = UIColor(named: Constants.colors.placeholderColorLight)
        translatedLabel.text = Constants.placeholders.placeholderTranslatedLabel
        translatedLabel.textAlignment = .center
    }
}


//MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        translateFromTextView.text = ""
        translateFromTextView.textColor = UIColor(named: Constants.colors.secoundColor)
        translatedLabel.textAlignment = .left
        dismissKeyboardWhenTouchOutside()
    }
    
    func dismissKeyboardWhenTouchOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        if !translateButton.isTouchInside && translateFromTextView.text.isEmpty {
            self.resetUI()
        }
        view.endEditing(true)
    }
    
}
