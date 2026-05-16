import Foundation

struct ProductInfo {
    let name: String
    let nameArabic: String
    let manufacturer: String
    let category: ObjectCategory
    let releaseYear: String
    let visionLabels: [String]
}

enum ProductDatabase {
    static let products: [ProductInfo] = [
        ProductInfo(
            name: "iPhone 15 Pro Max",
            nameArabic: "آيفون 15 برو ماكس",
            manufacturer: "Apple",
            category: .smartphone,
            releaseYear: "2023",
            visionLabels: ["cell phone", "mobile phone", "iPhone", "smartphone"]
        ),
        ProductInfo(
            name: "iPhone 16 Pro",
            nameArabic: "آيفون 16 برو",
            manufacturer: "Apple",
            category: .smartphone,
            releaseYear: "2024",
            visionLabels: ["cell phone", "mobile phone", "iPhone"]
        ),
        ProductInfo(
            name: "Samsung Galaxy S24 Ultra",
            nameArabic: "سامسونج جالكسي S24 ألترا",
            manufacturer: "Samsung",
            category: .smartphone,
            releaseYear: "2024",
            visionLabels: ["cell phone", "mobile phone", "samsung", "galaxy"]
        ),
        ProductInfo(
            name: "Apple Watch Ultra 2",
            nameArabic: "ساعة أبل ألترا 2",
            manufacturer: "Apple",
            category: .watch,
            releaseYear: "2023",
            visionLabels: ["watch", "digital watch", "smartwatch", "apple watch"]
        ),
        ProductInfo(
            name: "Apple Watch Series 9",
            nameArabic: "ساعة أبل الإصدار 9",
            manufacturer: "Apple",
            category: .watch,
            releaseYear: "2023",
            visionLabels: ["watch", "digital watch", "wristwatch"]
        ),
        ProductInfo(
            name: "MacBook Pro 16\"",
            nameArabic: "ماك بوك برو 16 بوصة",
            manufacturer: "Apple",
            category: .laptop,
            releaseYear: "2024",
            visionLabels: ["laptop", "notebook", "computer", "macbook"]
        ),
        ProductInfo(
            name: "MacBook Air M3",
            nameArabic: "ماك بوك إير M3",
            manufacturer: "Apple",
            category: .laptop,
            releaseYear: "2024",
            visionLabels: ["laptop", "notebook", "computer"]
        ),
        ProductInfo(
            name: "Sony Alpha A7 IV",
            nameArabic: "سوني ألفا A7 IV",
            manufacturer: "Sony",
            category: .camera,
            releaseYear: "2023",
            visionLabels: ["camera", "digital camera", "SLR"]
        ),
        ProductInfo(
            name: "AirPods Pro 2",
            nameArabic: "إيربودز برو 2",
            manufacturer: "Apple",
            category: .headphones,
            releaseYear: "2023",
            visionLabels: ["headphones", "earbuds", "airpods", "earphones"]
        ),
        ProductInfo(
            name: "iPad Pro M4",
            nameArabic: "آيباد برو M4",
            manufacturer: "Apple",
            category: .tablet,
            releaseYear: "2024",
            visionLabels: ["tablet", "iPad", "tablet computer"]
        ),
    ]

    static func findProduct(forLabels labels: [String]) -> ProductInfo? {
        let lowercasedLabels = labels.map { $0.lowercased() }
        var bestMatch: ProductInfo?
        var bestScore = 0

        for product in products {
            let score = product.visionLabels.reduce(0) { total, label in
                total + (lowercasedLabels.contains(where: { $0.contains(label) }) ? 1 : 0)
            }
            if score > bestScore {
                bestScore = score
                bestMatch = product
            }
        }

        return bestMatch
    }

    static func defaultProduct(for category: ObjectCategory) -> ProductInfo {
        products.first { $0.category == category } ?? ProductInfo(
            name: "Unknown Object",
            nameArabic: "جسم غير معروف",
            manufacturer: "غير محدد",
            category: .generic,
            releaseYear: "-",
            visionLabels: []
        )
    }
}
