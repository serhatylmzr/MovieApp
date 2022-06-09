//
//  DownloadsViewController.swift
//  MovieApp
//
//  Created by Serhat Yılmazer on 2.06.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var titles : [TitleItem] = [TitleItem]()
    private let downloadTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTable)
        fetchLocalStorageForDownload()
        downloadTable.delegate = self
        downloadTable.dataSource = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil){
            _ in
            self.fetchLocalStorageForDownload()
        }

    }
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTitlesFromDatabase{
            [weak self] result in
           switch result{
           case .success(let titles):
               self?.titles  = titles
               DispatchQueue.main.async {
                   self?.downloadTable.reloadData()
               }
               
           case .failure(let error):
               print(error.localizedDescription)
           }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }

}

extension DownloadsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown", posterURL: titles[indexPath.row].poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title  else {return}
        guard let titleOverview = title.overview  else {return}
        APICaller.shared.getMovie(with: titleName){
               [weak self] result in
                switch result {
                    case .success(let videoElement):
                    DispatchQueue.main.async {
                        let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                        let vc = TitlePreviewViewController()
                        vc.configure(with: viewModel)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                       
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle {
            case .delete:
                
                DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                    switch result {
                    case .success():
                        print("Deleted fromt the database")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            default:
                break;
            }
        }
}
