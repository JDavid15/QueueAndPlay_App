//
//  HostCreationView.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/10/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import MediaPlayer
import FirebaseDatabase

class HostCreationView: UIViewController{

    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    //Load Timer Variables
    var timer = Timer()
    var seconds = 0
    
    //FireBase Variables
    var allSongList = MPMediaQuery.songs().items
    var ref: FIRDatabaseReference!
    var hostName = "Host Name"
    var songToFirebase = [String:AnyObject]()
    var playlistToFirebase = [String:AnyObject]()
    var addASong = [String:Int]()
    var voteSystem = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingIcon.startAnimating()
        
        //Start the Timer to load
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HostCreationView.loadingTime), userInfo: nil, repeats: true)
                
    ref = FIRDatabase.database().reference()
        
       //add songs to firebase
        for song in 0...(allSongList?.count)! - 1{
            songToFirebase.updateValue((["title": allSongList![song].title!, "SongID":song ,"albumTitle": allSongList![song].albumTitle!, "artist":allSongList![song].artist!] as AnyObject), forKey: "\(song)")
        }
        
    
        //add a Key for each feature
        self.ref.child("users").child(hostName).child("LibrarySongs").setValue(["LibrarySongs":songToFirebase])
        
        self.ref.child("users").child(self.hostName).child("PlaylistSongs").setValue(["playlist":self.playlistToFirebase])
     
        self.ref.child("users").child(self.hostName).child("AddSong").setValue(self.addASong)
        
        self.ref.child("users").child(self.hostName).child("CurrentSong").setValue(self.addASong)
        
        voteSystem.updateValue((["VoteEnable":true, "NumberOfVotes": 5, "CurrentVotes": 0]) as AnyObject, forKey: "VoteSystem")
        
        self.ref.child("users").child(self.hostName).child("Votes").setValue(voteSystem)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //segue to the Next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let hostLobbyVC: HostMusicPlayerViewController = segue.destination as! HostMusicPlayerViewController
        
        hostLobbyVC.hostName = hostName
        hostLobbyVC.numberOfSongs = (allSongList?.count)!
        
        
        
    }
    
    
    //Fuction for the loading
    @objc func loadingTime(){
        seconds += 1
        
        if seconds == 2{
            
            loadingIcon.stopAnimating()
            performSegue(withIdentifier: "HostLobbySegue", sender: nil)
            
        }
        
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
