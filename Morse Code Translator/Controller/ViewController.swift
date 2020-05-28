//
//  ViewController.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 21/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    
    @IBOutlet weak var translateFromTextView: UITextView! {
        didSet { translateFromTextView.delegate = self }
    }
    
    let translatorManager = TranslatorManager()
    let soundManager = SoundManager()

    @IBAction func translatePressed(_ sender: UIButton) {
        if let text = translateFromTextView.text, !text.isEmpty {
            translatedLabel.text = translatorManager.getMorseCode(from: text)
        } else {
            resetUI()
        }
        translateFromTextView.endEditing(true)
    }
    
    @IBAction func clearTranslateFromTextViewPressed(_ sender: UIButton) {
        resetUI()
    }
    
    @IBAction func useLightButtonPressed(_ sender: UIButton) {
        print("useLightButtonPressed")
    }
    
    @IBAction func playSoundButtonPressed(_ sender: UIButton) {
        if let translateFromText = translatedLabel.text {
            soundManager.playMorseSound(from: translateFromText)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let text = translatedLabel.text, text.contains("-") || text.contains("·") {
            let activityControler = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            present(activityControler, animated: true, completion: nil)
        } else {
            let text = Constants.shareMessage
            let activityControler = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            present(activityControler, animated: true, completion: nil)
        }
    }
    
    private func resetUI() {
        translateFromTextView.text = Constants.placeholderTranslateFromTextView
        translateFromTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        translatedLabel.text = Constants.placeholderTranslatedLabel
        translatedLabel.textAlignment = .center
    }
}


//MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        translateFromTextView.text = ""
        translateFromTextView.textColor = #colorLiteral(red: 0.3330000043, green: 0.3330000043, blue: 0.3330000043, alpha: 1)
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

// MARK: - Constants
extension ViewController {
    enum Constants {
        static let placeholderTranslateFromTextView = "Type someting..."
        static let placeholderTranslatedLabel = "What do you want to translate in morse code?"
        
        static let shareMessage = "Hi,\nI use Code Morse Translator from https://github.com/stefancrudu/Morse-Code-Translator-IOS. \nCheck it now!"
    }
}
