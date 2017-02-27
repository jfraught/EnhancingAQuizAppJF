//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    
    let trivia = Trivia().questionsArray
    
    // A dictionary that should be aa array of objects: class called TriviaQuestion and in MVC format this should be in a TriviaProvider file. 
   
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        questionField.text = questionDictionary.question
        option1Button.setTitle(questionDictionary.option1, for: .normal)
        option2Button.setTitle(questionDictionary.option2, for: .normal)
        option3Button.setTitle(questionDictionary.option3, for: .normal)
        option4Button.setTitle(questionDictionary.option4, for: .normal)
        playAgainButton.isHidden = true
        
    }
    
    
    
    func displayScore() {
        // Hide the answer buttons
        option1Button.isHidden = true
        option2Button.isHidden = true
        option3Button.isHidden = true
        option4Button.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        let question = trivia[indexOfSelectedQuestion].question
        
       // Sorting correct answers from false maybe I should do this in model?
        
        if question == "LeBron James is the _ best player of all time." {
            if sender == option1Button {
                questionField.text = "Correct!"
            } else if sender == option2Button || sender == option3Button || sender == option4Button {
               questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "Shaq played for which of these teams?" {
            if sender == option1Button {
                questionField.text = "Correct!"
            } else if sender == option2Button || sender == option3Button || sender == option4Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "Steve Nash was MVP _ times." {
            if sender == option2Button {
                questionField.text = "Correct!"
            } else if sender == option1Button || sender == option3Button || sender == option4Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "Damian Lillard went to which school in Utah?" {
            if sender == option2Button {
                questionField.text = "Correct!"
            } else if sender == option1Button || sender == option3Button || sender == option4Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "Jimmer Fredette's highest scoring game is _." {
            if sender == option1Button {
                questionField.text = "Correct!"
            } else if sender == option2Button || sender == option3Button || sender == option4Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "What college did Michael Jordan play for?" {
            if sender == option3Button {
                questionField.text = "Correct!"
            } else if sender == option1Button || sender == option2Button || sender == option4Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "The Utah Jazz have won how many championships?" {
            if sender == option4Button {
                questionField.text = "Correct!"
            } else if sender == option1Button || sender == option2Button || sender == option3Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "Gordon Hayward played for which college?" {
            if sender == option2Button {
                questionField.text = "Correct!"
            } else if sender == option1Button || sender == option3Button || sender == option4Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        } else if question == "Kobe Bryant has _ rings." {
            if sender == option4Button {
                questionField.text = "Correct!"
            } else if sender == option1Button || sender == option2Button || sender == option3Button {
                questionField.text = "Sorry! Wrong answer!"
            }
        }
        
      
        loadNextRoundWithDelay(seconds: 2)
        
        
        
        //Say whether or not that answer is right or not and keep track of how many are right and wrong
        
    
        
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        option1Button.isHidden = false
        option2Button.isHidden = false
        option3Button.isHidden = false
        option4Button.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

