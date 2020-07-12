//
//  ViewController.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 21/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var useLightButtonLabel: UILabel!
    @IBOutlet weak var playSoundButtonLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var appBackground: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var translateFromTextView: UITextView! {
        didSet { translateFromTextView.delegate = self }
    }
    @IBOutlet weak var translateFromMorseCodeView: UITextView! {
        didSet { translateFromMorseCodeView.delegate = self }
    }

    let translatorManager = TranslatorManager()
    let soundManager = SoundManager()
    let backgroundDispatchQueue = DispatchQueue.global(qos: .background)
    var buttonTrigger: String = ""

    @IBAction func translatePressed(_ sender: UIButton) {
        view.endEditing(true)
        switch buttonTrigger {
            case "fromLatinText":
                if let text = translateFromTextView.text, !text.isEmpty {
                   translateFromMorseCodeView.text = translatorManager.getMorseCode(from: text)
               } else {
                   resetUI()
               }
               translateFromTextView.endEditing(true)
            case "fromMorseCode":
                if let morseCode = translateFromMorseCodeView.text, morseCode.contains("-") || morseCode.contains(".") {
                    translateFromTextView.text = translatorManager.getLatinText(from: morseCode)
                }else{
                    let alert = UIAlertController(title: "", message: "The text you are trying to translate is not a morse code.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            default:
                let alert = UIAlertController(title: "", message: "Something is wrong. I think I'm dizzy", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
        }
    }
    
    @IBAction func clearTextViewsButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        resetUI()
    }
    
    @IBAction func helpButtonButtonPressed(_ sender: Any) {
        view.endEditing(true)
        let alert = UIAlertController(title: "It's simple to use morse code!", message: ".   for dit, \n -   for dah, \n space   between characters, \n /   between words. ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    @IBAction func useLightButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        if soundManager.useFlashLight {
            soundManager.useFlashLight = false
            sender.setImage(UIImage(systemName: "lightbulb"), for: .normal)
            useLightButtonLabel.text = "use light"
            return
        }
        soundManager.useFlashLight = true
        sender.setImage(UIImage(systemName: "lightbulb.slash.fill"), for: .normal)
        useLightButtonLabel.text = "stop using light"
    }
    
    @IBAction func playSoundButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        if soundManager.isPlaying{
            soundManager.isPlaying = false
            resetPlayButton()
            return
        }
        soundManager.isPlaying = true
        sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playSoundButtonLabel.text = "stop playing"
        if let translateFromText = self.translateFromMorseCodeView.text, translateFromText.contains("-") || translateFromText.contains(".") {
            backgroundDispatchQueue.async {
                self.soundManager.isPlaying = true
                self.soundManager.playMorseSound(from: translateFromText)
                self.resetPlayButton()
            }
        } else {
            let alert = UIAlertController(title: "", message: "The text you are trying to listen to is not a morse code.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            resetPlayButton()
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        if let translateFromText = translateFromMorseCodeView.text, translateFromText.contains("-") || translateFromText.contains(".") {
            let activityControler = UIActivityViewController(activityItems: [translateFromText], applicationActivities: nil)
            present(activityControler, animated: true, completion: nil)
        } else {
            let text = Constants.shareMessage
            let activityControler = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            present(activityControler, animated: true, completion: nil)
        }
    }
    
    private func resetUI() {
        translateFromTextView.text = Constants.placeholderTranslateFromTextView
        translateFromTextView.textColor = UIColor(named: "Main Placeholder Color")
        translateFromMorseCodeView.text = Constants.placeholderTranslateFromMorseCodeView
        translateFromMorseCodeView.textColor = UIColor(named: "Secound Placeholder Color")
    }
    
    private func resetPlayButton(){
        DispatchQueue.main.async {
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.playSoundButtonLabel.text = "play code"
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
        self.view.frame.origin.y = -keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}


//MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        dismissKeyboardWhenTouchOutside()

        if textView == translateFromMorseCodeView {
           NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            UIView.animate(withDuration: 1) {
                self.translateButton.transform = CGAffineTransform(rotationAngle: -.pi)
            }
        }else if textView == translateFromTextView {
            UIView.animate(withDuration: 1) {
                self.translateButton.transform = CGAffineTransform.identity
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == translateFromTextView{
            buttonTrigger = "fromLatinText"
        }else if textView == translateFromMorseCodeView {
            buttonTrigger = "fromMorseCode"
        }
        switch textView.textColor {
            case UIColor(named: "Secound Placeholder Color"):
                translateFromMorseCodeView.text = nil
                translateFromMorseCodeView.textColor = UIColor(named: "Main Color")
            case UIColor(named: "Main Placeholder Color"):
                translateFromTextView.text = nil
                translateFromTextView.textColor =  UIColor(named: "Secound Color")
            default:
                return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == translateFromMorseCodeView{
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        if translateFromMorseCodeView.text.isEmpty {
            translateFromMorseCodeView.text = Constants.placeholderTranslateFromMorseCodeView
            translateFromMorseCodeView.textColor = UIColor(named: "Secound Placeholder Color")
        }
        if translateFromTextView.text.isEmpty {
            translateFromTextView.text = Constants.placeholderTranslateFromTextView
            translateFromTextView.textColor = UIColor(named: "Main Placeholder Color")
        }
        textView.endEditing(true)
    }
    
    func dismissKeyboardWhenTouchOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        appBackground.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}

// MARK: - Constants

extension ViewController {
    enum Constants {
        static let placeholderTranslateFromTextView = "Type someting..."
        static let placeholderTranslateFromMorseCodeView = "- -.-- .--. . / ... --- -- . .. -. --."
        
        static let shareMessage = "Hi,\nI use Code Morse Translator from https://github.com/stefancrudu/Morse-Code-Translator-IOS. \nCheck it now!"
    }
}

// MARK: - Extension UIView

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
