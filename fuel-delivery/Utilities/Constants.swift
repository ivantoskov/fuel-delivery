//
//  Constants.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import Foundation

/* Database references */
let USERS_REF = "users"
let FIRST_NAME = "firstName"
let LAST_NAME = "lastName"
let EMAIL = "email"
let DATE_CREATED = "dateCreated"
let USER_ID = "userID"
let DATE_ORDERED = "dateOrdered"
let FUEL_TYPE = "fuelType"
let ORDERS_REF = "orders"
let LATITUDE = "latitude"
let LONGITUDE = "longitude"
let ADDRESS = "address"
let DISPLAY_NAME = "name"
let FUEL_QUALITY = "fuelQuality"
let DELIVERY_TIME = "deliveryTime"
let QUANTITY = "quantity"
let TOTAL_PRICE = "totalPrice"
let STATUS = "status"
let LOCALITY = "locality"
let COUNTRY = "country"
let ACCEPTED_BY_USER = "acceptedByUser"
let GEO_HASH = "geoHash"
let OVERALL_RATING = "overallRating"
let TOTAL_RATING = "totalRating"
let NUMBER_OF_RATES = "numberOfRates"


/* Segue identifiers */
let TO_NEW_ORDER = "toNewOrder"
let TO_NEARBY_ORDERS = "toNearbyOrders"
let TO_PUBLISHED_ORDER = "toPublishedOrder"
let TO_MY_ORDERS = "toMyOrders"
let TO_PROFILE = "toProfile"
let TO_TAKEN_ORDERS = "toTakenOrders"
let TO_MY_ORDER_DETAILS = "toMyOrderDetails"
let TO_TAKEN_ORDER = "toTakenOrder"
let TO_SCAN_QR = "toScanQR"
let TO_DIRECTONS = "toDirections"

/* Storyboard identifiers */
let MAIN = "Main"
let SIGN_IN_VC = "signInVC"
let NEARBY_ORDERS_VC = "nearbyOrdersVC"
let PUBLISHED_ORDER_VC = "publishedOrderVC"

/* TableView Cells */
let ORDER_CELL = "orderCell"

/* Order status */
let ORDERED = "Ordered"
let ACCEPTED = "Accepted"
let DELIVERED = "Delivered"
