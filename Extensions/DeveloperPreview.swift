//
//  DeveloperPreview.swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 01/03/2024.
//

import Foundation

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    //Game drive listing
    var listings: [Listing] = [
    Listing(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            ownerName: "John",
            ownerImageUrl: "Gamedrive-Instructor",
            numberofGuests: 10,
            pricePerActivity: 2000,
            park: "Nairobi National Park",
            city: "Nairobi",
            title: "Park Dash",
            description: "Feel your pulse quicken as you spot iconic wildlife like lions, elephants, and zebras in their natural habitat. Experience the grandeur of the African wilderness from the comfort of an open-air vehicle.",
            rating: 3,
            imageURLs: ["GameDrive1", "GameDrive2", "GameDrive3", "GameDrive4"],
            features : [.bigFiveSighting, .offRoadExperience],
            amenities: [.binoculars, .chargingPorts, .coldDrinks]
        ),
        
        //Hiking Listing
      Listing(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            ownerName: "Susan",
            ownerImageUrl: "Hiking-Instructor",
            numberofGuests: 10,
            pricePerActivity: 500,
            park: "Amboseli National Park",
            city: "Amboseli",
            title: "Trailblazer's Dawn",
            description: "Discover breathtaking landscapes and hidden gems on a captivating hike. Immerse yourself in the fresh air and stunning scenery, breathing in the beauty and diversity of nature's treasures.",
            rating: 4,
            imageURLs: ["Hiking1", "Hiking2", "Hiking3", "Hiking4"],
            features : [.uniqueEncounters, .intermediateDifficulty],
            amenities: [.coldDrinks, .guidedHike, .binoculars]
        ),
        
        //Sea Diving
      Listing(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            ownerName: "Andreas",
            ownerImageUrl: "Snorkelling-Instructor",
            numberofGuests: 10,
            pricePerActivity: 4000,
            park: "Watamu Marine National Park",
            city: "Watamu",
            title: "Coral Kaleidoscope",
            description: "Discover a hidden realm teeming with vibrant coral reefs and an astonishing array of marine life. Witness the breathtaking beauty and mysteries of the underwater world in this once-in-a-lifetime experience.",
            rating: 5,
            imageURLs: ["Snorkelling1", "Snorkelling2", "Snorkelling3", "Snorkelling4"],
            features : [.scenicLocation, .trailHighlights, .intermediateDifficulty],
            amenities: [.photographyFavorite, .guideBooks, .snacks]
        ),
        
        //Hot Air Balloon Listing
        Listing(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            ownerName: "James",
            ownerImageUrl: "Hot-Air-Balloon-Pilot",
            numberofGuests: 10,
            pricePerActivity: 15000,
            park: "Maasai Mara National Reserve",
            city: "Narok",
            title: "Sunsrise Soar",
            description: "Experience the magic of the Maasai Mara from a breathtaking perspective. As the sun rises, gently drift above the savanna, witnessing the vast landscapes and diverse wildlife awaken to a new day.",
            rating: 5,
            imageURLs: ["HotAirBalloon1", "HotAirBalloon2", "HotAirBalloon3", "HotAirBalloon4"],
            features : [.uniqueEncounters, .sunriseFlight, .scenicLocation],
            amenities: [.lightBreakfast, .champagneToast, .photographyFavorite]
        ),
        
        //Bush Breakfast Listing
        Listing(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            ownerName: "Naserian",
            ownerImageUrl: "bushbreakhost",
            numberofGuests: 10,
            pricePerActivity: 3000,
            park: "Maasai Mara National Reserve",
            city: "Narok",
            title: "Daybreak Delight",
            description: "As dawn paints the Maasai Mara in fiery hues, trade your safari jeep for a woven basket. Settled amidst the golden grasses, savor a gourmet feast as a symphony of birdsong fills the air. Witness the awakening of the savanna, where zebras graze and lions stretch, all from the comfort of your unique breakfast table.",
            rating: 4,
            imageURLs: ["bushbreak1", "bushbreak2", "bushbreak3", "bushbreak4"],
            features : [.mealOptions, .bigFiveSighting, .scenicLocation],
            amenities: [.lightBreakfast, .champagneToast, .photographyFavorite]
        ),
        
        
        //Bird Watching Listing
        Listing(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            ownerName: "Kamau",
            ownerImageUrl: "birdhost",
            numberofGuests: 10,
            pricePerActivity:4000,
            park: "Lake Nakuru National Park",
            city: "Nakuru",
            title: "Flock & Frame",
            description: "Unleash your inner shutterbug on a bird watching expedition in the breathtaking Lake Nakuru National Reserve. Witness a mesmerizing spectacle as a million flamingos transform the lake into a vibrant canvas. Capture the majestic Verreaux's Eagle soaring through the sky and zoom in on the dazzling plumage of the Long-tailed Widowbird against the stunning backdrop of the Rift Valley.",
            rating: 2,
            imageURLs: ["bird1", "bird2", "bird3", "bird4"],
            features : [.uniqueEncounters, .bigFiveSighting, .scenicLocation],
            amenities: [.lightBreakfast, .snacks, .guideBooks]
        ),
    ]
}
    
        
        
//        Cultural experiences
//        
//        
//        
//        Boat rides
//        
//        
//        
//        Camping
        
        
        
       // Photography
        
        
        
        //Fishing
        
        
        
        //Horseback riding
        
        
        
        
        
        
        
//    ]
//}
