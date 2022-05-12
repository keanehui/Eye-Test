//
//  ARKitView.swift
//  Calibration
//
//  Created by Keane Hui on 20/2/2022.
//

import SwiftUI
import ARKit
import SceneKit

struct ARKitViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARKitViewController
    @Binding var distance: Int
    
    func makeUIViewController(context: Context) -> ARKitViewController {
        let ARKitVC = ARKitViewController()
        ARKitVC.sceneView.delegate = context.coordinator
        return ARKitVC
    }
    
    func updateUIViewController(_ uiViewController: ARKitViewControllerRepresentable.UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($distance)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var faceNode = SCNNode()
        var leftEye = SCNNode()
        var rightEye = SCNNode()
        @Binding var distance: Int
        
        init(_ distance: Binding<Int>) {
            self._distance = distance
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            faceNode = node
            faceNode.addChildNode(leftEye)
            faceNode.addChildNode(rightEye)
            faceNode.transform = node.transform
            trackDistance()
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if let faceAnchor = anchor as? ARFaceAnchor, !faceAnchor.isTracked {
                self.distance = 0
                return
            }
            faceNode.transform = node.transform
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            leftEye.simdTransform = faceAnchor.leftEyeTransform
            rightEye.simdTransform = faceAnchor.rightEyeTransform
            trackDistance()
        }

        func trackDistance() {
            DispatchQueue.global(qos: .userInteractive).async {
                let leftEyeDistanceFromCamera = self.leftEye.worldPosition - SCNVector3Zero
                let rightEyeDistanceFromCamera = self.rightEye.worldPosition - SCNVector3Zero
                let averageDistance = (leftEyeDistanceFromCamera.length() + rightEyeDistanceFromCamera.length()) / 2
                let averageDistanceCM = Int(round(averageDistance * 100))
                DispatchQueue.main.async {
                    withAnimation {
                        self.distance = averageDistanceCM
                    }
                }
            }
        }
    }
}

class ARKitViewController: UIViewController {
    var sceneView: ARSCNView {
        self.view as! ARSCNView
    }

    override func loadView() {
        super.loadView()
        self.view = ARSCNView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: Utility functions

extension SCNVector3{
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }

    static func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
    }
}
