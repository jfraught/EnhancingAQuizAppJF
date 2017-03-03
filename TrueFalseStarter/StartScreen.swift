//
//  StartScreen.swift
//  TrueFalseStarter
//
//  Created by Jordan Fraughton on 3/1/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
  
    var lightningRoundToSend: Bool = false
    
    @IBAction func normalTapped(_ sender: Any) {
        lightningRoundToSend = false
        
    }
  
    @IBAction func lightningTapped(_ sender: Any) {
        lightningRoundToSend = true
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC: ViewController = segue.destination as! ViewController
        secondVC.recievedLightningRoundOn = lightningRoundToSend
    }
   

}
