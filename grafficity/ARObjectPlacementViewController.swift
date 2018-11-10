import Foundation
import UIKit
import ARKit
import SceneKit

enum PlacementStep {
    case start
    case normal
    case editing
}

class ARObjectPlacementViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var detectedPlanes: [String: SCNNode] = [:]
    var sourceImage: UIImage?
    var imageNode: SCNNode?
    var placementOrientation: ARPlaneAnchor.Alignment = .horizontal
    var currentState = PlacementStep.start
    var trackedNode: SCNNode?
    var localCoordinates: SCNVector3?
    
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.statusViewController.cancelAllScheduledMessages()
            self.configureSession()
            self.statusViewController.scheduleMessage("НАВЕДИТЕСЬ НА ПОВЕРХНОСТЬ ДЛЯ РАСПОЛОЖЕНИЯ РИСУНКА", inSeconds: 7.5, messageType: .planeEstimation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            self?.configureSession()
            self?.addTapGesture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async { [weak self] in
            self?.sceneView.session.pause()
        }
    }
}

extension ARObjectPlacementViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.orange
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "Optional"
        planeNode.opacity = 0
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
        
        detectedPlanes[planeAnchor.identifier.uuidString] = planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = detectedPlanes[planeAnchor.identifier.uuidString],
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        statusViewController.showTrackingQualityInfo(for: camera.trackingState, autoHide: true)
        
        switch camera.trackingState {
        case .notAvailable, .limited:
            statusViewController.escalateFeedback(for: camera.trackingState, inSeconds: 3.0)
        case .normal:
            statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "Сбой сессии дополненной реальности", message: errorMessage)
        }
    }
}

extension ARObjectPlacementViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        
        if gestureRecognizer is UIPinchGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer {
            return true
        }
        
        return false
    }
}

extension ARObjectPlacementViewController {
    
    private func configureSession() {
        
        imageNode?.removeFromParentNode()
        imageNode = nil
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.scene.rootNode.name = "ROOT NODE"
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func addTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:)))
        tap.delegate = self
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinchAction(_:)))
        pinch.delegate = self
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(onRotateAction(_:)))
        rotate.delegate = self
        
        let move = UIPanGestureRecognizer(target: self, action: #selector(onPanAction(_:)))
        move.delegate = self
        
        sceneView.addGestureRecognizer(tap)
        sceneView.addGestureRecognizer(pinch)
        sceneView.addGestureRecognizer(rotate)
        sceneView.addGestureRecognizer(move)
    }
    
    private func displayErrorMessage(title: String, message: String) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Перезапустить сессию", style: .default) { [weak self] _ in
            alertController.dismiss(animated: true, completion: nil)
            self?.configureSession()
            self?.statusViewController.scheduleMessage("НАВЕДИТЕСЬ НА ПОВЕРХНОСТЬ ДЛЯ РАСПОЛОЖЕНИЯ РИСУНКА", inSeconds: 7.5, messageType: .planeEstimation)
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func onPanAction(_ sender: UIPanGestureRecognizer) {
        guard imageNode != nil else { return }
        
        switch sender.state {
        case .began:
            
            trackedNode = imageNode
            
        case .changed:
            
            guard let object = trackedNode,
                let result = sceneView.hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingExtent]).first,
                let anchor = result.anchor as? ARPlaneAnchor, let planeNode = detectedPlanes[anchor.identifier.uuidString] else { return }
            let resultTransform = result.worldTransform
            
            if placementOrientation != anchor.alignment {
                
                object.eulerAngles.x = -.pi / 2
                object.worldOrientation = planeNode.worldOrientation
                
                if anchor.alignment == .horizontal {
                    
                    let cameraDirection = sceneView.session.currentFrame?.camera.eulerAngles.y
                    object.eulerAngles.y = cameraDirection ?? 0
                }
            }
            

            object.worldPosition = SCNVector3(resultTransform.translation.x, resultTransform.translation.y, resultTransform.translation.z)
            
        default:
            trackedNode = nil
            break
        }
        
        
    }
    
    @objc private func onPinchAction(_ sender: UIPinchGestureRecognizer) {
        guard let imageNode = imageNode else { return }
        
        let action = SCNAction.scale(by: sender.scale, duration: 0.1)
        imageNode.runAction(action)
        sender.scale = 1
    }
    
    @objc private func onRotateAction(_ sender: UIRotationGestureRecognizer) {
        guard let imageNode = imageNode else { return }
        
        if placementOrientation == .horizontal {
            let action = SCNAction.rotateBy(x: 0, y: -sender.rotation, z: 0, duration: 0.1)
            imageNode.runAction(action)
        } else {
            let action = SCNAction.rotate(by: sender.rotation, around: imageNode.position, duration: 0.1)
            imageNode.runAction(action)
        }
        
        sender.rotation = 0
    }
    
    @objc private func onTapAction(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        if currentState == .start {
            
            if imageNode == nil, let hitTestResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent).first,
                let anchor = hitTestResult.anchor as? ARPlaneAnchor, let planeNode = detectedPlanes[anchor.identifier.uuidString],
                let image = sourceImage {
                
                placementOrientation = anchor.alignment
                
                let imagePlane = SCNPlane(width: 0.4, height: 0.4 * image.size.height / image.size.width)
                imagePlane.firstMaterial?.isDoubleSided = true
                imagePlane.materials.first?.diffuse.contents = sourceImage
                
                let imageNode = SCNNode(geometry: imagePlane)
                
                imageNode.name = "Main"
                
                let translation = hitTestResult.worldTransform.translation
                
                
                imageNode.position = SCNVector3(translation.x, translation.y, translation.z)
                imageNode.eulerAngles.x = -.pi / 2
                imageNode.worldOrientation = planeNode.worldOrientation
                
                if placementOrientation == .horizontal {
                    
                    let cameraDirection = sceneView.session.currentFrame?.camera.eulerAngles.y
                    imageNode.eulerAngles.y = cameraDirection ?? 0
                }
                
                sceneView.scene.rootNode.addChildNode(imageNode)
                
                self.imageNode = imageNode
            } else {
                
                imageNode?.removeFromParentNode()
                imageNode = nil
            }
        }
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
