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
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Properties
    
    let questionsPerRound = Trivia().questionsArray.count
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var questionsAskedArray: [Int] = []
    var count = 16
    var gameSound: SystemSoundID = 0
    var audioPlayer = AVAudioPlayer()
    var wrongAnswerSound: SystemSoundID = 0
    var rightSound: SystemSoundID = 0
    let trivia = Trivia().questionsArray
    var recievedLightningRoundOn = false
    var timer: Timer?
    
    @IBOutlet weak var option2Constraint: NSLayoutConstraint!
    @IBOutlet weak var option3Constraint: NSLayoutConstraint!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    
    
    // Here I am setting up the timer to run in viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        
        // Start game
        
        playGameStartSound()
        displayQuestion()
        
        // Timer logic
        
        if recievedLightningRoundOn == true && option1Button.isHidden == false {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            updateCounter()
        } else if recievedLightningRoundOn == false {
            countDownLabel.isHidden = true
        }
    }
    
    // Make the timer count down 
    
    func updateCounter() {
        if count > 0 {
            count -= 1
        }
        
        countDownLabel.text = "\(count)"
        if count == 0 {
            checkAnswer(nil)
        }
    }

    // Update the views to display the next question and possible answers, and count down label.
    
    func displayQuestion() {
       if recievedLightningRoundOn == true {
            countDownLabel.isHidden = false
        }
        
        // If the last question in a previous round was a 3 options question, updates the contraints back to 30 points
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0, animations: {
            self.option2Constraint.constant = 30
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0, animations: {
            self.option3Constraint.constant = 30
            self.view.layoutIfNeeded()
        })
       
        // The first round requires no check if a number has been drawn before
       
        if questionsAskedArray.isEmpty {
        
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
            
            questionsAskedArray.append(indexOfSelectedQuestion)
            
            let questionDictionary = trivia[indexOfSelectedQuestion]
            
            // If question has 3 options update views and constraints
           
            if questionDictionary.option4 == "No answer" {
                questionField.text = questionDictionary.question
                option1Button.setTitle(questionDictionary.option1, for: .normal)
                option2Button.setTitle(questionDictionary.option2, for: .normal)
                option3Button.setTitle(questionDictionary.option3, for: .normal)
                option4Button.setTitle(questionDictionary.option4, for: .normal)
                playAgainButton.isHidden = true
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0, animations: {
                  self.option2Constraint.constant = 40
                    self.view.layoutIfNeeded()
                })
                
                UIView.animate(withDuration: 0, animations: {
                    self.option3Constraint.constant = 40
                    self.view.layoutIfNeeded()
                })
                
                option4Button.isHidden = true
          
            // If questions has 4 options only update text
            
            } else {
                questionField.text = questionDictionary.question
                option1Button.setTitle(questionDictionary.option1, for: .normal)
                option2Button.setTitle(questionDictionary.option2, for: .normal)
                option3Button.setTitle(questionDictionary.option3, for: .normal)
                option4Button.setTitle(questionDictionary.option4, for: .normal)
                option4Button.isHidden = false
                playAgainButton.isHidden = true
            }
            
        // Check to see if a question has been used, if it has repeat picking index until I find one that hasn't been used
        
        } else if questionsAskedArray.isEmpty == false {
            repeat {
                indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
            } while questionsAskedArray.contains(indexOfSelectedQuestion)
                questionsAskedArray.append(indexOfSelectedQuestion)
                let questionDictionary = trivia[indexOfSelectedQuestion]
            
            // If question has 3 options
            
            if questionDictionary.option4 == "No answer" {
                questionField.text = questionDictionary.question
                option1Button.setTitle(questionDictionary.option1, for: .normal)
                option2Button.setTitle(questionDictionary.option2, for: .normal)
                option3Button.setTitle(questionDictionary.option3, for: .normal)
                option4Button.setTitle(questionDictionary.option4, for: .normal)
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0, animations: {
                    self.option2Constraint.constant = 40
                    self.view.layoutIfNeeded()
                })
                
                UIView.animate(withDuration: 0, animations: {
                    self.option3Constraint.constant = 40
                    self.view.layoutIfNeeded()
                })
                
                option4Button.isHidden = true
                
            // If quesiton has 4 options
                
            } else {
                questionField.text = questionDictionary.question
                option1Button.setTitle(questionDictionary.option1, for: .normal)
                option2Button.setTitle(questionDictionary.option2, for: .normal)
                option3Button.setTitle(questionDictionary.option3, for: .normal)
                option4Button.setTitle(questionDictionary.option4, for: .normal)
                option4Button.isHidden = false
                playAgainButton.isHidden = true
           }
        }
    }
    
    // All questions have been asked
    
    func displayScore() {
        
        // No need for timer so turn it off
        
        timer?.invalidate()
        
        // Hide the answer buttons
       
        option1Button.isHidden = true
        option2Button.isHidden = true
        option3Button.isHidden = true
        
        // Display play again buttons
        
        option4Button.isHidden = false
        option4Button.tintColor = .white
        option4Button.backgroundColor = #colorLiteral(red: 0, green: 0.5764705882, blue: 0.5294117647, alpha: 1)
        option4Button.setTitle("Play Lightning Round", for: .normal)
        playAgainButton.isHidden = false
        
        if correctQuestions >= 7 {
            questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        } else if correctQuestions < 7 {
            questionField.text = "You got \(correctQuestions) out of \(questionsPerRound) correct!"
        }
    }
    
    // Checking to see if a answer is correct or if the timer has run out.
    
    @IBAction func checkAnswer(_ sender: UIButton?) {
                let question = trivia[indexOfSelectedQuestion].question
        let triviaAnswers = trivia[indexOfSelectedQuestion]
       // Sorting correct answers from false maybe I should do this in model?
       
        if option1Button.isHidden == false {
            if question == "LeBron James is the _ best player of all time." {
                if sender == option1Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option2Button || sender == option3Button || sender == option4Button || count == 0 {
                questionField.text = "Sorry! The correct answer is \(triviaAnswers.option1)!"
                    playWrongAnswerSound()
                }
            } else if question == "Shaq played for which of these teams?" {
                if sender == option1Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option2Button || sender == option3Button || sender == option4Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option1)!"
                    playWrongAnswerSound()
                }
            } else if question == "Steve Nash was MVP _ times." {
                if sender == option2Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option1Button || sender == option3Button || sender == option4Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option2)!"
                    playWrongAnswerSound()
                }
            } else if question == "Damian Lillard went to which school in Utah?" {
                if sender == option2Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option1Button || sender == option3Button || sender == option4Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option2)!"
                    playWrongAnswerSound()
                }
            } else if question == "Jimmer Fredette's highest scoring game is _." {
                if sender == option1Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option2Button || sender == option3Button || sender == option4Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option1)!"
                    playWrongAnswerSound()
                }
            } else if question == "What college did Michael Jordan play for?" {
                if sender == option3Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option1Button || sender == option2Button || sender == option4Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option3)!"
                    playWrongAnswerSound()
                }
            } else if question == "The Utah Jazz have won how many championships?" {
                if sender == option4Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option1Button || sender == option2Button || sender == option3Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option4)!"
                    playWrongAnswerSound()
                }
            } else if question == "Gordon Hayward played for which college?" {
                if sender == option2Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
            } else if sender == option1Button || sender == option3Button || sender == option4Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option2)!"
                    playWrongAnswerSound() }
            } else if question == "Kobe Bryant has _ rings." {
                if sender == option4Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option1Button || sender == option2Button || sender == option3Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option4)!"
                    playWrongAnswerSound()
                }
            } else if question == "Who is the best player in the world right now?" {
                if sender == option3Button {
                    questionField.text = "Correct!"
                    correctQuestions += 1
                    playRightAnswerSound()
                } else if sender == option1Button || sender == option2Button || count == 0 {
                    questionField.text = "Sorry! The correct answer is \(triviaAnswers.option3)!"
                    playWrongAnswerSound()
                }
            } else {
                return
            }
            
            loadNextRoundWithDelay(seconds: 2)
        }
    }
    
    // Logic for bringing up next question
    
    func nextRound() {
       
        questionsAsked += 1
        countDownLabel.isHidden = true
        
        if questionsAsked == questionsPerRound {
            // Game is over
            print(questionsAsked)
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
        questionsAskedArray.append(indexOfSelectedQuestion)
    }
    
   // Logic for playing game a second time in lightning or normal mode
    
    @IBAction func playAgain() {
        
        recievedLightningRoundOn = false
        
        questionsAskedArray = []
        // Show the answer buttons
        option1Button.isHidden = false
        option2Button.isHidden = false
        option3Button.isHidden = false
        option4Button.isHidden = false
        option4Button.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.4745098039, blue: 0.5882352941, alpha: 1)
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    @IBAction func playLightningRound(_ sender: Any) {
        if option2Button.isHidden == true {
            recievedLightningRoundOn = true
            questionsAskedArray = []
            
            // Show the answer buttons
            
            option1Button.isHidden = false
            option2Button.isHidden = false
            option3Button.isHidden = false
            option4Button.isHidden = false
            option4Button.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.4745098039, blue: 0.5882352941, alpha: 1)
            
            questionsAsked = 0
            correctQuestions = 0
            nextRound()
            
            // Timer is invalidated so I need to remake it.
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            updateCounter()
        }
    }
    

    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        count = 18
        countDownLabel.isHidden = true
       
     
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
            self.updateCounter()
            
        }
    }
    
    // Sounds
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    
    func playWrongAnswerSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "BuzzerBeep", ofType: ".wav")!))
            audioPlayer.prepareToPlay()
        }
        
        catch {
            print(error)
        }
        
        audioPlayer.play()
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playRightAnswerSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "GasStationBell", ofType: ".wav")!))
            audioPlayer.prepareToPlay()
        }
            
        catch {
            print(error)
        }
        
        audioPlayer.play()
    }
}

