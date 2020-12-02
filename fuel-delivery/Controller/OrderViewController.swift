//
//  OrderViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import Firebase

class OrderViewController: UIViewController {

    @IBOutlet var fuelSegment: UISegmentedControl!
    @IBOutlet var petrolQualitySegment: UISegmentedControl!
    @IBOutlet var dieselQualitySegment: UISegmentedControl!
    @IBOutlet var oilTypeSegment: UISegmentedControl!
    @IBOutlet var quantitySlider: UISlider!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var deliveryTimePicker: UIDatePicker!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var deliverySegment: UISegmentedControl!
    
    private var selectedFuel = FuelType.petrol.rawValue
    private var selectedPetrol = PetrolType.a95.rawValue
    private var selectedDiesel = DieselType.standart.rawValue
    private var selectedOil = EngineOilType.fiveForty.rawValue
    
    private var deliveryTime = ""
    
    var userLat: Double!
    var userLon: Double!
    var userAddress = ""
    var userLocality = ""
    var userCountry = ""
    var quantity = 0
    var totalPrice: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = userAddress
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
        switch fuelSegment.selectedSegmentIndex {
        case 0:
            selectedFuel = FuelType.petrol.rawValue
            showSegmentControl(segmentToShow: petrolQualitySegment, segments: [petrolQualitySegment, dieselQualitySegment, oilTypeSegment])
        case 1:
            selectedFuel = FuelType.diesel.rawValue
            showSegmentControl(segmentToShow: dieselQualitySegment, segments: [petrolQualitySegment, dieselQualitySegment, oilTypeSegment])
        case 2:
            selectedFuel = FuelType.engineOil.rawValue
            showSegmentControl(segmentToShow: oilTypeSegment, segments: [petrolQualitySegment, dieselQualitySegment, oilTypeSegment])
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
        switch petrolQualitySegment.selectedSegmentIndex {
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
    
    func formatDate(date: DateFormatter) -> String {
        date.dateStyle = DateFormatter.Style.short
        date.timeStyle = DateFormatter.Style.short
        let strDate = date.string(from: deliveryTimePicker.date)
        return strDate
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        let strDate = formatDate(date: dateFormatter)
        deliveryTime = strDate;
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
        Firestore.firestore().collection(ORDERS_REF).addDocument(data: [
            FUEL_TYPE: selectedFuel,
            FUEL_QUALITY: selectedType(fuel: selectedFuel),
            DATE_ORDERED: FieldValue.serverTimestamp(),
            DISPLAY_NAME: Auth.auth().currentUser?.displayName ?? "",
            USER_ID: Auth.auth().currentUser?.uid ?? "",
            LATITUDE: userLat ?? 0.0,
            LONGITUDE: userLon ?? 0.0,
            ADDRESS: userAddress,
            DELIVERY_TIME: deliveryTime,
            QUANTITY: quantity,
            TOTAL_PRICE: totalPrice,
            LOCALITY: userLocality,
            COUNTRY: userCountry,
            STATUS: ORDERED
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
