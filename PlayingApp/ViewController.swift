//
//  ViewController.swift
//  PlayingApp
//
//  Created by Maxim Potapov on 03.08.2020.
//  Copyright © 2020 Maxim Potapov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var deck = PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }
}

