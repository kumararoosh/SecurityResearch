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
    var sphere: ModelEntity?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = arView.center
        let results: [CollisionCastHit] = arView.hitTest(touch)
        
        let mesh01 = MeshResource.generateBox(size: 0.3)
        let box = ModelEntity(mesh: mesh01, materials: [SimpleMaterial()])
        box.generateCollisionShapes(recursive: true)
        box.name = "Visible Cube"
        
        let mesh02 = MeshResource.generateBox(size: 0.5)
        let invisibleMaterial = SimpleMaterial(color: SimpleMaterial.Color(hue: 1, saturation: 1, brightness: 1, alpha: 0), roughness: .float(0.2), isMetallic: false)
        
        let invisibleBox = ModelEntity(mesh: mesh02, materials: [invisibleMaterial])
        invisibleBox.generateCollisionShapes(recursive: true)
        invisibleBox.name = "Invisible Box"
       
        if let result: CollisionCastHit = results.first {
            print(result.entity.name)
        } else {
            if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).last {
                
                let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
                box.setParent(planeAnchor)
                invisibleBox.setParent(planeAnchor)
                arView.scene.addAnchor(planeAnchor)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.renderOptions.insert(.disableAREnvironmentLighting)

    }
}

