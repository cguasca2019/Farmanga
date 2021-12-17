//
//  Detail.swift
//  playground
//
//  Created by Cesar Guasca on 16/12/21.
//
import UIKit
import Cosmos

class Detail: UIViewController {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var vwType: ViewRoundAndShadow!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var vwStatus: ViewRoundAndShadow!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var titleAnime: UILabel!
    @IBOutlet weak var genders: UILabel!
    @IBOutlet weak var episodes: UILabel!
    @IBOutlet weak var starCount: CosmosView!
    @IBOutlet weak var scoreValue: UILabel!
    @IBOutlet weak var participants: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    var mangaId: Int?
    var viewModel = DetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mangaIdFaw = mangaId {
            viewModel.retrivePopularList(animeIdView: mangaIdFaw)
            self.bind()
        }
    }
    
    func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                if let posterPath = self?.viewModel.detailAnimes?.imageURL {
                    let url = URL(string: posterPath)!
                    CachedImages().loadData(url: url) { (data, error) in
                        DispatchQueue.main.async {
                            if let dataOk = data {
                                self?.img.image = UIImage(data: dataOk)
                                self?.img.layer.cornerRadius = 16.0
                                self?.img.clipsToBounds = true
                            }
                        }
                    }
                }
                self?.titleAnime.text = self?.viewModel.detailAnimes?.title
                self?.synopsis.text = self?.viewModel.detailAnimes?.synopsis
                
                if let strType = self?.viewModel.detailAnimes?.type {
                    switch strType {
                    case "-":
                        self?.vwType.backgroundColor = UIColor(named: "empty")
                        self?.type.text = "-"
                    case "TV":
                        self?.vwType.backgroundColor = UIColor(named: "tvSeries")
                        self?.type.text = "TV Series"
                    case "Movie":
                        self?.vwType.backgroundColor = UIColor(named: "movie")
                        self?.type.text = "Movie"
                    case "ONA":
                        self?.vwType.backgroundColor = UIColor(named: "ona")
                        self?.type.text = "ONA"
                    case "OVA":
                        self?.vwType.backgroundColor = UIColor(named: "ova")
                        self?.type.text = "OVA"
                    case "Special":
                        self?.vwType.backgroundColor = UIColor(named: "special")
                        self?.type.text = "Special"
                    default:
                        self?.vwType.backgroundColor = UIColor(named: "empty")
                        self?.type.text = "-"
                    }
                }
                
                if let airing = self?.viewModel.detailAnimes?.airing {
                    if airing {
                        self?.vwStatus.backgroundColor = UIColor(named: "ova")
                        self?.status.text = "Airing"
                    } else {
                        self?.vwStatus.backgroundColor = UIColor(named: "empty")
                        self?.status.text = "Finished Airing"
                    }
                } else {
                    self?.vwStatus.backgroundColor = UIColor(named: "empty")
                    self?.status.text = "No Status"
                }
            }
            
            if let genders = self?.viewModel.detailAnimes?.genres {
                var arrGen: [String] = []
                for gen in genders {
                    arrGen.append(gen.name)
                }
                DispatchQueue.main.async {
                    self?.genders.text = arrGen.joined(separator: ", ")
                }
            }
            
            if let intEpisodes = self?.viewModel.detailAnimes?.episodes {
                DispatchQueue.main.async {
                    self?.episodes.text = "Episodes: \(intEpisodes)"
                }
            } else {
                DispatchQueue.main.async {
                    self?.episodes.text = "Episodes: -"
                }
            }
            
            if let dblScore = self?.viewModel.detailAnimes?.score {
                DispatchQueue.main.async {
                    self?.scoreValue.text = String(format: "%.1f", dblScore / 2)
                    self?.starCount.rating = (dblScore / 2)
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.scoreValue.text = "0"
                    self?.starCount.rating = 0
                }
            }
            
            if let dblScore = self?.viewModel.detailAnimes?.scoreBy {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                DispatchQueue.main.async {
                    self?.participants.text = "(\(String(describing: numberFormatter.string(from: NSNumber(value: dblScore))!)) votes)"
                }
                
            } else {
                DispatchQueue.main.async {
                    self?.participants.text = "(0 votes)"
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
