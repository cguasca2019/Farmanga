//
//  discover.swift
//  playground
//
//  Created by Cesar Guasca on 15/12/21.
//

import UIKit

class Discover: UIViewController {
    @IBOutlet weak var collectionTop: UICollectionView!
    @IBOutlet weak var tblDiscover: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    let flowLayout = ZoomAndSnapFlowLayout()
    var viewModel = DiscoverVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionTop.collectionViewLayout = flowLayout
        self.collectionTop.contentInsetAdjustmentBehavior = .always
        self.collectionTop.showsHorizontalScrollIndicator = false
        self.tblDiscover.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        self.viewModel.retrivePopularList()
        
        self.bind()
    }
    
    func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionTop.reloadData()
                self?.viewModel.retriveSeasonLater()
                self?.bindTbl()
            }
        }
    }
    
    func bindTbl() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.tblDiscover.reloadData()
                self?.indicator.isHidden = true
                self?.indicator.stopAnimating()
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

extension Discover:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topAnimes?.top?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DiscoverTopCell
        
        let mangaSel = viewModel.topAnimes?.top?[indexPath.row]
        
        if let posterPath = mangaSel?.imageURL {
            let url = URL(string: posterPath)!
            CachedImages().loadData(url: url) { (data, error) in
                DispatchQueue.main.async {
                    if let dataOk = data {
                        cell.imgTop.image = UIImage(data: dataOk)
                        cell.imgTop.layer.cornerRadius = 16.0
                        cell.imgTop.clipsToBounds = true
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mangaSel = viewModel.topAnimes?.top?[indexPath.row]
        if let mangaSelFaw = mangaSel {
            self.goDetail(animeId: mangaSelFaw.malID)
        }
    }
}

extension Discover: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.seasonLaterAnimes?.anime.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! DiscoverSessionLastCell
        let mangaSel = viewModel.seasonLaterAnimes?.anime[indexPath.row]
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
        let mangaSel = viewModel.seasonLaterAnimes?.anime[indexPath.row]
        if let mangaSelFaw = mangaSel {
            self.goDetail(animeId: mangaSelFaw.malID)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0;//Choose your custom row height
    }
    
}

extension Discover: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransition()
    }
}
