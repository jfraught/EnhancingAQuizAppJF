//
//  TriviaQuestion.swift
//  TrueFalseStarter
//
//  Created by Jordan Fraughton on 2/23/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

class TriviaQuestion {
    
    let question: String
    let option1: String
    let option2: String
    let option3: String
    let option4: String
    
    init(question: String, option1: String, option2: String, option3: String, option4: String) {
        self.question = question
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.option4 = option4
        }
}

