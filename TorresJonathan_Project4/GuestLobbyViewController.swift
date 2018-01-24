//
//  GuestLobbyViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/17/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GuestLobbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    //Firebase And Local variables
    var nameIsValid = true
    var hostName = ""
    var numberOfSongs = 1
    var playlistFromFirebase = [String:AnyObject]()
    var addASong = [String:Int]()
    var ref: FIRDatabaseReference!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = FIRDatabase.database().reference()

    
    }
    
    //TableViewContrller Settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (numberOfSongs)
    }
    
    //Load all songs
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Guest_CellID", for: indexPath)
        
        
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
    
    
    //select sogs to go on Queue
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //segue to guest Lobby
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if nameIsValid == true{
            let guestMPVC: GuestMusicPlayerViewController = segue.destination as! GuestMusicPlayerViewController
            guestMPVC.hostName = hostName
            guestMPVC.numberOfSongs = numberOfSongs
        }
    }
    

}
