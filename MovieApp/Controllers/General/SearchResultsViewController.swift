//
//  SearchResultsViewController.swift
//  MovieApp
//
//  Created by Serhat Yılmazer on 3.06.2022.
//

import UIKit
protocol SearchResultsViewControllerDelegate : AnyObject{
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}
class SearchResultsViewController: UIViewController {
    public var titles : [Title] = [Title]()
    
    public weak var delegate : SearchResultsViewControllerDelegate?
    public let searchResultCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3  - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(TitleCollectionTableViewCell.self, forCellWithReuseIdentifier: TitleCollectionTableViewCell.identifier)
        return collectionview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionTableViewCell.identifier, for: indexPath) as? TitleCollectionTableViewCell else {
                return UICollectionViewCell()
            }
            
            
            let title = titles[indexPath.row]
            cell.configure(with: title.poster_path ?? "")
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title  else {return}
        guard let titleOverview = title.overview  else {return}
        
            APICaller.shared.getMovie(with: titleName + " trailer"){
               [weak self] result in
                switch result {
                    case .success(let videoElement):
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                    self?.delegate?.searchResultsViewControllerDidTapItem(viewModel)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        
        
    }
}
