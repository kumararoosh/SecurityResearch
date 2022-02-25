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
        
        let mesh02 = MeshResource.generateBox(size: 0.3)
        let box1 = ModelEntity(mesh: mesh02, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        box1.generateCollisionShapes(recursive: true)
        box1.name = "Visible Cube"
        
        let box2 = ModelEntity(mesh: mesh02, materials: [SimpleMaterial(color: .yellow, isMetallic: false)])
       
        if let result: CollisionCastHit = results.first {
            
            print(result.entity.name)
        } else {
            if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .existingPlaneInfinite, alignment: .horizontal).last {
                
                let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
                box1.setParent(planeAnchor)
                box2.setParent(planeAnchor)
                arView.scene.addAnchor(planeAnchor)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView.renderOptions.insert(.disableAREnvironmentLighting)

        // Model for collision
        let mesh02 = MeshResource.generateBox(size: 0.3)
        let box = ModelEntity(mesh: mesh02, materials: [SimpleMaterial()])
        box.generateCollisionShapes(recursive: true)
        box.name = "Visible Cube"
        let planeAnchor = AnchorEntity(.plane(.any,
                              classification: .any,
                               minimumBounds: [0.2, 0.2]))
        box.setParent(planeAnchor)
        
        let mesh03 = MeshResource.generateBox(size: 0.5)
        let invisibleMaterial = SimpleMaterial(color: SimpleMaterial.Color(hue: 1, saturation: 1, brightness: 1, alpha: 0), roughness: MaterialScalarParameter.float(0.2), isMetallic: false)
        
        let invisibleBox = ModelEntity(mesh: mesh03, materials: [invisibleMaterial])
        invisibleBox.generateCollisionShapes(recursive: true)
        invisibleBox.name = "Invisible Box"
        invisibleBox.setParent(planeAnchor)
        arView.scene.addAnchor(planeAnchor)
    }
}

