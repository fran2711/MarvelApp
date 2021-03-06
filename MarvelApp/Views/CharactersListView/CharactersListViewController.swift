//
//  ViewController.swift
//  Marvel Heroes
//
//  Created by Fran Lucena on 26/11/2020.
//

import UIKit

class CharactersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    

    @IBOutlet var heroesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loadMoreActivityIndicator: LoadMoreActivityIndicator?
    var charactersListViewModel = CharactersListViewModel()
    let cellId = "CharacterCellId"
    var characterId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heroesTableView.register(UINib(nibName: "CharactersTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        loadMoreActivityIndicator = LoadMoreActivityIndicator(scrollView: heroesTableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        loadMoreActivityIndicator?.setColor(color: UIColor.white)
        fetchData()
    }

    
    func fetchData() {
        activityIndicator.startAnimating()
        heroesTableView.isUserInteractionEnabled = false
        charactersListViewModel.fetchCharacters(orderBy: Constants.orderByName) { (response) in
            DispatchQueue.main.async {
                self.heroesTableView.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                self.heroesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charactersListViewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: CharactersTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CharactersTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCharacterCell(character: charactersListViewModel.characters[indexPath.row])
        
        return cell
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            scrollView.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
//            self.loadMoreActivityIndicator?.start{
                self.charactersListViewModel.fetchMoreCharacters(orderBy: Constants.orderByName) { (response) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        scrollView.isUserInteractionEnabled = true
//                        self.loadMoreActivityIndicator?.stop()
                        self.heroesTableView.reloadData()
                    }
//                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let characterId = charactersListViewModel.characters[indexPath.row].id {
            self.characterId = characterId
            self.performSegue(withIdentifier: "ShowCharacterDetailSegue", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCharacterDetailSegue" {
            guard let vController: CharacterDetailViewController = segue.destination as? CharacterDetailViewController else {
                return
            }
            vController.characterId = self.characterId
        }
    }
}

