//
//  LocationNode.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation
import SpriteKit

///A location node can be added to a scene using a coordinate.
///Its scale and position should not be adjusted, as these are used for scene layout purposes
///To adjust the scale and position of items within a node, you can add them to a child node and adjust them there
open class LocationNode: SCNNode {
    /// Location can be changed and confirmed later by SceneLocationView.
    public var location: CLLocation!

    /// A general purpose tag that can be used to find nodes already added to a SceneLocationView
    public var tag: String?

    ///Whether the location of the node has been confirmed.
    ///This is automatically set to true when you create a node using a location.
    ///Otherwise, this is false, and becomes true once the user moves 100m away from the node,
    ///except when the locationEstimateMethod is set to use Core Location data only,
    ///as then it becomes true immediately.
    public var locationConfirmed = false

    ///Whether a node's position should be adjusted on an ongoing basis
    ///based on its' given location.
    ///This only occurs when a node's location is within 100m of the user.
    ///Adjustment doesn't apply to nodes without a confirmed location.
    ///When this is set to false, the result is a smoother appearance.
    ///When this is set to true, this means a node may appear to jump around
    ///as the user's location estimates update,
    ///but the position is generally more accurate.
    ///Defaults to true.
    public var continuallyAdjustNodePositionWhenWithinRange = true

    ///Whether a node's position and scale should be updated automatically on a continual basis.
    ///This should only be set to false if you plan to manually update position and scale
    ///at regular intervals. You can do this with `SceneLocationView`'s `updatePositionOfLocationNode`.
    public var continuallyUpdatePositionAndScale = true

    public init(location: CLLocation?) {
        self.location = location
        self.locationConfirmed = location != nil
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func hideAlternativeNode() {

    }

    public func showAlternativeNode() {

    }

    public func updateLabel(text: String) {

    }

    public func setFontSize(scale: Float) {

    }
}

open class LocationAnnotationNode: LocationNode {
    ///An image to use for the annotation
    ///When viewed from a distance, the annotation will be seen at the size provided
    ///e.g. if the size is 100x100px, the annotation will take up approx 100x100 points on screen.
    public let image: UIImage

    ///Subnodes and adjustments should be applied to this subnode
    ///Required to allow scaling at the same time as having a 2D 'billboard' appearance
    public let annotationNode: SCNNode

    public let labelNode: SKLabelNode

    public let textNode: SCNNode
    public let textPlane: SCNPlane

    ///Whether the node should be scaled relative to its distance from the camera
    ///Default value (false) scales it to visually appear at the same size no matter the distance
    ///Setting to true causes annotation nodes to scale like a regular node
    ///Scaling relative to distance may be useful with local navigation-based uses
    ///For landmarks in the distance, the default is correct
    public var scaleRelativeToDistance = false


    public init(location: CLLocation?, image: UIImage) {
        self.image = image

        let skScene = SKScene(size: CGSize(width: 200, height: 60))
        skScene.backgroundColor = UIColor.clear

        labelNode = SKLabelNode(text: "Hello World")
        labelNode.fontSize = 60
        labelNode.fontName = "San Francisco"
        labelNode.color = .white
        labelNode.fontColor = .white
        labelNode.position = CGPoint(x: 100, y: 0)
        skScene.addChild(labelNode)

        textPlane = SCNPlane(width: (image.size.height / 100) * 2, height: image.size.height / 100)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        textPlane.materials = [material]
        textNode = SCNNode(geometry: textPlane)
//        textNode.pivot = SCNMatrix4MakeTranslation(0, 0.5, 0)

//        SCNVector4(x: 0, y: 0, z: 1, w: Float.pi)

        textNode.transform = SCNMatrix4Mult(SCNMatrix4MakeRotation(Float.pi, 0, 0, 1), SCNMatrix4MakeRotation(Float.pi, 0, 1, 0))



        let plane = SCNPlane(width: image.size.width / 100, height: image.size.height / 100)
        plane.firstMaterial!.diffuse.contents = image
        plane.firstMaterial!.lightingModel = .constant

        annotationNode = SCNNode()
        annotationNode.geometry = plane
        annotationNode.pivot = SCNMatrix4MakeTranslation(0, 0.5, 0)


        super.init(location: location)

        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]

        addChildNode(annotationNode)
        addChildNode(textNode)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hideAlternativeNode() {
        super.hideAlternativeNode()

        annotationNode.isHidden = false
        textNode.isHidden = false
    }

    public override func showAlternativeNode() {
        super.showAlternativeNode()

        annotationNode.isHidden = true
        textNode.isHidden = true
    }

    public override func updateLabel(text: String) {
        labelNode.text = text
    }

    public override func setFontSize(scale: Float) {
        let newScale: CGFloat = CGFloat(scale * 0.4 + 0.6)
        textPlane.width = (image.size.height / 100) * 2 * newScale
        textPlane.height = (image.size.height / 100) * newScale
        textNode.position = SCNVector3(x: 0, y: -(scale * 1.2 * Float(image.size.height / 100)), z: 0)
    }
}
