//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Fatih Canbekli on 25.03.2019.
//  Copyright © 2019 Fatih Canbekli. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration();
    
    override func viewDidLoad() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints];
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration);
        self.sceneView.delegate = self;
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func CreateLava(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let lavaNode = SCNNode(geometry: SCNPlane(width: 1, height: 1))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "lava.png")
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        lavaNode.eulerAngles = SCNVector3(90.degreesToRadians, 0,0)
        
        return lavaNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let lavaNode = CreateLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
        print("Flat surface detected, new ARPlaneAnchor added")
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let lavaNode = CreateLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
        print("updating anchor")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}

