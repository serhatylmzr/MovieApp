//
//  CollectionTableViewCell.swift
//  MovieApp
//
//  Created by Serhat Yılmazer on 2.06.2022.
//

import UIKit
protocol CollectionTableViewCellDelegate : AnyObject{
    func collectionTableViewCellDidTapCell(_ cell :CollectionTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionTableViewCell: UITableViewCell {

    static let identifier = "CollectionTableViewCell"
    
    weak var delegate : CollectionTableViewCellDelegate?
    
    private var titles : [Title] = [Title]()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionTableViewCell.self, forCellWithReuseIdentifier: TitleCollectionTableViewCell.identifier)
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles : [Title]){
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData() 
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath){
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]){
            result in
            
            switch result {
                case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil )
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

extension CollectionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionTableViewCell.identifier, for: indexPath) as? TitleCollectionTableViewCell else {return UICollectionViewCell()}
            
            guard let model = titles[indexPath.row].poster_path else {
                return UICollectionViewCell()}
            cell.configure(with: model)
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title  else {return}
        guard let titleOverview = title.overview  else {return}
        
            APICaller.shared.getMovie(with: titleName + " trailer"){
               [weak self] result in
                switch result {
                    case .success(let videoElement):
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                        
                        guard let strongSelf = self else {return}
                        self?.delegate?.collectionTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){
           [weak self] _ in
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off){
                _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "Download", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
    
    
