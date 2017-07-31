//
//  Constants.swift
//  api-client
//
//  Created by Ali Lopez Galaviz on 29/07/17.
//  Copyright © 2017 Ali López Galaviz. All rights reserved.
//

import Foundation

// Callbacks
//Typealias for callbacks used in Data Service
typealias callback = (_ success:Bool) -> ()

//Base URL
let BASE_API_URL = "http://localhost:3005/api/v1"

// GET all food trucks
let GET_ALL_FT_URL = "\(BASE_API_URL)/foodtruck"
// GET all reviews for specific food truck
let GET_ALL_FT_REVIEWS = "\(BASE_API_URL)/foodtruck/reviews"
// POST add new food truck
let POST_ADD_NEW_TRUCK = "\(BASE_API_URL)/foodtruck/add"
// POST add review for a specific food truck
let POST_ADD_NEW_REVIEW = "\(BASE_API_URL)/foodtruck/reviews/add"

