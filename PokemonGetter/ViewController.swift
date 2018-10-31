//
//  ViewController.swift
//  PokemonGetter
//
//  Created by Brian Sadler on 10/24/18.
//  Copyright © 2018 Brian Sadler. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage






class ViewController: UIViewController {
    // base URL from pokemon API
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    
    
    //Outlet
    @IBOutlet weak var battleLog: UITextView!
    @IBOutlet weak var pokemonTextField: UITextField!
    @IBOutlet weak var pokemonTextField2: UITextField!
    @IBOutlet weak var submitButtonTapped: UIButton!
    @IBOutlet weak var pokemonHP1: UILabel!
    @IBOutlet weak var pokemonHP2: UILabel!
    
    // number array for damage
    var oneToTwentyFive = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16 , 17, 18, 19, 20, 21, 22, 23, 24, 25]
    //pokemon variables
    var pokemon1: String!
    var pokemon2: String!
    var abilitySet1: [String] = []
    var abilitySet2: [String] = []
    var pokemonDefender: Pokemon = Pokemon.init(name: " ", abilityNames: [])
    var pokemonAttacker: Pokemon = Pokemon.init(name: " ", abilityNames: [])
    
  
   

    
    @objc func battle() {
        var damage1 = Int(arc4random_uniform(UInt32(oneToTwentyFive.count)))
        var damage2 = Int(arc4random_uniform(UInt32(oneToTwentyFive.count)))
        var randomAbility1 = (Int(arc4random_uniform(UInt32(self.abilitySet1.count))))
        var randomAbility2 = (Int(arc4random_uniform(UInt32(self.abilitySet2.count))))
        self.pokemonHP1.text = String(self.pokemonDefender.HP)
        self.pokemonHP2.text = String(self.pokemonAttacker.HP)
        if self.pokemonDefender.HP > 0 && self.pokemonAttacker.HP > 0 {
            self.battleLog.text = "\(self.pokemonDefender.name) used \(self.abilitySet1[randomAbility1]) for \(damage1) damage \n \(self.self.pokemonAttacker.name) used \(self.abilitySet2[randomAbility2]) for \(damage2)"
            self.pokemonDefender.HP -= damage2
            self.pokemonAttacker.HP -= damage1
            self.pokemonHP1.text = "\(self.pokemonDefender.name):\(self.pokemonDefender.HP)"
            self.pokemonHP2.text = "\(self.pokemonAttacker.name):\(self.pokemonAttacker.HP)"
            
        } else if self.pokemonDefender.HP <= 0 {
            self.battleLog.text = "\(self.pokemonDefender.name) passed out \n \(self.pokemonAttacker.name) has won the battle!"
     
            
        } else if self.pokemonAttacker.HP <= 0 {
            self.battleLog.text = "\(self.pokemonAttacker.name) passed out \n \(self.pokemonDefender.name) has won the battle!"
     
           
           
        }
        
        
    }

    
    @IBAction func submitButtonAction(_ sender: Any) {
        guard let pokemonNameOrID = pokemonTextField.text, let pokemonNameOrID2 = pokemonTextField2.text else {
            return
        }
        
       
        
    
        
        
        
        //URL that we will use for our request
        let requestURL = baseURL + pokemonNameOrID.lowercased().replacingOccurrences(of: " ", with: "+")
        let requestURL2 = baseURL + pokemonNameOrID2.lowercased().replacingOccurrences(of: " ", with: "+")
        
        //making requests
        let request = Alamofire.request(requestURL)
        let request2 = Alamofire.request(requestURL2)
        
     
        
        //carry out request
        request.responseJSON { respose in
            switch respose.result {
            case .success(let value):
                let json = JSON(value)
                
                if  let speciesName = json["species"]["name"].string {
                    print(speciesName)
                    self.pokemon1 = speciesName
                   
                }
                
                //pulling one random ability
                if let ablitiesJSON = json["abilities"].array {
                    //let randomAbility = ablitiesJSON[Int(arc4random_uniform(UInt32(ablitiesJSON.count)))]
                 // print(randomAbility["ability"]["name"])
                   // ability1 = randomAbility["ability"]["name"].stringValue
                    
                    //code for getting entire array
                    for ability in ablitiesJSON {
                        if let ability1 = ability["ability"]["name"].string {

                            print(ability1)
                            self.abilitySet1.append(ability1)
                        }
                    }
                }
                
                //second request
                request2.responseJSON { respose in
                    switch respose.result {
                    case .success(let value):
                        let json = JSON(value)
                        if  let speciesName2 = json["species"]["name"].string {
                            print(speciesName2)
                            self.pokemon2 = speciesName2
                            
                        }
                        //pulling one random ability
//                        if let ablitiesJSON = json["abilities"].array {
//                            let randomAbility2 = ablitiesJSON[Int(arc4random_uniform(UInt32(ablitiesJSON.count)))]
                        if let ablitiesJSON = json["abilities"].array {
                            for ability in ablitiesJSON {
                                if let ability2 = ability["ability"]["name"].string {
                                    
                                    print(ability2)
                                    self.abilitySet2.append(ability2)
                                   
                                }
                            }
                        }
                   
                        
                        self.pokemonDefender.name = self.pokemon1
                        self.pokemonDefender.abilityNames = self.abilitySet1
                        self.pokemonAttacker.name = self.pokemon2
                        self.pokemonAttacker.abilityNames = self.abilitySet2
                        self.pokemonDefender.HP = 100
                        self.pokemonAttacker.HP = 100
                        self.pokemonHP1.text = "\(self.pokemonDefender.name):\(self.pokemonDefender.HP)"
                        self.pokemonHP2.text = "\(self.pokemonAttacker.name):\(self.pokemonAttacker.HP)"
                        let battleTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.battle), userInfo: nil, repeats: true)
                      
                     
                       
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }


}

