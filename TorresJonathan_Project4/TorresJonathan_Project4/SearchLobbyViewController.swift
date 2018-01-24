//
//  SearchLobbyViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/17/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchLobbyViewController: UIViewController {

    var ref: FIRDatabaseReference!
    
    //UIElements
    @IBOutlet weak var seachTextView: UITextField!
    @IBOutlet weak var searchHostBtn: UIButton!
    
    
    //Local Variables
    var hostName = ""
    var currentSong = 2
    var numberOfSongs = 50
    var isThereASong = true
    var nameIsValid = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Check if lobby exist
    @IBAction func checkForLobby(){
        
        
        hostName = seachTextView.text!
        
        if seachTextView.text == ""{
            
            let bothEmpty = UIAlertController(title: "Please enter a Host Name", message: "", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            bothEmpty.addAction(okButton)
            
            self.present(bothEmpty, animated: true, completion: nil)

            return
        }

        
        ref.child("users").child(hostName).child("LibrarySongs").child("LibrarySongs").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            print (snapshot)
            
            
            if snapshot.exists(){
            
            let song = snapshot.value as! NSArray
            
               self.numberOfSongs = song.count
                
                
            self.nameIsValid = true
            self.performSegue(withIdentifier: "GuestSegue", sender: nil)

            }else{
                let bothEmpty = UIAlertController(title: "Could not find lobby", message: "Check your Host name and try again", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                bothEmpty.addAction(okButton)
                
                self.present(bothEmpty, animated: true, completion: nil)
            }
                
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    //segue to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if nameIsValid == true{
        let lobbyVC: GuestLobbyViewController = segue.destination as! GuestLobbyViewController
        lobbyVC.hostName = hostName
        lobbyVC.numberOfSongs = numberOfSongs
        }
    }
    
    


}
