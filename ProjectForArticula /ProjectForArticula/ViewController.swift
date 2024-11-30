//
//  ViewController.swift
//  ProjectForArticula
//
//  Created by Sena Küçükerdoğan on 9.01.2024.
//

import UIKit
import NaturalLanguage

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let recognizer = NLLanguageRecognizer()
    var language: NLLanguage?
    
    let titles = ["Please enter data in the colored area below!", "Por favor, ingrese datos en el área coloreada abajo!"]
    var currentTitleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputText.delegate = self
        inputText.addTarget(self, action: #selector(changeLanguage), for: .editingChanged)
        
        showTitles(at: currentTitleIndex)
    }
    
    // Animate titles
    func showTitles(at index: Int) {
        guard index < titles.count else { return }
        
        titleLabel.text = titles[index]
        
        // Increase index and taking the modulus for return to starting index
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let nextIndex = (index + 1) % self.titles.count
            self.showTitles(at: nextIndex)
        }
    }
    
    // split the sentence with dividers
    func splitSentence(sentence: String, dividers: [String]) -> String {
        for divider in dividers {
            if let dividerRange = sentence.range(of: divider, options: .caseInsensitive){ // split with divider
                let splitIndex = dividerRange.lowerBound // to divider's starting index
                //print(splitIndex)
                let firstPart = sentence[sentence.startIndex..<splitIndex] // starting index to splitting index
                //print(firstPart)
                let secondPartIndex = dividerRange.upperBound // after divider's ending index
                //print(secondPartIndex)
                let secondPart = sentence[secondPartIndex...] // after divider's ending index until sentence's ending index
                //print(secondPart)
                
                let newSentence = firstPart + "\n" + divider + splitSentence(sentence: String(secondPart), dividers: dividers)
                return String(newSentence)
            }
        }

        return sentence
    }
    
    // check language and give dividers each for language
    func tokenizeTheSentence(sentence:String, language:String) -> String {
        switch language {
        case "en":
            let newSentence = splitSentence(sentence: sentence, dividers: ["If", "And"])
            return newSentence
            
        case "es":

            let newSentence = splitSentence(sentence: sentence, dividers: ["Si", "Y"])
            return newSentence
            
        default:
            return sentence
        }
    }
    
    // use with NLP framework, describe language
    @objc func changeLanguage(_ sender: Any) {
        guard let enteredText = inputText.text else { return }
        
        recognizer.processString(enteredText)
        guard let language = recognizer.dominantLanguage else { return } //which language using
        //print(language!.rawValue)
        outputText.text = tokenizeTheSentence(sentence: enteredText, language: language.rawValue)

    }
    
}

