//
//  MenuHeaderView.swift
//  Eatery
//
//  Created by Eric Appel on 11/18/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit
import DiningStack

@objc protocol MenuButtonsDelegate {
    func favoriteButtonPressed()
    @objc optional func shareButtonPressed()
}

class MenuHeaderView: UIView {
    
    var eatery: Eatery!
    var delegate: MenuButtonsDelegate?
    var displayedDate: Date!
    
    var mapButtonPressed: (Void) -> Void = {}

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    override func awakeFromNib() {
        favoriteButton.setImage(UIImage(named: "whiteStar"), for: UIControlState())
        shareButton.setImage(UIImage(named: "shareIcon"), for: UIControlState())
    }
    
    func setUp(_ eatery: Eatery, date: Date) {
        self.eatery = eatery
        self.displayedDate = date

        // Status View
        let eateryStatus = eatery.generateDescriptionOfCurrentState()
        switch eateryStatus {
        case .open(_):
            break
        case .closed(_):
            break
        }
        
        // Payment View
        var paymentTypeViews: [UIImageView] = []
        
        if (eatery.paymentMethods.contains(.Swipes)) {
            let swipeIcon = UIImageView(image: UIImage(named: "swipeIcon"))
            paymentTypeViews.append(swipeIcon)
        }
        
        if (eatery.paymentMethods.contains(.BRB)) {
            let brbIcon = UIImageView(image: UIImage(named: "brbIcon"))
            paymentTypeViews.append(brbIcon)
        }
        
        if (eatery.paymentMethods.contains(.Cash) || eatery.paymentMethods.contains(.CreditCard)) {
            let cashIcon = UIImageView(image: UIImage(named: "cashIcon"))
            paymentTypeViews.append(cashIcon)
        }
        
        let payTypeView = UIView()
        let payViewSize: CGFloat = 25.0
        let payViewPadding: CGFloat = 10.0
        var payViewFrame = CGRect(x: 0, y: 0, width: payViewSize, height: payViewSize)
        
        for payView in paymentTypeViews {
            payView.frame = CGRect(x: payViewFrame.origin.x, y: 0, width: payViewSize, height: payViewSize)
            payTypeView.addSubview(payView)
            payViewFrame.origin.x += payViewSize + payViewPadding
        }
        
        payTypeView.frame = CGRect(x: 95 - (payViewFrame.origin.x - 10), y: 0, width: payViewFrame.origin.x - 10, height: payViewFrame.height)
        paymentView.addSubview(payTypeView)
        
        // Title Label
        titleLabel.text = eatery.nickname
        if eatery.slug == "RPCC-Marketplace" { titleLabel.text = "Robert Purcell Marketplace Eatery" }
        
        // Hours
        var hoursText = eatery.activeEventsForDate(date: displayedDate)
        if hoursText != "Closed" {
            hoursText = "Open \(hoursText)"
        }
        hoursLabel.text = hoursText
        
        // Background
        backgroundImageView.image = eatery.photo
        renderFavoriteImage()
    }
    
    func renderFavoriteImage() {
        let name = eatery.favorite ? "goldStar" : "whiteStar"
        favoriteButton.setImage(UIImage(named: name), for: .normal)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: AnyObject) {
        eatery.favorite = !eatery.favorite
        renderFavoriteImage()
        
        delegate?.favoriteButtonPressed()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        delegate?.shareButtonPressed?()
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        mapButtonPressed()
    }
    
}
