//
//  AuthVC.swift
//  Trade
//
//  Created by Aryeh Greenberg on 5/13/18.
//  Copyright © 2018 AGApps. All rights reserved.
//

import UIKit
import MapKit

class AuthVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager = CLLocationManager()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       mapView.delegate = self
    
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.322702074640816, longitude: -121.88178599777457), span: MKCoordinateSpan(latitudeDelta: 0.40919230148491437, longitudeDelta: 0.53268476307675883))
        mapView.setRegion(region, animated: false)
        mapView.isUserInteractionEnabled = false
        
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: 37.328859, longitude: -121.889135), radius: 10000)
        mapView.add(circle)
    
        
        // Do any additional setup after loading the view.
        let title = "Welcome to trade for WWDC. You must be located within this region to use the app."
        label.text = title
        locationManager.delegate = self
        mapView.showsUserLocation = true
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            let alert = UIAlertController(title: "Location denied", message: "Please go to settings and allow location access to use this app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.location = location
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
                self.checkLocation()
            }
        }
    }
    func checkLocation() {
        if location != nil {
            if location!.distance(from: CLLocation(latitude: 37.328859, longitude: -121.889135)) < 10000.0 {
                print("good")
                UserDefaults.standard.set(true, forKey: "authorized")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.green
            circle.fillColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed with error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
            
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            let alert = UIAlertController(title: "Location denied", message: "Please go to settings and allow location access to use this app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
