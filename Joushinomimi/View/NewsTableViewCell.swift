//
//  NewsTableViewCell.swift
//  Joushinomimi
//
//  Created by Raphael on 2020/03/24.
//  Copyright © 2020 takahashi. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlToImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
