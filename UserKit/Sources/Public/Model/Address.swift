//
//  Address.swift
//  UserKit
//
//  Created by Alessio Borraccino on 19.06.19.
//  Copyright © 2019 Alessio Borraccino. All rights reserved.
//

import CoreLocation.CLLocation

//Represent the address of the users registered in UserKit.
public struct Address {
    public let street: String?
    public let suite: String?
    public let city: String?
    public let zipCode: String?
    public let coordinates: CLLocationCoordinate2D?
}

extension Address: Codable {
    enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipCode = "zipcode"
        case coordinates = "geo"
    }
    
    enum CoordinatesCodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Address.CodingKeys.self)
        self.street = try container.decodeIfPresent(String.self, forKey: .street)
        self.suite = try container.decodeIfPresent(String.self, forKey: .suite)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
        let coordinateContainer = try container.nestedContainer(keyedBy: CoordinatesCodingKeys.self, forKey: .coordinates)
        let latitudeString = try coordinateContainer.decode(String.self, forKey: .latitude)
        let longitudeString = try coordinateContainer.decode(String.self, forKey: .longitude)
        if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinates = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Address.CodingKeys.self)
        try container.encodeIfPresent(street, forKey: .street)
        try container.encodeIfPresent(suite, forKey: .suite)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(zipCode, forKey: .zipCode)
        if let latitude = coordinates?.latitude, let longitude = coordinates?.longitude {
            let coordinateEncoder = container.superEncoder(forKey: .coordinates)
            var coordinateContainer = coordinateEncoder.container(keyedBy: CoordinatesCodingKeys.self)
            let latitudeString = String(describing: latitude)
            let longitudeString = String(describing: longitude)
            try coordinateContainer.encodeIfPresent(latitudeString, forKey: .latitude)
            try coordinateContainer.encodeIfPresent(longitudeString, forKey: .longitude)
        }
    }
}

