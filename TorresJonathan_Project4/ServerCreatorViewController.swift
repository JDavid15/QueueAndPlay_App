//
//  ServerCreatorViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/17/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MediaPlayer

class ServerCreatorViewController: UIViewController {

    //UIElements
    @IBOutlet weak var hostNameTextBox: UITextField!
    @IBOutlet weak var createLobbyBtn: UIButton!

    //Device Variables
    var hostName = ""
    var nameisValid = false
    var numberOfSongs = 1
    var allSongList = MPMediaQuery.songs().items
    
    //Firebase Variables
    var ref: FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //Shoe message if the device has no Songs
        if allSongList?.count == 0 || allSongList?.count == nil{
            
            let bothEmpty = UIAlertController(title: "No songs detected on this device.", message: "Please make sure this device has songs before running this app.", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            bothEmpty.addAction(okButton)
            
            self.present(bothEmpty, animated: true, completion: nil)
            
            createLobbyBtn.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Button to create the lobby
    @IBAction func createLobby(){
    
        self.hostName = hostNameTextBox.text!

        
        //If the TextBox was Empty
        if hostNameTextBox.text == ""{
            
            let bothEmpty = UIAlertController(title: "Please enter a Host Name", message: "", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            bothEmpty.addAction(okButton)
            
            self.present(bothEmpty, animated: true, completion: nil)
            
            return
        }

        
        
        ref.child("users").child(hostName).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            
            if snapshot.exists(){
                
                //If lobby Exits, ask user to make a new name
                let bothEmpty = UIAlertController(title: "Name already taken", message: "Please choose a different name.", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                bothEmpty.addAction(okButton)
                
                self.present(bothEmpty, animated: true, completion: nil)
                
            }else{
            
                self.nameisValid = true
                self.performSegue(withIdentifier: "HostSegue", sender: nil)
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    
        
        
    }
    //Segue to next Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if nameisValid == true{
            let hostVC: HostCreationView = segue.destination as! HostCreationView

            hostVC.hostName = hostName
        }
        
        
        
    }
    
    @IBAction func unwindToServerCreator(_ segue: UIStoryboardSegue){

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
