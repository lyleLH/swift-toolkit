import Foundation

struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case login, id, name, company, blog, location, email, bio
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
        case followers, following
    }
} 