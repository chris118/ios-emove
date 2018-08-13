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
    var data : UsableFleet? {
        didSet {
            if let _data = data {
                titleLabel.text = _data.fleetName
                evaluateLabel.text = "\(_data.evaluateCount ?? 0)次点评"
                addressLabel.text = _data.fleetAddress
                discountLabel.text = String((_data.discount ?? 0)/10)
                starView.scorePercent = 0.2 * CGFloat(_data.evaluateStar ?? 0 )
                leftLabel.text = String(_data.remainder ?? 0)
            }
        }
    }
    
    @IBOutlet weak var starView: EBStarRateView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var evaluateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
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
