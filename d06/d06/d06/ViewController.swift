//
//  ViewController.swift
//  d06
//
//  Created by Anthony PUTZOLU on 6/21/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dynamicAnimator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let collision = UICollisionBehavior()
    let lazyBehavior = UIDynamicItemBehavior()
    var lastRotation = CGFloat()
    
    @IBOutlet var tapLocation: UITapGestureRecognizer!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        let shape = Shape(frame: CGRect(x: tapLocation.location(in: view).x - 50, y: tapLocation.location(in: view).y - 50, width: 100, height: 100))
        shape.backgroundColor = UIColor.white
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveShape))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchShape))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateShape))

        shape.addGestureRecognizer(rotateGesture)
        shape.addGestureRecognizer(panGesture)
        shape.addGestureRecognizer(pinchGesture)
        view.addSubview(shape)
        
        gravityBehavior.magnitude = 1
        collision.translatesReferenceBoundsIntoBoundary = true
        lazyBehavior.elasticity = 0.6

        gravityBehavior.addItem(shape)
        collision.addItem(shape)
        lazyBehavior.addItem(shape)
        
        dynamicAnimator.addBehavior(lazyBehavior)
        dynamicAnimator.addBehavior(collision)
        dynamicAnimator.addBehavior(gravityBehavior)
    }
    
    func rotateShape(gesture: UIRotationGestureRecognizer) {
        var lastRotation = CGFloat()
        self.view.bringSubview(toFront: gesture.view!)
        if(gesture.state == UIGestureRecognizerState.ended){
            lastRotation = 0.0;
        }
        let rotation = 0.0 - (lastRotation - gesture.rotation)
        let currentTrans = gesture.view?.transform
        let newTrans = currentTrans!.rotated(by: rotation)
        gesture.view?.transform = newTrans
        lastRotation = gesture.rotation
    }
    
    func pinchShape(gesture: UIPinchGestureRecognizer) {
        var cornerRadius: CGFloat = 50
        switch gesture.state {
        case .began:
            print("PinchGesture Began")
        case .changed:
            let scale = gesture.view!.layer.bounds.size.height * gesture.scale
            if scale < 300 && scale > 60 {
                gesture.view!.layer.bounds.size.height *= gesture.scale
                gesture.view!.layer.bounds.size.width *= gesture.scale
                if (gesture.view! as! Shape).random == 0 {gesture.view!.layer.cornerRadius *= gesture.scale}
                cornerRadius = gesture.view!.layer.cornerRadius
                gesture.scale = 1
            }
        case .cancelled:
            print("PinchGesture Cancelled")
        case .ended:
            gravityBehavior.removeItem(gesture.view!)
            collision.removeItem(gesture.view!)
            gravityBehavior.addItem(gesture.view!)
            collision.addItem(gesture.view!)
            if (gesture.view! as! Shape).random == 1 {
                gesture.view!.layer.cornerRadius = cornerRadius
            }
            print("PinchGesture Ended")
        case .failed:
            print("PinchGesture Failed")
        case .possible:
            print("PinchGesture Possible")
        }
    }
    
    func update(v: Shape) {
        collision.removeItem(v)
        lazyBehavior.removeItem(v)
        dynamicAnimator.updateItem(usingCurrentState: v)
        collision.addItem(v)
        lazyBehavior.addItem(v)
    }
    
    func moveShape(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            gravityBehavior.removeItem(gesture.view!)
            update(v: gesture.view! as! Shape)
        case .changed:
            let translation = gesture.translation(in: self.view)
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view)
            update(v: gesture.view! as! Shape)
        case .ended:
            gravityBehavior.addItem(gesture.view! as! Shape)
        default:
            print("")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
    }
}
