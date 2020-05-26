//
//  TabBarController.swift
//  U17
//
//  Created by lyw on 2020/5/13.
//  Copyright © 2020 胡智钦. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        tabBar.isTranslucent = false

        setupLayout()
        
        selectedIndex = 1
    }
    
    func setupLayout() {
        // 社区
        let communityVC = CommunityVC()
        addChildController(communityVC,
                           title: "社区",
                           image: UIImage(named: "tab_today"),
                           selectedImage: UIImage(named: "tab_today_selected"))
        
        // 发现
        let homeVC = HomeVC()
        addChildController(homeVC,
                           title: "发现",
                           image: UIImage(named: "tab_find"),
                           selectedImage: UIImage(named: "tab_find_selected"))
        
                
        
        // 书架
        let bookSegmentVC = BookrackVC(titles: ["收藏",
                                                "书单",
                                                "历史",
                                                "下载"],
                                            vcs: [BookCollectionVC(),
                                                  BookListVC(),
                                                  ReadHistoryVC(),
                                                  DownloadVC()],
                                            segmentStyle: .navgationBarSegment)

        addChildController(bookSegmentVC,
                           title: "书架",
                           image: UIImage(named: "tab_book"),
                           selectedImage: UIImage(named: "tab_book_selected"))
        
        
        // 我的
        let mineVC = MineVC()
        addChildController(mineVC,
                           title: "我的",
                           image: UIImage(named: "tab_mine"),
                           selectedImage: UIImage(named: "tab_mine_selected"))

    }
    
    func addChildController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
        
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(NaviController(rootViewController: childController))
    }

}


extension TabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}
