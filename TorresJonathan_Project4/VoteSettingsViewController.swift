//
//  VoteSettingsViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/26/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VoteSettingsViewController: UIViewController {

    @IBOutlet weak var canVoteBool: UISwitch!
    @IBOutlet weak var howManyVotes: UITextField!
    
    var hostName = ""
    
    var ref: FIRDatabaseReference!

    
    var numberOfVotes = 5
    var canVote = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func applyBtn(_ sender: UIButton) {
        
        numberOfVotes = Int(howManyVotes.text!) ?? 5
        
        if canVoteBool.isOn == true{
            canVote = true
        }
        else if canVoteBool.isOn == false{
            canVote = false
        }
        
        ref.child("users").child(hostName).child("Votes").child("VoteSystem").observeSingleEvent(of: .value, with: { (snapshot) in
            self.ref.child("users").child(self.hostName).child("Votes").child("VoteSystem").updateChildValues(["VoteEnable":self.canVote])
            self.ref.child("users").child(self.hostName).child("Votes").child("VoteSystem").updateChildValues(["NumberOfVotes":self.numberOfVotes])
        })
    
        
    }
    
    
    @IBAction func unwindBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToMPHotVote", sender: nil)
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
