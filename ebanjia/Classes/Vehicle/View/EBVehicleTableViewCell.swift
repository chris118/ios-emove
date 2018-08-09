//
//  EBVehicleTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBVehicleTableViewCell: UITableViewCell {
    var checked: Bool = false  {
        didSet {
            checkButton.isSelected = checked
        }
    }
    @IBOutlet weak var starView: EBStarRateView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starView.setBottomImageName("b27_icon_star_gray", topImgName: "b27_icon_star_yellow", WJXCount: 5)
        starView.scorePercent = 0.4  //默认评分  (0 - 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
