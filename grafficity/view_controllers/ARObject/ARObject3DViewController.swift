import Foundation
import ARKit
import SceneKit

class ARObject3DViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var detectedPlanes: [String: SCNNode] = [:]
    var objectNode: SCNNode?
    let paperPlaneScene = SCNScene(named: "art.scnassets/banana.scn")
    
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("worldMapURL")
        } catch {
            fatalError("Error getting world map URL from document directory.")
        }
    }()
    
    var worldMap: ARWorldMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let worldMapData = retrieveWorldMapData(from: worldMapURL),
            let worldMap = unarchive(worldMapData: worldMapData) {
            
            print("Resotring from saved map...")
            self.worldMap = worldMap
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSession()
        addTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ARObject3DViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard !(anchor is ARPlaneAnchor), objectNode == nil,
            let paperPlaneNode = paperPlaneScene?.rootNode.childNode(withName: "banana_001", recursively: true) else { return }

        let position = anchor.transform.translation
        paperPlaneNode.scale = SCNVector3(0.3, 0.3, 0.3)
        paperPlaneNode.position = SCNVector3(position.x, position.y + 1, position.z)
        paperPlaneNode.eulerAngles.z = .pi / 2
//
//            objectNode = paperPlaneNode
        node.addChildNode(paperPlaneNode)
    }
}

extension ARObject3DViewController {
    
    private func configureSession() {
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.initialWorldMap = worldMap
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.scene.rootNode.name = "ROOT NODE"
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func addTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        
        sceneView.addGestureRecognizer(tap)
    }
    
    private func archive(worldMap: ARWorldMap) throws {
        
        let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
        try data.write(to: self.worldMapURL, options: [.atomic])
    }
    
    private func retrieveWorldMapData(from url: URL) -> Data? {
        do {
            return try Data(contentsOf: self.worldMapURL)
        } catch {
            print("Error retrieving world map data.")
            return nil
        }
    }
    
    private func unarchive(worldMapData data: Data) -> ARWorldMap? {
        guard let unarchievedObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data),
            let worldMap = unarchievedObject else { return nil }
        return worldMap
    }
    
    @IBAction private func saveBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
        
        do {
            try FileManager.default.removeItem(at: worldMapURL)
        } catch {
            print(error.localizedDescription)
        }
        
        
        sceneView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                print("Error getting current world map.")
                return
            }
            
            do {
                try self.archive(worldMap: worldMap)
                DispatchQueue.main.async {
                    print("World map is saved.")
                }
            } catch {
                fatalError("Error saving world map: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func onTapAction(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        if objectNode == nil,
            let hitTestResult = sceneView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane]).first {
            
            let anchor = ARAnchor(transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
    
    
}
