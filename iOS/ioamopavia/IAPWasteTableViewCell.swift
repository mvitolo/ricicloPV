//
//  IAPWasteTableViewCell.swift
//  ioamopavia
//
//  Created by Matteo on 13/09/16.
//  Copyright © 2016 Matteo. All rights reserved.
//

import UIKit

class IAPWasteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var disposeImage: UIImageView!
    @IBOutlet weak var disposeDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
