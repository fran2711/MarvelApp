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
    var offset = 0
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
        charactersListViewModel.fetchCharacters(offset: self.offset, orderBy: "name") { (response) in
            self.offset += 50
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
            self.loadMoreActivityIndicator?.start{
                self.charactersListViewModel.fetchMoreCharacters(offset: self.offset, orderBy: "name") { (response) in
                    self.offset += 50
                    DispatchQueue.main.async {
                        self.loadMoreActivityIndicator?.stop()
                        self.heroesTableView.reloadData()
                    }
                }
            }
        }
    }
}

