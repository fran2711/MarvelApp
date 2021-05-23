//
//  CharacterDetailViewController.swift
//  Marvel Heroes
//
//  Created by Fran Lucena on 28/11/2020.
//

import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characerNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var characterDetailViewModel = CharacterDetailViewModel()
    var characterId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        
        if let id = characterId {
            characterDetailViewModel.fetchCharacterDetail(id: id) { (response) in
                DispatchQueue.main.async {
                    self.configureCharacterDetail()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func configureCharacterDetail() {
        var imageUrl = ""
        let character = characterDetailViewModel.character
        if let path = character.thumbnail?.path, let imageExtension = character.thumbnail?.extension {
            imageUrl = UtilFunctions.getImageUrl(path: path, extensionString: imageExtension)
        }
        
        characterImageView.sd_setImage(with: URL(string: imageUrl))
        
        characerNameLabel.text = character.name
        characerNameLabel.isHidden = false
        characterDescriptionLabel.text = character.description
        characterDescriptionLabel.isHidden = false
    }
}
