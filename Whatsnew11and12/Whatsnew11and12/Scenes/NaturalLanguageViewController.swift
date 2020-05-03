//
//  NaturalLanguageViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 19/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit
import NaturalLanguage

class NaturalLanguageViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.text = """
        💪 Here's to the crazy ones. The misfits. The rebels. The troublemakers.

        🍏 meeting is at 14:00.
        """
        
        /*textView.text = """
        STRV s.r.o. is a company based at Rohanske nabrezi 678/23, 186 00 Prague.
        Jan Kaltoun, Jan Schwarz and Jan Pacek are 🍏 platform leads.
        The Android leads are Petr Nohejl and Juraj Kuliska.
        """*/
        
        textView.text = """
        Steve Jobs, Steve Wozniak, and Ronald Wayne founded Apple Inc in California.
        """
    }
    
    @IBAction func getDominantLanguage(_ sender: Any) {
        let language = NLLanguageRecognizer.dominantLanguage(for: textView.text)
        let languageName = language?.rawValue ?? "unknown"
        
        let alert = UIAlertController(title: "Dominant language", message: languageName, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func getTokens(_ sender: Any) {
        let text = textView.text!
        
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        
        var tokens = [String]()
        
        tokenizer.enumerateTokens(in: text.startIndex ..< text.endIndex) { (range, attrs) -> Bool in
            tokens.append("[\(attrs.rawValue)] \(text[range])")
            
            return true
        }
        
        let message = tokens.joined(separator: "\n")
        
        let alert = UIAlertController(title: "Found tokens", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func getNames(_ sender: Any) {
        let text = textView.text!
        
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
        
        var names = [String]()
        
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: options
        ) { tag, tokenRange in
            if let tag = tag, tags.contains(tag) {
                names.append("[\(tag.rawValue)]: \(text[tokenRange])")
            }
            
            return true
        }
        
        let message = names.joined(separator: "\n")
        
        let alert = UIAlertController(title: "Found names", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
