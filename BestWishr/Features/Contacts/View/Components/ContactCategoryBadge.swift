import SwiftUI

struct ContactCategoryBadge: View {
    let category: ContactCategory
    let size: BadgeSize
    
    enum BadgeSize {
        case small, medium, large
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
            case .medium: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .large: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 12
            }
        }
    }
    
    init(category: ContactCategory, size: BadgeSize = .small) {
        self.category = category
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.system(size: size.iconSize, weight: .medium))
                .foregroundColor(category.color)
            
            Text(category.rawValue)
                .font(.system(size: size.fontSize, weight: .medium, design: .rounded))
                .foregroundColor(category.color)
        }
        .padding(size.padding)
        .background(category.color.opacity(0.1))
        .cornerRadius(size == .small ? 6 : size == .medium ? 8 : 10)
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 8) {
            ContactCategoryBadge(category: .family, size: .small)
            ContactCategoryBadge(category: .friends, size: .small)
            ContactCategoryBadge(category: .colleagues, size: .small)
            ContactCategoryBadge(category: .other, size: .small)
        }
        
        HStack(spacing: 8) {
            ContactCategoryBadge(category: .family, size: .medium)
            ContactCategoryBadge(category: .friends, size: .medium)
        }
        
        HStack(spacing: 8) {
            ContactCategoryBadge(category: .colleagues, size: .large)
            ContactCategoryBadge(category: .other, size: .large)
        }
    }
    .padding()
}