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
    @IBOutlet var placeAnchorButton: UIButton!
    
    @IBOutlet var Cube1Count: UILabel!
    @IBOutlet var Cube2Count: UILabel!
    @IBOutlet var Cube3Count: UILabel!
    @IBOutlet var Cube4Count: UILabel!
    
    
    var labels: [UILabel] = [];
    
    var counts: [Int] = [0,0,0,0]

    var anchorPlaced: Bool = false
    var planeAnchor: AnchorEntity = AnchorEntity.init()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = arView.center
        let results: [CollisionCastHit] = arView.hitTest(touch)
        
        
        if let result: CollisionCastHit = results.first {
            
            var index: Int = Int(result.entity.name)!
            index -= 1
            counts[index] += 1
            let CurrLabel: UILabel = labels[index]
            
            CurrLabel.text = "Cube " + result.entity.name + ", Clicked " + String(counts[index])
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labels = [self.Cube1Count, self.Cube2Count, self.Cube3Count, self.Cube4Count]
        
    }
    
    func Component_A(planeanchor: AnchorEntity) {
        let mesh01 = MeshResource.generateBox(size: 0.3)
        let cube1 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        cube1.generateCollisionShapes(recursive: true)
        cube1.name = "1"
        
        
        let cube2 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .red, isMetallic: false)])
        cube2.generateCollisionShapes(recursive: true)
        cube2.name = "2"
        cube2.transform.translation = [-0.6, 0, 0]
        
        cube1.setParent(planeanchor)
        cube2.setParent(planeanchor)
        
        self.view.makeToast("Component A Launched")
    }
    
    func Component_B(planeanchor: AnchorEntity) {
        let mesh01 = MeshResource.generateBox(size: 0.3)
        let cube3 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        cube3.generateCollisionShapes(recursive: true)
        cube3.name = "3"
        
        
        let cube4 = ModelEntity(mesh: mesh01, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        cube4.generateCollisionShapes(recursive: true)
        cube4.name = "4"
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
    
    @IBAction func onPlaceAnchorClick(_ sender: Any) {
        if let raycastResult: ARRaycastResult = arView.raycast(from: arView.center, allowing: .estimatedPlane, alignment: .horizontal).last {
            
            let planeAnchor: AnchorEntity = AnchorEntity(raycastResult: raycastResult)
            anchorPlaced = true
            self.planeAnchor = planeAnchor
            self.view.makeToast("Plane Anchor Placed")
            arView.scene.addAnchor(planeAnchor)
            placeAnchorButton.isEnabled = false
        }
    }
}

extension Entity {
    func onClick(view: UIView, counts: inout [Int]) {
        view.makeToast(self.name + " clicked")
        var index: Int = Int(self.name)!
        index -= 1
        counts[index] += 1
        
    }
}
