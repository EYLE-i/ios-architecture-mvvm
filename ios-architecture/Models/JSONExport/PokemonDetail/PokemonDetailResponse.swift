//
//  PokemonDetail.swift
//  ios-architecture
//
//  Created by AIR on 2023/05/09.
//

import Foundation

struct PokemonDetail {
    var name: String
    var number: Int
}


// MARK: - PokemonDetail
struct PokemonDetailResponse: Decodable {
    var abilities: [Ability]?
    var baseExperience: Int?
    var forms: [Species]?
    var gameIndices: [GameIndex]?
    var height: Int?
    var heldItems: [String?]?
    var id: Int?
    var isDefault: Bool?
    var locationAreaEncounters: String?
    var moves: [Move]?
    var name: String?
    var order: Int?
    var pastTypes: [String?]?
    var species: Species?
    var sprites: Sprites?
    var stats: [Stat]?
    var types: [TypeElement]?
    var weight: Int?
}

// MARK: - Ability
struct Ability: Decodable {
    var ability: Species?
    var isHidden: Bool?
    var slot: Int?
}

// MARK: - Species
struct Species: Decodable {
    var name: String?
    var url: String?
}

// MARK: - GameIndex
struct GameIndex: Decodable {
    var gameIndex: Int?
    var version: Species?
}

// MARK: - Move
struct Move: Decodable {
    var move: Species?
    var versionGroupDetails: [VersionGroupDetail]?
}

// MARK: - VersionGroupDetail
struct VersionGroupDetail: Decodable {
    var levelLearnedAt: Int?
    var moveLearnMethod: Species?
    var versionGroup: Species?
}

// MARK: - GenerationV
struct GenerationV: Decodable {
    var blackWhite: Sprites?
}

// MARK: - GenerationIv
struct GenerationIv: Decodable {
    var diamondPearl: Sprites?
    var heartgoldSoulsilver: Sprites?
    var platinum: Sprites?
}

// MARK: - Versions
struct Versions: Decodable {
    var generationI: GenerationI?
    var generationIi: GenerationIi?
    var generationIii: GenerationIii?
    var generationIv: GenerationIv?
    var generationV: GenerationV?
    var generationVi: [String: Home]?
    var generationVii: GenerationVii?
    var generationViii: GenerationViii?
}

// MARK: - Sprites
class Sprites: Decodable {
    var backDefault: String?
    var backFemale: String?
    var backShiny: String?
    var backShinyFemale: String?
    var frontDefault: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?
    var other: Other?
    var versions: Versions?
    var animated: Sprites?

    init(backDefault: String?, backFemale: String?, backShiny: String?, backShinyFemale: String?, frontDefault: String?, frontFemale: String?, frontShiny: String?, frontShinyFemale: String?, other: Other?, versions: Versions?, animated: Sprites?) {
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.backShiny = backShiny
        self.backShinyFemale = backShinyFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        self.frontShiny = frontShiny
        self.frontShinyFemale = frontShinyFemale
        self.other = other
        self.versions = versions
        self.animated = animated
    }
}

// MARK: - GenerationI
struct GenerationI: Decodable {
    var redBlue: RedBlue?
    var yellow: RedBlue?
}

// MARK: - RedBlue
struct RedBlue: Decodable {
    var backDefault: String?
    var backGray: String?
    var backTransparent: String?
    var frontDefault: String?
    var frontGray: String?
    var frontTransparent: String?
}

// MARK: - GenerationIi
struct GenerationIi: Decodable {
    var crystal: Crystal?
    var gold: Gold?
    var silver: Gold?
}

// MARK: - Crystal
struct Crystal: Decodable {
    var backDefault: String?
    var backShiny: String?
    var backShinyTransparent: String?
    var backTransparent: String?
    var frontDefault: String?
    var frontShiny: String?
    var frontShinyTransparent: String?
    var frontTransparent: String?
}

// MARK: - Gold
struct Gold: Decodable {
    var backDefault: String?
    var backShiny: String?
    var frontDefault: String?
    var frontShiny: String?
    var frontTransparent: String?
}

// MARK: - GenerationIii
struct GenerationIii: Decodable {
    var emerald: OfficialArtwork?
    var fireredLeafgreen: Gold?
    var rubySapphire: Gold?
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Decodable {
    var frontDefault: String?
    var frontShiny: String?
}

// MARK: - Home
struct Home: Decodable {
    var frontDefault: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?
}

// MARK: - GenerationVii
struct GenerationVii: Decodable {
    var icons: DreamWorld?
    var ultraSunUltraMoon: Home?
}

// MARK: - DreamWorld
struct DreamWorld: Decodable {
    var frontDefault: String?
    var frontFemale: String?
}

// MARK: - GenerationViii
struct GenerationViii: Decodable {
    var icons: DreamWorld?
}

// MARK: - Other
struct Other: Decodable {
    var dreamWorld: DreamWorld?
    var home: Home?
    var officialArtwork: OfficialArtwork?
}

// MARK: - Stat
struct Stat: Decodable {
    var baseStat: Int?
    var effort: Int?
    var stat: Species?
}

// MARK: - TypeElement
struct TypeElement: Decodable {
    var slot: Int?
    var type: Species?
}

