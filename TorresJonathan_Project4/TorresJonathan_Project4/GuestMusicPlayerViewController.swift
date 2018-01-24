//
//  GuestMusicPlayerViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/26/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage 

class GuestMusicPlayerViewController: UIViewController {

    //Local Variables
    var hostName = ""
    var numberOfSongs = 0
    var currentSonfNumber = 0
    var exitingBool = false

    //UIElemets
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songAlbumLabel: UILabel!
    @IBOutlet weak var songArtWork: UIImageView!
    
    //Firebase Variables
    var ref: FIRDatabaseReference!
    let storage = FIRStorage.storage().reference()
    var canVote = true
    var votesNeeded = 1
    var hasVoted = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        
        //Load all information from the host
        hostNameLabel.text = "\(hostName)'s Lobby"
        
        ref.child("users").child(self.hostName).child("CurrentSong").observe(FIRDataEventType.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                let song = snapshot.value as! NSDictionary
                
                self.songTitleLabel.text = song.value(forKey: "title") as! String?
                self.songAlbumLabel.text = song.value(forKey: "albumTitle") as! String?
                self.songArtistLabel.text = song.value(forKey: "artist") as! String?
                self.currentSonfNumber = (song.value(forKey: "SongID") as! Int?)!
                
                self.reloadImage()
                
            }
            
        })
        
        
        ref.child("users").child(hostName).child("Votes").child("VoteSystem").observe(.value, with: { (snapshot) in
            print(snapshot)
            
            let voteSystem = snapshot.value as! NSDictionary
            
            let numberOfVotes = voteSystem.value(forKey: "NumberOfVotes") as! Int
            let CurrentVotes = voteSystem.value(forKey: "CurrentVotes") as! Int
            
            if numberOfVotes <= CurrentVotes{
                self.canVote = true
            }

           
            self.votesNeeded = numberOfVotes


        })
        
        

        
    }
    //Func to reload the images
    func reloadImage(){
        
        let imageRef = self.storage.child("user").child(self.hostName).child("Image.jpeg")
        imageRef.data(withMaxSize: 100000000) { (data, error) in
            if error == nil{
                self.songArtWork.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription ?? "Error")
            }
            
        }
    }
    
    //Segue to Exit or go to AddASong
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if exitingBool == false{
            let guestAddSongVC: GuestAddASongViewController = segue.destination as! GuestAddASongViewController
            
            guestAddSongVC.hostName = hostName
            guestAddSongVC.numberOfSongs = numberOfSongs
        }
    }
    
    
    //segue to AddASong
    @IBAction func addASongList(){
        exitingBool = false
        performSegue(withIdentifier: "segueToAddASongGuest", sender: nil)
    }
    
    //segue to exit
    @IBAction func exitGuestLobby(){
        exitingBool = true
        performSegue(withIdentifier: "unwindToMainMenu", sender: nil)
    }
    
     func unwindToGuestMP(_ segue: UIStoryboardSegue){
        exitingBool = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voteToSkip(){
        
        ref.child("users").child(hostName).child("Votes").child("VoteSystem").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let voteSystem = snapshot.value as! NSDictionary

            
            let numberOfVotes = voteSystem.value(forKey: "CurrentVotes") as! Int
            let voteEnable = voteSystem.value(forKey: "VoteEnable") as! Bool
            let castAVote = NSNumber(integerLiteral: numberOfVotes + 1)
            
            if self.canVote == true{
            
            if voteEnable == true{
                self.ref.child("users").child(self.hostName).child("Votes").child("VoteSystem").updateChildValues(["CurrentVotes" : castAVote])
                self.canVote = false
                
              }
                
            }
            
        })
        
    }

    

}
