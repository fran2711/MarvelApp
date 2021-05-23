//
//  CharactersTableViewCell.swift
//  Marvel Heroes
//
//  Created by Fran Lucena on 28/11/2020.
//

import UIKit
import SDWebImage

class CharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.sd_setImage(with: URL(string: ""))
    }
    
    func configureCharacterCell(character: Character) {
        var imageUrl = ""
        if let path = character.thumbnail?.path, let imageExtension = character.thumbnail?.extension {
            imageUrl = UtilFunctions.getImageUrl(path: path, extensionString: imageExtension)
        }
        
        characterImageView.sd_setImage(with: URL(string: imageUrl))
        characterNameLabel.text = character.name
    }
    
}
