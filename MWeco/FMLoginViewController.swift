//
//  FMLoginViewController.swift
//  M_fm
//
//  Created by 张逸 on 16/4/11.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import Alamofire

class FMLoginViewController: UIViewController {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackLargeImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!

    var channels = [DBChannel]()
    var channelSongDictionary = [DBChannel: DBSongList]()
    var currentTrack: DBSong? {
        didSet {
            trackNameLabel.text = currentTrack?.albumtitle
            artistLabel.text = currentTrack?.artist
        }
    }
    var downloadButton: MZButtonProgressView!
    var hasDownload = false

    //IBActions
    @IBAction func playButtonPressed(sender: UIButton) {
        if let currentTrack = currentTrack {
            if currentTrack.filePath != "" {
                print("currentTrack.filePath: \(currentTrack.filePath)")
                DBPlayer.sharedPlayer.playMP3File(withFilePath: currentTrack.filePath)
            }
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
    }

    func downloadButtonPressed(sender: MZButtonProgressView) {
        if hasDownload == true {
            return
        } else {
            hasDownload = true
        }
        print("downloadButtonPressed")
        guard let currentTrack = self.channelSongDictionary[self.channels[1]]?.songs[0] else {
            return
        }
        if DBFileManager.musicSHA256s.contains(currentTrack.sha256) {
            print("music already exist")
        } else {
            sender.transformToPrograssBar()
            Alamofire.download(.GET, currentTrack.mp3URL) { (tmpURL, res) -> NSURL in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                //let pathComponent = res.suggestedFilename
                let fileName = "\(currentTrack.sha256).mp3"
                let storePath = directoryURL.URLByAppendingPathComponent(fileName)
                print("fileName: \(fileName)")
                self.currentTrack?.filePath = storePath.path ?? ""
                print("store at: \(self.currentTrack?.filePath)")
                return storePath
            }.progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                dispatch_async(dispatch_get_main_queue(), {
                    let progress = CGFloat(Float(totalBytesRead) / Float(totalBytesExpectedToRead))
                    self.downloadButton.updateProgress(progress)
                })
            }.response { (req, res, data, error) in
                if let error = error {
                    print("download error: \(error)")
                } else {
                    print("Download file successfully")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initDownloadButton()
        DBFileManager.getMP3FilePath()
        Alamofire.request(.GET, DBURL.getChannels).responseJSON {
            res in
            let json = JSON(res.result.value ?? [])
            if let err = res.result.error {
                print("err: \(err)")
            } else if let channels = json["channels"].array {
                for channel in channels {
                    let channelModel = DBChannel(withJSON: channel)
                    self.channels.append(channelModel)
                }
                let testChannelID = self.channels[1].channel_id
                Alamofire.request(.GET, DBURL.getMusicWithChannel(testChannelID)).responseJSON {
                    res in
                    let json = JSON(res.result.value ?? [])
                    if let err = res.result.error {
                        print(err)
                    } else {
                        let songList = DBSongList(withJSON: json)
                        self.channelSongDictionary[self.channels[1]] = songList
                        guard let currentTrack = self.channelSongDictionary[self.channels[1]]?.songs[0] else {
                            return
                        }
                        self.currentTrack = currentTrack
                        let picURL = currentTrack.pictureURL
                        let sha256 = currentTrack.sha256
                        print("ssid: \(currentTrack.ssid)")
                        print("sid: \(currentTrack.sid)")
                        print("aid: \(currentTrack.aid)")
                        if DBFileManager.musicSHA256s.contains(sha256) {
                            print("sha256 contains")
                            self.hasDownload = true
                            self.downloadButton.setImage(UIImage(named: "tick"), forState: .Normal)
                            self.downloadButton.setImage(UIImage(named: "tick"), forState: .Highlighted)
                        }
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            let trackImage = UIImage.download(withURL: picURL ?? "")
                            dispatch_async(dispatch_get_main_queue()) {
                                self.trackImageView.image = trackImage
                                self.trackLargeImageView.image = trackImage
                            }
                        }
                    }
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageViewCornerRadius = self.trackImageView.frame.width / 2
        self.trackImageView.layer.cornerRadius = imageViewCornerRadius
        let largeImageViewCornerRadius = self.trackLargeImageView.frame.width / 2
        self.trackLargeImageView.layer.cornerRadius = largeImageViewCornerRadius
        self.trackImageView.clipsToBounds = true
        self.trackLargeImageView.clipsToBounds = true
    }

    private func initDownloadButton() {
        let width = self.playerView.frame.height * 0.8
        let progressBarLength = width * 3
        downloadButton = MZButtonProgressView(frame: CGRectMake(0, 0, width, width), progressBarLength: progressBarLength)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.addTarget(self, action: #selector(downloadButtonPressed), forControlEvents: .TouchUpInside)
        downloadButton.setImage(UIImage(named: "download"), forState: .Normal)
        downloadButton.endImage = UIImage(named: "tick")
        self.view.addSubview(downloadButton)
        self.view.addConstraints([
            NSLayoutConstraint(item: downloadButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: downloadButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width),
            NSLayoutConstraint(item: downloadButton, attribute: .CenterX, relatedBy: .Equal, toItem: playerView, attribute: .CenterX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: downloadButton, attribute: .Bottom, relatedBy: .Equal, toItem: playerView, attribute: .Top, multiplier: 1.0, constant: -20.0)
            ])
    }
}
