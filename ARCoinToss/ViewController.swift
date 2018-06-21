//
//  ViewController.swift
//  ARCoinToss
//
//  Created by CELLFiY on 6/21/18.
//  Copyright © 2018 Matt Schweppe. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    

    @IBOutlet var sceneView: ARSCNView!
    var trackerNode: SCNNode!
    var trackingPostion = SCNVector3Make(0.0, 0.0, 0.0)
    var started = false
    var foundSurface = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !started else { return }
        guard let hitTest = sceneView.hitTest(CGPoint(x: view.frame.midX, y: view.frame.midY), types: [.existingPlane, .featurePoint, .estimatedHorizontalPlane]).first else { return }
        let trans = SCNMatrix4(hitTest.worldTransform)
        trackingPostion = SCNVector3Make(trans.m41, trans.m42, trans.m43)
        
        if !foundSurface {
            let trackerPlane = SCNPlane(width: 0.2, height: 0.2)
            trackerPlane.firstMaterial?.diffuse.contents = trackerPlane.firstMaterial?.isDoubleSided = true
            
            trackerNode = SCNNode(geometry: trackerPlane)
            trackerNode.eulerAngles.x = -.pi * 0.5
            sceneView.scene.rootNode.addChildNode(trackerNode)
            foundSurface = true
            
        }
        trackerNode.position = trackingPostion
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
