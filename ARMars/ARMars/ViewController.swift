//
//  ViewController.swift
//  ARMars
//
//  Created by zrb_dxs on 2018/1/13.
//  Copyright © 2018年 zrb_dxs. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var planeNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        planeNode = scene.rootNode.childNodes[0]
        planeNode?.scale = SCNVector3Make(0.5, 0.5, 0.5)
        planeNode?.position = SCNVector3Make(0, -15, -15)
        for node in planeNode!.childNodes {
            node.scale = SCNVector3Make(0.5, 0.5, 0.5)
            node.position = SCNVector3Make(0, -15, -15)
        }
//        sceneView.scene.rootNode .addChildNode(planeNode!)
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // light estimate
        configuration.isLightEstimationEnabled = true
    

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor {

            // 创建3D物体模型
            let planeBox = SCNBox.init(width: CGFloat(planeAnchor.extent.x * 0.3), height: 0, length: CGFloat(planeAnchor.extent.x * 0.3), chamferRadius: 0)
            
            // 使用material渲染3D模型
            planeBox.firstMaterial?.diffuse.contents = UIColor.red

            // 创建一个基于3D物体模型的节点
            let nodeNode = SCNNode.init(geometry: planeBox)
            
            // 设置节点的位置为捕捉的平地的锚点中心位置
            nodeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            node .addChildNode(nodeNode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                let scene = SCNScene.init(named: "art.scnassets/ship.scn")
                
                let otherNode = scene?.rootNode.childNodes[0]
                
                otherNode?.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
                
                // 将花瓶添加到当前屏幕
                node .addChildNode(otherNode!)
            })
        }
    }
    
    // MARK: - ARSessionDelegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    print("Camera moving")

        if self.planeNode != nil {
            self.planeNode?.position = SCNVector3Make(frame.camera.transform.columns.3.x, frame.camera.transform.columns.3.y, frame.camera.transform.columns.3.z)
        }
    }
    
}
