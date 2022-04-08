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
        
        let mesh02 = MeshResource.generateBox(size: 0.5)
        let box2 = ModelEntity(mesh: mesh02, materials: [SimpleMaterial(color: .clear, isMetallic: true)])
        box2.generateCollisionShapes(recursive: true)
        box2.name = "malicious"
    
        
        if let result: CollisionCastHit = results.first {
            result.entity.onClick(arView: arView)
            
        } else {
            if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).last {
                
                let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
                box.setParent(planeAnchor)
                box2.setParent(planeAnchor)
                arView.scene.addAnchor(planeAnchor)
                
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


extension Entity {

    func onClick(arView: ARView) {
        if (self.name == "malicious") {
            print("captured input")
            let direction: SIMD3<Float> =  self.position(relativeTo: nil) - arView.cameraTransform.translation
            let worldRayCast: [CollisionCastHit] = arView.scene.raycast(origin: arView.cameraTransform.translation, direction: direction, length: 1000, query: .all, mask: .all, relativeTo: nil)
            print(worldRayCast.count)
            if (worldRayCast.count > 1) {
                print(worldRayCast[1])
                worldRayCast[1].entity.onClick(arView: arView)
            }
        } else {
            print(self.name)
        }
    }
}
