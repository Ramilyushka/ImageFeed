import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol! { get set }
    var tableView: UITableView! { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func setTableView()
}

final class ImagesListViewController: UIViewController&ImagesListViewControllerProtocol {
    
    let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    var presenter: ImagesListPresenterProtocol!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = ImagesListPresenter(view: self, imagesListService: ImagesListService.shared)
        }
        
        presenter.view = self
        //presenter.fetchPhotos()
        presenter.viewDidLoad()
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func configCell (for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard
            let url = URL(string: presenter.photos[indexPath.row].thumbImageURL)
        else { return }
        
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "stub_image"),
            completionHandler: { result in
                switch result{
                case .success(_):
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(_):
                    return
                }
            })
        
        cell.setDate(createdAt: presenter.photos[indexPath.row].createdAt)
        cell.setIsLiked(isLike: presenter.photos[indexPath.row].isLiked)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sizePhoto = presenter.photos[indexPath.row].size
        return presenter.calculateHeightRow(size: sizePhoto, widthBounds: tableView.bounds.width)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter.photos.count {
            presenter.fetchPhotos()
        }
        else { return }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = presenter.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        presenter.fetchChangeLike(photo: photo) { result in
            switch result {
            case .success():
                cell.setIsLiked(isLike: self.presenter.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                return
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            guard
                let url = URL(string: presenter.photos[indexPath.row].largeImageURL)
            else { return }
            viewController.fullImageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
