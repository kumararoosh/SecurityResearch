//
//  ViewController.swift
//  SecurityResearch
//
//  Created by stlp on 2/24/22.
//

import UIKit
import ARKit
import RealityKit
import Toast

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet var componentAButton: UIButton!
    @IBOutlet var componentBButton: UIButton!
    
    
    var anchorPlaced: Bool = false
    var planeAnchor: AnchorEntity = AnchorEntity.init()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = arView.center
        let results: [CollisionCastHit] = arView.hitTest(touch)
        
        
        if let result: CollisionCastHit = results.first {
            result.entity.onClick(view: self.view)
        } else {
            if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).last {
                if (!anchorPlaced) {
                    let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
                    anchorPlaced = true
                    self.planeAnchor = planeAnchor
//                    Component_A(planeanchor: planeAnchor)
                    self.view.makeToast("Plane Anchor Placed")
                    arView.scene.addAnchor(planeAnchor)
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func Component_A(planeanchor: AnchorEntity) {
        let mesh01 = MeshResource.generateBox(size: 0.3)
        let cube1 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        cube1.generateCollisionShapes(recursive: true)
        cube1.name = "Cube 1"
        
        
        let cube2 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        cube2.generateCollisionShapes(recursive: true)
        cube2.name = "Cube 2"
        cube2.transform.translation = [-0.6, 0, 0]
        
        cube1.setParent(planeanchor)
        cube2.setParent(planeanchor)
        
        self.view.makeToast("Component A Launched")
    }
    
    func Component_B(planeanchor: AnchorEntity) {
        let mesh01 = MeshResource.generateBox(size: 0.3)
        let cube3 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        cube3.generateCollisionShapes(recursive: true)
        cube3.name = "Cube 3"
        
        
        let cube4 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        cube4.generateCollisionShapes(recursive: true)
        cube4.name = "Cube 4"
        cube4.transform.translation = [0.6, 0, 0]
        
        cube3.setParent(planeanchor)
        cube4.setParent(planeanchor)
        self.view.makeToast("Component B Launched")
    }
    
    @IBAction func onComponentAClick(_ sender: Any) {
        Component_A(planeanchor: self.planeAnchor)
        componentAButton.isEnabled = false
    }
    @IBAction func onComponentBClick(_ sender: Any) {
        Component_B(planeanchor: self.planeAnchor)
        componentBButton.isEnabled = false
    }
}

extension Entity {
    func onClick(view: UIView) {
        view.makeToast(self.name + " clicked")
    }
}
