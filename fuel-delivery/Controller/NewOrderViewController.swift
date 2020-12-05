//
//  NewOrderViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import Firebase
import CoreLocation

class NewOrderViewController: UIViewController {

    @IBOutlet weak var fuelSegment: UISegmentedControl!
    @IBOutlet weak var petrolQualitySegment: UISegmentedControl!
    @IBOutlet weak var dieselQualitySegment: UISegmentedControl!
    @IBOutlet weak var oilTypeSegment: UISegmentedControl!
    @IBOutlet weak var quantitySlider: UISlider!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryTimePicker: UIDatePicker!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var deliverySegment: UISegmentedControl!
    
    private var selectedFuel = FuelType.petrol.rawValue
    private var selectedPetrol = PetrolType.a95.rawValue
    private var selectedDiesel = DieselType.standart.rawValue
    private var selectedOil = EngineOilType.fiveForty.rawValue
    
    private var deliveryTime = ""
    
    var userLocation: CLLocation!
    var userAddress = ""
    var quantity = 0
    var totalPrice: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
    }
    
    func setUi() {
        locationLabel.text = userAddress
        quantitySlider.value = 10.0
        quantity = 10
        quantityLabel.text = "10 litres"
        totalPrice = 19.7
        deliveryTime = formatDate(date: Date())
    }
    
    func showSegmentControl(segmentToShow: UISegmentedControl, segments: [UISegmentedControl]) {
        for segment in segments {
            segment.isHidden = true
            if segment == segmentToShow {
                segment.isHidden = false
            }
        }
    }
    
    @IBAction func fuelChanged(_ sender: Any) {
        let segmentsArray: [UISegmentedControl] = [petrolQualitySegment, dieselQualitySegment, oilTypeSegment]
        switch fuelSegment.selectedSegmentIndex {
        case 0:
            selectedFuel = FuelType.petrol.rawValue
            showSegmentControl(segmentToShow: petrolQualitySegment, segments: segmentsArray)
        case 1:
            selectedFuel = FuelType.diesel.rawValue
            showSegmentControl(segmentToShow: dieselQualitySegment, segments: segmentsArray)
        case 2:
            selectedFuel = FuelType.engineOil.rawValue
            showSegmentControl(segmentToShow: oilTypeSegment, segments: segmentsArray)
        default:
            selectedFuel = FuelType.petrol.rawValue
        }
    }
    
    @IBAction func petrolChanged(_ sender: Any) {
        switch petrolQualitySegment.selectedSegmentIndex {
        case 0:
            selectedPetrol = PetrolType.a95.rawValue
        case 1:
            selectedPetrol = PetrolType.hundredPlus.rawValue
        default:
            selectedPetrol = PetrolType.a95.rawValue
        }
    }
    
    @IBAction func dieselChanged(_ sender: Any) {
        switch dieselQualitySegment.selectedSegmentIndex {
        case 0:
            selectedDiesel = DieselType.standart.rawValue
        case 1:
            selectedDiesel = DieselType.superDiesel.rawValue
        default:
            selectedDiesel = DieselType.standart.rawValue
        }
    }
    
    @IBAction func oilChanged(_ sender: Any) {
        switch oilTypeSegment.selectedSegmentIndex {
        case 0:
            selectedOil = EngineOilType.fiveForty.rawValue
        case 1:
            selectedOil = EngineOilType.fiveThirty.rawValue
        case 2:
            selectedOil = EngineOilType.tenThirty.rawValue
        case 3:
            selectedOil = EngineOilType.tenForty.rawValue
        default:
            selectedOil = EngineOilType.fiveForty.rawValue
        }
    }
    
    func selectedType(fuel: String) -> String {
        switch fuelSegment.selectedSegmentIndex {
        case 0:
            return selectedPetrol
        case 1:
            return selectedDiesel
        case 2:
            return selectedOil
        default:
            return selectedPetrol
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d YYYY HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        deliveryTime = formatDate(date: deliveryTimePicker.date)
    }
    
    @IBAction func quantityChanged(_ sender: Any) {
        let step: Float = 1
        let currentValue = round((quantitySlider.value - quantitySlider.minimumValue) / step)
        quantity = Int(currentValue)
        totalPrice = currentValue * 1.97
        let totalPriceFormatted = String(format: "%.2f", totalPrice)
        quantityLabel.text = "\(Int(currentValue)) litres"
        totalPriceLabel.text = "\(quantity) litres x 1.97$ = \(totalPriceFormatted)$"
    }
    
    @IBAction func deliveryChanged(_ sender: Any) {
        switch deliverySegment.selectedSegmentIndex {
        case 0:
            deliveryTimePicker.isHidden = true
        case 1:
            deliveryTimePicker.isHidden = false
        default:
            deliveryTimePicker.isHidden = true
        }
    }
    
    @IBAction func completeOrderPressed(_ sender: Any) {
        // 4 symbols are equal to a radius of ±78km
        let hash = Geohash.encode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, length: 3)
        Firestore.firestore().collection(ORDERS_REF).addDocument(data: [
            FUEL_TYPE: selectedFuel,
            FUEL_QUALITY: selectedType(fuel: selectedFuel),
            DATE_ORDERED: formatDate(date: Date()),
            DISPLAY_NAME: Auth.auth().currentUser?.displayName ?? "",
            USER_ID: Auth.auth().currentUser?.uid ?? "",
            LATITUDE: userLocation.coordinate.latitude,
            LONGITUDE: userLocation.coordinate.longitude,
            ADDRESS: userAddress,
            DELIVERY_TIME: deliveryTime,
            QUANTITY: quantity,
            TOTAL_PRICE: totalPrice,
            STATUS: ORDERED,
            GEO_HASH: hash
        ]) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
