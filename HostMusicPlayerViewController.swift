//
//  HostMusicPlayerViewController.swift
//  TorresJonathan_Project4
//
//  Created by Jonathan Torres on 1/12/17.
//  Copyright © 2017 Jonathan Torres. All rights reserved.
//

import UIKit
import MediaPlayer
import FirebaseDatabase
import FirebaseStorage

class HostMusicPlayerViewController: UIViewController {
    
    //Host Settings
    var votesAllowed = false
    var numberOfVotesRequired = 1
    var numberofCurrentVotes = 1
    
    //UIElements
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var songArtWork: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songAlbum: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    var exitingBool = false
    
    
    //MusicPlayer Variables
     var musicIsPlaying = true
     var hostPlaylist = [MPMediaItem]()
     let musicPlayer = MPMusicPlayerController.systemMusicPlayer
     var songsAdded = [MPMediaItem]()
     var songIDAdded = [Int]()
     var playlistSongs = [MPMediaItem]()
     var allSongList = MPMediaQuery.songs().items
     var currentSongNumber = 0
     var currentSongDuration = Int()
     var currentTime = Int()
     var songTimer = Timer()
     var size = CGSize(width: 200, height: 200)
    
    
    //Fire Base Data
    var hostName = ""
    var numberOfSongs = 0
    var ref: FIRDatabaseReference!
    let storage = FIRStorage.storage().reference()
    var curentSongInfo = [String:AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostNameLabel.text = "\(hostName)'s Lobby"
        
        //Add the First song of the devices Library
        songsAdded.append((allSongList?[0])!)
        songIDAdded.append(0)
        
        
        
        ref = FIRDatabase.database().reference()

        //Start the Timer for the song duration
        songTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.songEnds), userInfo: nil, repeats: true)
        
        //Start Playing
       musicStart()

        //Func for Voting
        ref.child("users").child(hostName).child("Votes").child("VoteSystem").observe(.value, with: { (snapshot) in
            print(snapshot)
            
            let voteSystem = snapshot.value as! NSDictionary
            
            let numberOfVotes = voteSystem.value(forKey: "NumberOfVotes") as! Int
            let voteEnable = voteSystem.value(forKey: "VoteEnable") as! Bool
            let CurrentVotes = voteSystem.value(forKey: "CurrentVotes") as! Int
            
            print(voteSystem.value(forKey: "CurrentVotes") as! Int)
            print(voteSystem.value(forKey: "NumberOfVotes") as! Int)
            print(voteSystem.value(forKey: "VoteEnable") as! Bool)
            
            if voteEnable == true{
                if CurrentVotes >= numberOfVotes{
                    self.hostSkipSong()
                        self.ref.child("users").child(self.hostName).child("Votes").child("VoteSystem").updateChildValues(["CurrentVotes" : 0])
                    
                }
            }
            
        })
        
        //Check if there are any new songs in queue
        ref.child("users").child(self.hostName).child("AddSong").observe(FIRDataEventType.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                let song = snapshot.value as! NSDictionary
            
                self.songsAdded.append((self.allSongList?[song.value(forKey: "SongId") as! Int])!)
                self.songIDAdded.append(song.value(forKey: "SongId") as! Int)
                
                print(song)
                print("song added")
            }
            else{
            }

        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Func to start a new song
    func musicStart(){
        
        
        
        musicPlayer.stop()
        
        //If There are no more songs, Repeat
        if songIDAdded.count <= currentSongNumber{
            currentSongNumber = 0
        }
        playlistSongs.removeAll()
        playlistSongs.append((allSongList?[songIDAdded[currentSongNumber]])!)
        

        
            
            
        let mediaCollection = MPMediaItemCollection(items: playlistSongs)
            
        musicPlayer.setQueue(with: mediaCollection)
            
        musicPlayer.play()
        updateSongInfo()
        updateGuestInfo()
            


        
    }
    
    //Play/Stop Button
    @IBAction func playOrStopBtn(){
        
        if musicIsPlaying == true{
            musicPlayer.pause()
            playPauseBtn.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            musicIsPlaying = false
            songTimer.fire()
            print("First")
        
                    }
        
        else {
            musicPlayer.play()
            playPauseBtn.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            musicIsPlaying = true
            songTimer.invalidate()
            print("Second")
        }
    }

    //Skip Button
    @IBAction func hostSkipSong(){

        currentSongNumber = currentSongNumber + 1
        musicStart()


            }
    
    @IBAction func replaysong(){
        musicPlayer.skipToBeginning()
        currentTime = 0
    }
    
    //func to update info in the host Device
    func updateSongInfo(){
        songArtist.text = musicPlayer.nowPlayingItem?.artist
        songAlbum.text = musicPlayer.nowPlayingItem?.albumTitle
        songTitle.text = musicPlayer.nowPlayingItem?.title
        currentSongDuration = Int((musicPlayer.nowPlayingItem?.playbackDuration)!)
        currentTime = 0        
        songArtWork.image = musicPlayer.nowPlayingItem?.artwork?.image(at: size) ?? #imageLiteral(resourceName: "UnknownSong")
      
        
    }
    
    
    //event that happens when a song ends
    @objc func songEnds(){
        
        currentTime += 1
        
        
        if currentTime == currentSongDuration{
            print("END")
            
            currentSongNumber += 1
            musicStart()
            updateSongInfo()
            
            currentTime = 0
        }
        
    }
    

    //segue to addAsongScreen
    @IBAction func addASongSegue(){
        
        exitingBool = false
        performSegue(withIdentifier: "hostAddASongSegue", sender: nil)
    }
    
    //unwind To main Menu
    @IBAction func exitVC(){
    
        exitingBool = true
        performSegue(withIdentifier: "unwindtoMainHostMP", sender: nil)
    }
    
    //Update the information for other devices connected to this lobby
    func updateGuestInfo(){
        
        
        let imageRef = storage.child("user").child(hostName).child("Image.jpeg")
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        imageRef.put(UIImageJPEGRepresentation((musicPlayer.nowPlayingItem?.artwork?.image(at: size)) ?? #imageLiteral(resourceName: "UnknownSong"), 0.8)!, metadata: metaData)

        
        self.curentSongInfo.updateValue((["title":allSongList?[songIDAdded[currentSongNumber]].title! as Any , "albumTitle":allSongList?[songIDAdded[currentSongNumber]].albumTitle! as Any, "artist":allSongList?[songIDAdded[currentSongNumber]].artist! as Any, "SongID":songIDAdded[currentSongNumber]] as AnyObject), forKey: "CurrentSong")
        
        self.ref.child("users").child(self.hostName).updateChildValues(curentSongInfo)

    }
    
    
    // MARK: - Navigation
//Segue to addASong
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if exitingBool == false{
        let hostAddSongVC: HostAddSongViewController = segue.destination as! HostAddSongViewController
            
        hostAddSongVC.hostName = hostName
        hostAddSongVC.numberOfSongs = numberOfSongs
    }
  }
    
    
    
    @IBAction func unwindToHostMP(_ segue: UIStoryboardSegue){
     
        exitingBool = true
    }

}
