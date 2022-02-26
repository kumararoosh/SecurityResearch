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
        let box = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        box.generateCollisionShapes(recursive: true)
        box.name = "Box"
       
        if let result: CollisionCastHit = results.first {
            print(result.entity.name)
        } else {
            if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).last {
                
                let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
                box.setParent(planeAnchor)
                arView.scene.addAnchor(planeAnchor)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
