//
//  ShareVC.swift
//  OnThaMap
//
//  Created by Ghaida Almahmoud on 15/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ShareVC: UIViewController {
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
    
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate!
        mapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegion(center: locationCoordinate!, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    @IBAction func submit(_ sender: Any){
        UdacityAPI.parse.postStudentLocation(lihk: linkField.text ?? "", locationCoordinate: locationCoordinate, locationName: locationName) {
            (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(self.locationName, forKey: "studentLocation")
            DispatchQueue.main.async {
                self.parent!.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension ShareVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseId = "pinId"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
