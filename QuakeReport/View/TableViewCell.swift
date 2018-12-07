//
//  TableViewCell.swift
//  QuakeReport
//
//  Created by Trung on 11/19/18.
//  Copyright © 2018 Trung. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        magLabel.text = ""
        distanceLable.text = ""
        locationLable.text = ""
        dateLable.text = ""
        timeLable.text = ""
    }
}

@IBDesignable
class CustomLabel: UILabel {
    private var _cornerRadius: CGFloat = 0.0
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set (newValue) {
            _cornerRadius = newValue
            setCornerRadius()
        }
        get {
            return _cornerRadius
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    func setCornerRadius() {
        if _cornerRadius == -1 {
            layer.cornerRadius = frame.height * 0.5
        } else {
            layer.cornerRadius = _cornerRadius
        }
    }
}
