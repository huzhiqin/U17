//
//  AuthorComicListVC.swift
//  U17
//
//  Created by lyw on 2020/5/21.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class AuthorComicListVC: BaseController {
    private var author: Author?
    private var otherWorks: [OtherWorks]?

    private var authorHead: UIImageView = {
        let head = UIImageView()
        return head
    }()
    
    private var authorName: UILabel = {
        let name = UILabel()
        name.font = .boldSystemFont(ofSize: 20)
        name.textAlignment = .center
        return name
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: OtherWorksCollectionViewCell.self)
        return collectionView
    }()

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.white)
        navigationItem.title = "作者其他作品"
    }

    convenience init(author: Author?, otherWorks: [OtherWorks]?) {
        self.init()
        self.author = author
        self.otherWorks = otherWorks
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    override func setupLayout() {
        authorHead.kf.setImage(urlString: author?.avatar, placeholder:UIImage(named:"sortPlace"))
        authorName.text = author?.name
        
        view.addSubview(authorHead)
        authorHead.snp.makeConstraints { (make) in
            make.top.equalTo(120)
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        authorHead.layer.cornerRadius = 25
        authorHead.layer.masksToBounds = true
        
        view.addSubview(authorName)
        authorName.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(authorHead.snp_bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(authorName.snp_bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension AuthorComicListVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherWorks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 40) / 3)
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: OtherWorksCollectionViewCell.self)
        cell.model = otherWorks?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let comicId = otherWorks?[indexPath.row].comicId else { return }
        
        let storyboard = UIStoryboard(name: "ComicIntroVC", bundle: nil)
        let cimicIntroVC = storyboard.instantiateViewController(withIdentifier: "ComicIntroVC") as! ComicIntroVC
        cimicIntroVC.comicId = Int(comicId) ?? 0
        navigationController?.pushViewController(cimicIntroVC, animated: true)

    }
}

