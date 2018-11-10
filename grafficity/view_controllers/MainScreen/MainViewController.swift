import Foundation
import UIKit


class MainViewController: UITabBarController {
    
    var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapViewController = UIViewController()
        let feedViewController = UIViewController()
        let addViewController = UIViewController()
        guard let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() else { return }
        let settingsViewController = UIViewController()

        mapViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_map_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_map_icon"))
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_feed_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_feed_icon"))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_profile_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_profile_icon"))
        settingsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar_settings_icon")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar_settings_icon"))
        addViewController.tabBarItem.isEnabled = false

        addCentralButton()
        initImagePickerController()

        tabBar.tintColor = UIColor(netHex: 0xe04a3d)
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white

        viewControllers = [mapViewController, feedViewController, addViewController, profileViewController, settingsViewController]
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

