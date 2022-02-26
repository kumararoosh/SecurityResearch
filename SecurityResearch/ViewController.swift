//
//  ViewController.swift
//  SecurityResearch
//
//  Created by stlp on 2/24/22.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = arView.center
        let results: [CollisionCastHit] = arView.hitTest(touch)
        
        let mesh01 = MeshResource.generateBox(size: 0.3)
        let redBox = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        redBox.generateCollisionShapes(recursive: true)
        redBox.name = "Red Cube"
                
        let yellowBox = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
        yellowBox.generateCollisionShapes(recursive: true)
        yellowBox.name = "Yellow Cube"
       
        if let result: CollisionCastHit = results.first {
            print(result.entity.name)
        } else {
            if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).last {
                
                let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
                redBox.setParent(planeAnchor)
                yellowBox.setParent(planeAnchor)
                arView.scene.addAnchor(planeAnchor)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
