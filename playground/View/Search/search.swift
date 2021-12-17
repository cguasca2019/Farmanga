//
//  search.swift
//  playground
//
//  Created by Cesar Guasca on 16/12/21.
//

import UIKit

class Search: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var vwError: UIView!
    @IBOutlet weak var errormsj: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var strSearch = ""
    var viewModel = SearchVM()
    
    override func viewDidLoad() {
        searchbar.delegate = self
        self.tblSearch.alpha = 0
        self.vwError.alpha = 1
        self.errormsj.text = "Text search is empty"
        
        self.activity.isHidden = true
        self.activity.stopAnimating()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            view.endEditing(true)
            self.strSearch = searchBar.text ?? ""
            self.tblSearch.alpha = 0
            self.vwError.alpha = 1
            self.errormsj.text = "Text search is empty"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if(searchbar.text != ""){
            self.activity.isHidden = false
            self.activity.startAnimating()
            self.strSearch = searchBar.text ?? ""
            self.viewModel.search(query: self.strSearch)
            self.bind()
            
        } else {
            self.tblSearch.alpha = 0
            self.vwError.alpha = 1
            self.errormsj.text = "Text search is empty"
        }
        view.endEditing(true)
    }
    
    func bind(){
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                if let _ = self?.viewModel.detailSearch?.status {
                    self?.tblSearch.alpha = 0
                    self?.vwError.alpha = 1
                    self?.errormsj.text = "No data found"
                    self?.activity.isHidden = true
                    self?.activity.stopAnimating()
                } else {
                    self?.tblSearch.reloadData()
                    self?.activity.isHidden = true
                    self?.activity.stopAnimating()
                }
            }
        }
    }
    
    func goDetail(animeId: Int){
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! Detail
        secondVC.modalPresentationStyle = .custom
        secondVC.transitioningDelegate = self
        secondVC.mangaId = animeId
        
        self.present(secondVC, animated: true, completion: nil)
    }
}


extension Search: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.detailSearch?.results?.count ?? 0
        if count > 0 {
            self.tblSearch.alpha = 1
            self.vwError.alpha = 0
            self.errormsj.text = ""
        } else {
            self.tblSearch.alpha = 0
            self.vwError.alpha = 1
            self.errormsj.text = self.strSearch != "" ? "No data found" : "Text search is empty"
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! DiscoverSessionLastCell
        let mangaSel = viewModel.detailSearch?.results?[indexPath.row]
        cell.title.text = mangaSel?.title
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let dblScore = mangaSel?.score {
            cell.score.text = String(format: "Score: %.1f", dblScore / 2)
        } else {
            cell.score.text = "Score: -"
        }
        
        if let intEpisodes = mangaSel?.episodes {
            cell.episodies.text = "Episodes: \(intEpisodes)"
        } else {
            cell.episodies.text = "Episodes: -"
        }
        
        if let strType = mangaSel?.type {
            switch strType {
            case "-":
                cell.vwType.backgroundColor = UIColor(named: "empty")
                cell.type.text = "-"
            case "TV":
                cell.vwType.backgroundColor = UIColor(named: "tvSeries")
                cell.type.text = "TV Series"
            case "Movie":
                cell.vwType.backgroundColor = UIColor(named: "movie")
                cell.type.text = "Movie"
            case "ONA":
                cell.vwType.backgroundColor = UIColor(named: "ona")
                cell.type.text = "ONA"
            case "OVA":
                cell.vwType.backgroundColor = UIColor(named: "ova")
                cell.type.text = "OVA"
            case "Special":
                cell.vwType.backgroundColor = UIColor(named: "special")
                cell.type.text = "Special"
            default:
                cell.vwType.backgroundColor = UIColor(named: "empty")
                cell.type.text = "-"
            }
        }
        
        if let posterPath = mangaSel?.imageURL {
            let url = URL(string: posterPath)!
            CachedImages().loadData(url: url) { (data, error) in
                DispatchQueue.main.async {
                    if let dataOk = data {
                        cell.imgManga.image = UIImage(data: dataOk)
                        cell.imgManga.layer.cornerRadius = 16.0
                        cell.imgManga.clipsToBounds = true
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mangaSel = viewModel.detailSearch?.results?[indexPath.row]
        if let mangaSelFaw = mangaSel {
            self.goDetail(animeId: mangaSelFaw.malID)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0;//Choose your custom row height
    }
    
}

extension Search: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
