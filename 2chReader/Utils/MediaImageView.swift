//
//  MediaImageView.swift
//  2chReader
//
//  Created by NIkolay Tsygankov on 5/17/16.
//  Copyright © 2016 Endogenesis. All rights reserved.
//

import UIKit

protocol MediaImageViewDelegate:class {
    func showWebm()
    func showFullImage()
}

class MediaImageView: UIImageView {
    var isWebm = false
    var mediaPath: String = ""
    var playImageView: UIImageView? = nil
    weak var delegate: MediaImageViewDelegate? = nil
    
    override func awakeFromNib() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MediaImageView.tapped))
        gestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    override func layoutSubviews() {
        if let playImageView = self.playImageView {
            playImageView.center = self.center
        }
    }
    
    func showWebmButton() {
        if self.playImageView == nil {
            self.playImageView = UIImageView(image: UIImage(named: "playVideo"))
            self.addSubview(self.playImageView!)
        } else {
            self.playImageView?.hidden = false
        }
    }
    
    func hideWebmButton() {
        if let playImageView = self.playImageView {
            playImageView.hidden = true
        }
    }
    
    func tapped() {
        if let delegate = self.delegate {
            if isWebm {
                delegate.showWebm()
            } else {
                delegate.showFullImage()
            }
        }
    }
}
