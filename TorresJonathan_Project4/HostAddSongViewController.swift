//
//  HostAddSongViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/26/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HostAddSongViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    //Local and Firebase Variables
    var hostName = ""
    var numberOfSongs = 1
    var playlistFromFirebase = [String:AnyObject]()
    var addASong = [String:Int]()
    var ref: FIRDatabaseReference!
    var returning = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = FIRDatabase.database().reference()
        
        
    }
    
    //TableController settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (numberOfSongs)
    }
    
    
    //Load all songs from phone
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostAddSong_CellID", for: indexPath)
        
        
        ref.child("users").child(hostName).child("LibrarySongs").child("LibrarySongs").child("\(indexPath.row)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if snapshot.exists(){
                
                let song = snapshot.value as! NSDictionary
                
                
                cell.textLabel?.text = "\(song.value(forKey: "title")!)"
                cell.detailTextLabel?.text = "Artist: \(song.value(forKey: "artist")!)   Album: \(song.value(forKey: "artist")!)"
                
                
            }
            else{
            }
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        return cell
    }
    
    //select what songs will be added
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        ref.child("users").child(hostName).child("LibrarySongs").child("LibrarySongs").child("\(indexPath.row)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if snapshot.exists(){
                
                let song = snapshot.value as! NSDictionary
                
                
                self.playlistFromFirebase.updateValue((["title":song.value(forKey: "title")!, "albumTitle":song.value(forKey: "albumTitle")!, "artist":song.value(forKey: "artist")!, "SongID":song.value(forKey: "SongID")!] as AnyObject), forKey: "\(indexPath.row)")
                
                self.ref.child("users").child(self.hostName).child("PlaylistSongs").updateChildValues(self.playlistFromFirebase)
                
                
            }
            else{
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    
        addASong.updateValue(indexPath.row, forKey: "SongId")
        
        self.ref.child("users").child(self.hostName).child("AddSong").updateChildValues(addASong)
        
        
    }
    
    
    @IBAction func toSettings(){
        returning = false
        performSegue(withIdentifier: "ToVote", sender: nil)
    }
    
    @IBAction func backToMP(){
        returning = true
        performSegue(withIdentifier: "backtoMPP", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if returning == false{
            let VoteSongVC: VoteSettingsViewController = segue.destination as! VoteSettingsViewController
            
            VoteSongVC.hostName = hostName

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
