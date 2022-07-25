//
//  MapVC.swift
//  MilageTrackerDemo
//
//  Created by eslam mohamed on 16/07/2022.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAnalytics

class MapVC: UIViewController, StoryboardLoad {
    
    var showRoute:Bool!
    var cellVmData:TripCellViewModel?
    @IBOutlet weak var endTripButton: UIButton!
    weak var coordinator: Coordinator?
    @IBOutlet weak var tripMapView: MKMapView!
    var locationManager: CLLocationManager?
    
    private var timer: Timer!
    
    var allLocations: [CLLocation] = []
    var count: Int!
    var viewModel: IMapViewModel?
    
    var startPoint:tripPoint = tripPoint(long: 0.0, latitu: 0.0)
    var endPoint:tripPoint = tripPoint(long: 0.0, latitu: 0.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureTripMap()
        if !showRoute{
            configureLocationManager()
            configureCountForTimer()
            self.endTripButton.isHidden = false
        }else{
            showRouteOnMap()
            self.endTripButton.isHidden = true
        }

        
    }
    
    private func configureViewModel(){
        viewModel = MapViewModel()
    }
    
    private func configureTripMap(){
        tripMapView.showsUserLocation = true
        tripMapView.delegate = self
        tripMapView.mapType = .hybrid
        tripMapView.userTrackingMode = .follow
    }
    
    private func configureLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.activityType = .fitness
        locationManager?.distanceFilter = 10
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.showsBackgroundLocationIndicator = true
        locationManager?.pausesLocationUpdatesAutomatically = true
        locationManager?.startUpdatingLocation()
        
    }
    
    private func configureCountForTimer(){
        count = viewModel?.getTimerCount()
    }
    
    @IBAction func endTripButtonTap(_ sender: Any) {
        print("Timer has finished")
        timer.invalidate()
        viewModel?.saveTrip(startPoint: startPoint, endPoint: endPoint)
        locationManager?.stopUpdatingLocation()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func timerFired(){
        if(count > 0){
            print("count is \n")
            print(count ?? 0)
            count -= 1
        }else{
            print("Timer has finished")
            timer.invalidate()
            viewModel?.saveTrip(startPoint: startPoint, endPoint: endPoint)
            locationManager?.stopUpdatingLocation()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showRouteOnMap() {
        guard let cellVmData = cellVmData else {return}
        let sourceLocation = CLLocationCoordinate2D(latitude:cellVmData.tripStartPoint.latitude , longitude: cellVmData.tripStartPoint.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude:cellVmData.tripEndPoint.latitude , longitude: cellVmData.tripEndPoint.longitude)
        
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.tripMapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.tripMapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }    }
    
    
}

extension MapVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.tripMapView.setRegion(region, animated: true)
//
            let previousCoordinate = allLocations.last?.coordinate
            allLocations.append(location)
            //
            if previousCoordinate == nil { return }
            //
            var area = [previousCoordinate!, location.coordinate]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            self.tripMapView.addOverlay(polyline)
            self.count = viewModel?.getTimerCount()
            configurePointsToSave(locations: allLocations)
            

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("location stopped")

        
        endTripButton.setTitle("Trip paused", for: .normal)
        timer.fire()
        

        self.navigationController?.popViewController(animated: true)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        allLocations = []
        endTripButton.setTitle("Trip resumed", for: .normal)
        if count == 0 {
            print("should start new trip")
            endTripButton.setTitle("Trip should start new trip", for: .normal)
        }else{
            endTripButton.setTitle("Trip should reassign count number", for: .normal)
            print("should reassign count number")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            print("notDetermined")
            break
        case .authorizedWhenInUse:
            Analytics.logEvent("start_trip", parameters: nil)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            locationManager?.startUpdatingLocation()
            print("authorizedWhenInUse")

            break
        case .authorizedAlways:
            Analytics.logEvent("start_trip", parameters: nil)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            locationManager?.startUpdatingLocation()
            print("authorizedAlways")

            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            print("restricted")

            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            print("denied")

            break
        default:
            break
        }
    }
    
}


extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapsView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 4
        return polylineRenderer
        
    }
}


extension MapVC{
    private func configurePointsToSave(locations: [CLLocation]){
        self.startPoint.long = locations[0].coordinate.longitude
        self.startPoint.latitu = locations[0].coordinate.latitude
        self.endPoint.long = locations.last?.coordinate.longitude ?? 0
        self.endPoint.latitu = locations.last?.coordinate.latitude ?? 0
    }
}
	
