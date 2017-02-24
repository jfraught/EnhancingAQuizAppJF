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
    let answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}

let jordan = TriviaQuestion(question: "Lebron James is the best basketball player in the world.", answer: "True")

