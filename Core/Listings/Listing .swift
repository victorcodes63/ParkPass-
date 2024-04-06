//
//  Listing .swift
//  ParkPass 1.0
//
//  Created by Victor Chumo on 29/02/2024.
//

import Foundation

struct ListingArray: Codable {
    let listings: [Listing]
    let total, skip, limit: Int
}

struct Listing: Identifiable, Codable, Hashable {
    var id: String
    var ownerUid: String
    var ownerName: String
    var ownerImageUrl: String
    var numberofGuests: Int
    var pricePerActivity: Int
    var park: String
    var city: String
    var title: String
    var description: String
    var rating: Int
    var imageURLs: [String]
    var features: [ListingFeatures]
    var amenities: [ListingAmenities]
}

enum ListingFeatures: Int, Codable, Identifiable, Hashable {
    case bigFiveSighting
    case uniqueEncounters
    case offRoadExperience
    case intermediateDifficulty
    case trailHighlights
    case sunriseFlight
    case landingLocation
    case scenicLocation
    case mealOptions
    
    var imageName: String {
        switch self {
        case .bigFiveSighting: return "fossil.shell.fill"
        case .uniqueEncounters: return "tuningfork"
        case .offRoadExperience: return "car.side.hill.up.fill"
        case .intermediateDifficulty: return "figure.step.training"
        case .trailHighlights: return "point.bottomleft.forward.to.point.topright.scurvepath.fill"
        case .sunriseFlight: return "sunrise.circle.fill"
        case .landingLocation: return "cloud.rainbow.half"
        case .scenicLocation: return "moon.haze.fill"
        case .mealOptions: return "fork.knife"
        }
    }
    
    var title: String {
        switch self {
        case .bigFiveSighting: return "Big Five sighting"
        case .uniqueEncounters: return "Unique encounters"
        case .offRoadExperience: return "Off-Road experience"
        case .intermediateDifficulty: return "Intermediate difficulty"
        case .trailHighlights: return "Trail highlights"
        case .sunriseFlight: return "Sunrise flight"
        case .landingLocation: return "Unique landing locations"
        case .scenicLocation: return "Scenic locations"
        case .mealOptions: return "Meal options"
        }
    }
    
    var subtitle: String {
        switch self {
        case .bigFiveSighting: return "Experience the ultimate African wildlife encounter"
        case .uniqueEncounters: return "Discover the hidden treasures of the park"
        case .offRoadExperience: return "Embark on a journey of discovery off the beaten path"
        case .intermediateDifficulty: return "Find the perfect balance of difficulty for any skill level"
        case .trailHighlights: return "Explore diverse hidden gems along the way"
        case .sunriseFlight: return "Experience a breathtaking sunrise"
        case .landingLocation: return "Choose from diverse landing locations for an unforgettable experience"
        case .scenicLocation: return "Enjoy a miriad of scenic locations amidst the wilderness in stunning locations"
        case .mealOptions: return "Choose from a variety of meal options to fuel your adventures"
            }
        }
    
    var id: Int { return self.rawValue}
}

enum ListingAmenities: Int, Codable, Identifiable, Hashable {
    case binoculars
    case guideBooks
    case chargingPorts
    case snacks
    case coldDrinks
    case signage
    case benches
    case guidedHike
    case preFlightBriefing
    case experiencedPilot
    case champagneToast
    case photographyFavorite
    case lightBreakfast
    
    
    var title: String {
        switch self {
        case .binoculars: return "Binoculars"
        case .guideBooks: return "Guide Books"
        case .chargingPorts: return "Charging Ports"
        case .snacks: return "Snacks"
        case .coldDrinks: return "Cold Drinks"
        case .signage: return "Signage"
        case .benches: return "Benches"
        case .guidedHike: return "Guided Hike"
        case .preFlightBriefing: return "Pre-flight Briefing"
        case .experiencedPilot: return "Experienced Pilot"
        case .champagneToast: return "Champagne Toast"
        case .photographyFavorite: return "Photographer's Favorite"
        case .lightBreakfast: return "Light Breakfast"
        }
    }
    
    var imageName: String {
        switch self {
        case .binoculars: return "binoculars"
        case .guideBooks: return "book.pages"
        case .chargingPorts: return "powerplug"
        case .snacks: return "fork.knife.circle.fill"
        case .coldDrinks: return "waterbottle.fill"
        case .signage: return "signpost.right.and.left"
        case .benches: return "studentdesk"
        case .guidedHike: return "figure.hiking"
        case .preFlightBriefing: return "person.and.background.striped.horizontal"
        case .experiencedPilot: return "airplane.circle"
        case .champagneToast: return "wineglass"
        case .photographyFavorite: return "camera"
        case .lightBreakfast: return "fork.knife.circle"
        }
    }
    
    
    var id: Int { return self.rawValue}
}
final class ListingDatabase {
    
    static let listings: [Listing] = [
        //Game drive
        .init(
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
        .init(
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
        .init(
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
        .init(
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
        .init(
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
        .init(
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
        
        
        //Camping
        
        
        //Horseback Riding
        
        //boatingAndCanoeing
        
        //cultural tours
    ]
    
}
