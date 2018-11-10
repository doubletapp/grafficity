import Foundation
import UIKit


class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedViewController = UIViewController()
        let addViewController = UIViewController()
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() else { return }
        guard let mapViewController = UIStoryboard(name: "MapView", bundle: nil).instantiateInitialViewController() else { return }
        let settingsViewController = UIViewController()

        mapViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_map_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_map_icon"))
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_feed_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_feed_icon"))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_profile_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_profile_icon"))
        settingsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_settings_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_settings_icon"))
        addViewController.tabBarItem.isEnabled = false

        addCentralButton()
        customizeTabBar()

        viewControllers = [mapViewController, feedViewController, addViewController, profileViewController, settingsViewController]
    }

    func customizeTabBar() {
        tabBar.tintColor = UIColor(netHex: 0xe04a3d)
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()

        tabBar.layer.masksToBounds = false;
        tabBar.layer.shadowRadius = 9
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    private func addCentralButton() {
        guard let centralButtonImage = UIImage(named: "tabbar_plus_icon") else { return }

        let centralButton = UIButton(type: .custom)

        centralButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)

        centralButton.frame = CGRect(x: 0, y: 0, width: centralButtonImage.size.width, height: centralButtonImage.size.height)
        centralButton.setBackgroundImage(centralButtonImage, for: .normal)
        centralButton.setBackgroundImage(centralButtonImage, for: .highlighted)
        
        centralButton.center = CGPoint(x: tabBar.center.x, y: 14)

        tabBar.addSubview(centralButton)
    }

    @objc func addButtonAction() {
        print("add button selected")
    }
}

