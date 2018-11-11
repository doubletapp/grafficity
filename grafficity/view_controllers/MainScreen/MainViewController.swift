import Foundation
import UIKit


class MainViewController: UITabBarController {
    
    var imagePicker: UIImagePickerController?
    let centralButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        let addViewController = UIViewController()
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() else { return }
        guard let mapViewController = UIStoryboard(name: "MapView", bundle: nil).instantiateInitialViewController() else { return }
        guard let settingsViewController = UIStoryboard(name: "SettingsScreenView", bundle: nil).instantiateInitialViewController() else {
            return }
        guard let feedViewController = UIStoryboard(name: "FeedStoryboard", bundle: Bundle.main).instantiateInitialViewController() else { return }

        mapViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_map_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_map_icon"))
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_feed_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_feed_icon"))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_profile_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_profile_icon"))
        settingsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_settings_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_settings_icon"))
        addViewController.tabBarItem.isEnabled = false

        addCentralButton()
        customizeTabBar()
        initImagePickerController()

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

        centralButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)

        centralButton.setBackgroundImage(centralButtonImage, for: .normal)
        centralButton.setBackgroundImage(centralButtonImage, for: .highlighted)


        tabBar.addSubview(centralButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let centralButtonImage = UIImage(named: "tabbar_plus_icon") else { return }

        centralButton.frame = CGRect(x: 0, y: 0, width: centralButtonImage.size.width, height: centralButtonImage.size.height)
        centralButton.center = CGPoint(x: tabBar.center.x, y: 14)
    }

    private func initImagePickerController() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        self.imagePicker = imagePicker
    }

    @objc func addButtonAction() {
        guard let imagePicker = imagePicker else { return }
        
        present(imagePicker, animated: true)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true) { [weak self] in
            
            let storyboard = UIStoryboard(name: "ARPlacementObject", bundle: Bundle.main)
            if let vc = storyboard.instantiateInitialViewController() as? ARObjectPlacementViewController {
                
                vc.sourceImage = UIImage(named: "testImage")
                self?.present(vc, animated: true)
            }
        }
    }
}

