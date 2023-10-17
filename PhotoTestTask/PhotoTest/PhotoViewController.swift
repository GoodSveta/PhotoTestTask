//
//  PhotoViewController.swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import UIKit

class PhotoViewController: UIViewController {
    
    enum Identifier: String {
        case PhotoCollectionViewCell
    }
    var imagePicker: UIImagePickerController!
    var photoVM: (PhotoProtocolIn & PhotoProtocolOut)?
    
    init(photoVM: PhotoProtocolIn & PhotoProtocolOut) {
        self.photoVM = photoVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let imageView = UIImageView()
    private lazy var customSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = true
        uiSwitch.onTintColor = .white
        uiSwitch.backgroundColor = .darkGray
        uiSwitch.layer.cornerRadius = 16
        uiSwitch.thumbTintColor = .systemYellow
        uiSwitch.addTarget(self, action: #selector(changeScreenMode), for: .valueChanged)
        return uiSwitch
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 3
        return collectionView
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupLayout()
        setupTableView()
        lisenViewModel()
        setupNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoVM?.getData()
        
    }
    
    private func setupTableView() {
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func addViews() {
        [collectionView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false})
        collectionView.addSubview(activityView)
    }
    
    func setupLayout() {
        view.addConstraints([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            activityView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    
    func lisenViewModel() {
        guard var photoVM = photoVM else { return }
        
        photoVM.reloadCollectionView = { [weak self] in
            self?.collectionView.reloadData()
            self?.activityView.stopAnimating()
        }
        
        photoVM.showError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityView.stopAnimating()
                self.showAlert(with: error.localizedDescription)
            }
        }
    }
    private func setupNavigationBar() {
        title = "Hello :)"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppereance = UINavigationBarAppearance()
        navBarAppereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppereance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppereance.backgroundColor = .lightGray
        navigationController?.navigationBar.standardAppearance = navBarAppereance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance
        
        let navBarSwitch = UIBarButtonItem(customView: customSwitch)
        navigationItem.leftBarButtonItems = [navBarSwitch]
    }
    @objc private func changeScreenMode(sender: UISwitch) {
        if sender.isOn {
            view.backgroundColor = .white
            collectionView.reloadData()
        } else {
            view.backgroundColor = .darkGray
            collectionView.reloadData()
        }
    }
}


extension PhotoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        
        
        //чтобы открыть камеру (на симуляторе не работает, только на реальном устройстве) изменить на cameraVc.sourceType = UIImagePickerController.SourceType.camera
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemPerRow: CGFloat = 2
        let paddingWith = 20 * (itemPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWith
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photoVM = photoVM else { return 0 }
        
        return photoVM.dataPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell, let photoVM = photoVM else { return UICollectionViewCell() }
        
        cell.setupCell(with: photoVM.dataPhoto[indexPath.item])
        
        if customSwitch.isOn {
            cell.backgroundColor = .lightGray
            cell.name.textColor = .black
        } else {
            cell.backgroundColor = .darkGray
            cell.name.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == (photoVM?.dataPhoto.count ?? 0) - 1 {
            photoVM?.getData()
        }
    }
}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            
            self.imageView.image = image
            
            NetworkServiceManager.shared.uploadImage(name: "Sveta Good", photo: image, typeid: "jpeg")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
