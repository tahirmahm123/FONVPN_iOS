//
//  RawCells.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 26/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import UIKit

public protocol FavouritesSelected : AnyObject{
    func favouritesTapped(serverName: String, id: String, serverId: Int)
}

public protocol ServerOptionSelected : AnyObject{
    func buttonTapped(id: Int)
}

class ChildAndFavouriteRow: UITableViewCell {
    weak var delegate : FavouritesSelected?
    var serverId: Int = 0
    @IBOutlet weak var serverCountryFlag: UIImageView!
    @IBOutlet weak var selectedServerButton: UIButton!
    @IBOutlet weak var serverCity: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var serverSignalStrength: UIImageView!
    @IBAction func favouritePressed(_ sender: UIButton) {
        favouriteButton.isSelected = !sender.isSelected
        self.delegate?.favouritesTapped(serverName: serverCity.text ?? "", id: "\(self.tag)", serverId: serverId)
    }
}
class HeaderView: UITableViewCell {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var expandableImageView: UIImageView!
    @IBOutlet weak var serverCountry: UILabel!
    @IBOutlet weak var serverCountryFlag: UIImageView!
}

class ServerHeaderCell: UITableViewCell {
    @IBOutlet weak var expandableImageView: UIImageView!
    @IBOutlet weak var serverCountry: UILabel!
    @IBOutlet weak var serverCountryFlag: UIImageView!
    @IBOutlet weak var locationCountLbl: UILabel!
    @IBOutlet weak var headerBtn: UIButton!
    weak var delegate : ServerOptionSelected?
    @IBAction func btnPressed(_ sender: Any) {
        self.delegate?.buttonTapped(id: self.tag)
    }
    
    
}

class ServerRowCell: UITableViewCell {
    weak var delegate : FavouritesSelected?
    var serverId: Int = 0
    @IBOutlet weak var selectedServerButton: UIButton!
    @IBOutlet weak var serverCity: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var serverSignalStrength: UIImageView!
    @IBOutlet weak var pingMs: UILabel!
    @IBAction func favouritePressed(_ sender: UIButton) {
        favouriteButton.isSelected = !sender.isSelected
        self.delegate?.favouritesTapped(serverName: serverCity.text ?? "", id: "\(serverId)", serverId: serverId)
    }
    
}

class RandomFastestRowCell: UITableViewCell {
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class ServerDetailsCell: UITableViewCell {
    weak var delegate : FavouritesSelected?
    var serverId: Int = 0
    @IBOutlet weak var serverCountryFlag: UIImageView!
    @IBOutlet weak var serverName: UILabel!
    @IBOutlet weak var serverCountryName: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var pingMs: UILabel!
    @IBOutlet weak var serverSignalStrength: UIImageView!
    @IBAction func favouritePressed(_ sender: UIButton) {
        favouriteButton.isSelected = !sender.isSelected
        self.delegate?.favouritesTapped(serverName: serverName.text ?? "", id: "\(serverId)", serverId: serverId)
    }
}


class LinksTableViewCell: UITableViewCell {
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var linkNameLbl: UILabel!
    func setUpCell()  {
        self.layer.cornerRadius = 10
            //        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(named: "TableBorderColor")?.cgColor
    }
}

