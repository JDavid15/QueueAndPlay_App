//
//  ViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/10/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        MPMediaLibrary.requestAuthorization { (status:MPMediaLibraryAuthorizationStatus) in
            switch status{
            case .authorized:
                print("Authorized")
                break
                
            case .denied:
                print("Denied")
                break
                
            default:
                print("Default")
                break
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue){        
        
    }


}

