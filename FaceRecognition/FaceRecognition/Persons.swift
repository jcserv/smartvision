import Foundation
struct Persons : Codable {
	let label : String?
	let width : Int?
	let height : Int?

	enum CodingKeys: String, CodingKey {

		case label = "label"
		case width = "width"
		case height = "height"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
	}

}