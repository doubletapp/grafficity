import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let mapViewController = UIStoryboard(name: "MapView", bundle: nil).instantiateInitialViewController()
        self.present(mapViewController!, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let mainViewController = MainViewController()
        present(mainViewController, animated: true)
    }
}

