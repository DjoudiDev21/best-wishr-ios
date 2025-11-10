# BestWishr App Structure & Architecture

## 🎯 App Overview

**BestWishr** is a comprehensive event management app that helps users:
- Create and manage events (birthdays, anniversaries, celebrations)
- Manage contacts and their important dates
- Receive smart notifications and reminders
- Get AI-powered gift suggestions
- Track gift history and preferences

---

## 📱 Core Features & User Journey

### Primary User Flow
```
1. Authentication → 2. Contacts Management → 3. Event Creation → 4. Notifications → 5. Gift Suggestions
```

### Feature Modules

#### 🔐 **Authentication Module** (Already Implemented)
- Login/Register/Forgot Password
- User profile management
- Session management

#### 👥 **Contacts Module** 
- Import contacts from device
- Manual contact creation/editing
- Contact categorization (family, friends, colleagues)
- Contact profile with preferences

#### 🎉 **Events Module**
- Create events (birthday, anniversary, custom)
- Recurring events management
- Event templates
- Calendar integration

#### 🔔 **Notifications Module**
- Smart reminder system (7 days, 3 days, 1 day, same day)
- Customizable notification settings
- Push notifications
- In-app notification center

#### 🎁 **Gift Suggestions Module**
- AI-powered gift recommendations
- Browse gift categories
- Save favorite gifts
- Gift purchase tracking
- Price tracking and alerts

#### 📊 **Analytics Module**
- Event history
- Gift spending analytics
- Upcoming events dashboard
- Celebration statistics

---

## 🏗️ Technical Architecture

### App Structure Following MBPS Pattern

```
BestWishr/
├── Features/
│   ├── Auth/ (✅ Implemented)
│   │   ├── Model/
│   │   ├── Business/
│   │   ├── Presenter/
│   │   ├── Store/
│   │   └── View/
│   │
│   ├── Contacts/
│   │   ├── Model/
│   │   │   ├── Entities/
│   │   │   │   ├── Contact.swift
│   │   │   │   ├── ContactCategory.swift
│   │   │   │   └── ContactPreferences.swift
│   │   │   ├── DTOs/
│   │   │   │   ├── ContactRequestDto.swift
│   │   │   │   ├── ContactResponseDto.swift
│   │   │   │   └── ContactSyncDto.swift
│   │   │   └── Repositories/
│   │   │       ├── ContactRepositoryProtocol.swift
│   │   │       ├── LocalContactRepository.swift
│   │   │       ├── RemoteContactRepository.swift
│   │   │       └── DeviceContactRepository.swift
│   │   ├── Business/
│   │   │   ├── ImportContactsUseCase.swift
│   │   │   ├── CreateContactUseCase.swift
│   │   │   ├── UpdateContactUseCase.swift
│   │   │   ├── DeleteContactUseCase.swift
│   │   │   └── SearchContactsUseCase.swift
│   │   ├── Presenter/
│   │   │   └── ContactsPresenter.swift
│   │   ├── Store/
│   │   │   └── ContactsStore.swift
│   │   └── View/
│   │       ├── ContactsScreen.swift
│   │       ├── ContactDetailScreen.swift
│   │       ├── ContactFormScreen.swift
│   │       └── Components/
│   │           ├── ContactCard.swift
│   │           ├── ContactSearchBar.swift
│   │           └── ContactCategoryPicker.swift
│   │
│   ├── Events/
│   │   ├── Model/
│   │   │   ├── Entities/
│   │   │   │   ├── Event.swift
│   │   │   │   ├── EventType.swift
│   │   │   │   ├── RecurrenceRule.swift
│   │   │   │   └── EventReminder.swift
│   │   │   ├── DTOs/
│   │   │   │   ├── EventRequestDto.swift
│   │   │   │   ├── EventResponseDto.swift
│   │   │   │   └── EventsListDto.swift
│   │   │   └── Repositories/
│   │   │       ├── EventRepositoryProtocol.swift
│   │   │       ├── LocalEventRepository.swift
│   │   │       └── RemoteEventRepository.swift
│   │   ├── Business/
│   │   │   ├── CreateEventUseCase.swift
│   │   │   ├── UpdateEventUseCase.swift
│   │   │   ├── DeleteEventUseCase.swift
│   │   │   ├── GetUpcomingEventsUseCase.swift
│   │   │   └── CalculateEventRemindersUseCase.swift
│   │   ├── Presenter/
│   │   │   └── EventsPresenter.swift
│   │   ├── Store/
│   │   │   └── EventsStore.swift
│   │   └── View/
│   │       ├── EventsScreen.swift
│   │       ├── EventDetailScreen.swift
│   │       ├── CreateEventScreen.swift
│   │       ├── EventCalendarScreen.swift
│   │       └── Components/
│   │           ├── EventCard.swift
│   │           ├── EventTypeSelector.swift
│   │           ├── RecurrenceSelector.swift
│   │           └── CalendarView.swift
│   │
│   ├── Notifications/
│   │   ├── Model/
│   │   │   ├── Entities/
│   │   │   │   ├── Notification.swift
│   │   │   │   ├── NotificationSettings.swift
│   │   │   │   └── ReminderRule.swift
│   │   │   ├── DTOs/
│   │   │   │   ├── NotificationDto.swift
│   │   │   │   └── NotificationSettingsDto.swift
│   │   │   └── Repositories/
│   │   │       ├── NotificationRepositoryProtocol.swift
│   │   │       ├── LocalNotificationRepository.swift
│   │   │       └── PushNotificationRepository.swift
│   │   ├── Business/
│   │   │   ├── ScheduleNotificationsUseCase.swift
│   │   │   ├── CancelNotificationsUseCase.swift
│   │   │   ├── UpdateNotificationSettingsUseCase.swift
│   │   │   └── ProcessNotificationUseCase.swift
│   │   ├── Presenter/
│   │   │   └── NotificationsPresenter.swift
│   │   ├── Store/
│   │   │   └── NotificationsStore.swift
│   │   └── View/
│   │       ├── NotificationsScreen.swift
│   │       ├── NotificationSettingsScreen.swift
│   │       └── Components/
│   │           ├── NotificationCard.swift
│   │           ├── NotificationToggle.swift
│   │           └── ReminderTimePicker.swift
│   │
│   ├── Gifts/
│   │   ├── Model/
│   │   │   ├── Entities/
│   │   │   │   ├── Gift.swift
│   │   │   │   ├── GiftCategory.swift
│   │   │   │   ├── GiftSuggestion.swift
│   │   │   │   ├── GiftHistory.swift
│   │   │   │   └── PriceAlert.swift
│   │   │   ├── DTOs/
│   │   │   │   ├── GiftSearchDto.swift
│   │   │   │   ├── GiftSuggestionDto.swift
│   │   │   │   ├── GiftCategoriesDto.swift
│   │   │   │   └── GiftPriceDto.swift
│   │   │   └── Repositories/
│   │   │       ├── GiftRepositoryProtocol.swift
│   │   │       ├── LocalGiftRepository.swift
│   │   │       ├── RemoteGiftRepository.swift
│   │   │       └── AIGiftRepository.swift
│   │   ├── Business/
│   │   │   ├── GetGiftSuggestionsUseCase.swift
│   │   │   ├── SearchGiftsUseCase.swift
│   │   │   ├── SaveGiftUseCase.swift
│   │   │   ├── TrackGiftPurchaseUseCase.swift
│   │   │   └── SetPriceAlertUseCase.swift
│   │   ├── Presenter/
│   │   │   └── GiftsPresenter.swift
│   │   ├── Store/
│   │   │   └── GiftsStore.swift
│   │   └── View/
│   │       ├── GiftsScreen.swift
│   │       ├── GiftSuggestionsScreen.swift
│   │       ├── GiftDetailScreen.swift
│   │       ├── SavedGiftsScreen.swift
│   │       └── Components/
│   │           ├── GiftCard.swift
│   │           ├── GiftCategoryGrid.swift
│   │           ├── PriceTracker.swift
│   │           └── GiftFilters.swift
│   │
│   └── Analytics/
│       ├── Model/
│       │   ├── Entities/
│       │   │   ├── EventAnalytics.swift
│       │   │   ├── SpendingAnalytics.swift
│       │   │   └── UserInsights.swift
│       │   ├── DTOs/
│       │   │   └── AnalyticsDto.swift
│       │   └── Repositories/
│       │       ├── AnalyticsRepositoryProtocol.swift
│       │       └── AnalyticsRepository.swift
│       ├── Business/
│       │   ├── GenerateAnalyticsUseCase.swift
│       │   └── ExportAnalyticsUseCase.swift
│       ├── Presenter/
│       │   └── AnalyticsPresenter.swift
│       ├── Store/
│       │   └── AnalyticsStore.swift
│       └── View/
│           ├── AnalyticsScreen.swift
│           ├── SpendingChartsScreen.swift
│           └── Components/
│               ├── AnalyticsChart.swift
│               ├── InsightCard.swift
│               └── StatsGrid.swift
│
├── Shared/
│   ├── Core/
│   │   ├── Network/ (✅ Implemented)
│   │   ├── Error/ (✅ Implemented)
│   │   ├── Storage/
│   │   │   ├── CoreDataManager.swift
│   │   │   ├── UserDefaults+Extensions.swift
│   │   │   └── KeychainManager.swift
│   │   ├── Location/
│   │   │   └── LocationManager.swift
│   │   ├── Calendar/
│   │   │   └── CalendarManager.swift
│   │   ├── Notifications/
│   │   │   ├── LocalNotificationManager.swift
│   │   │   └── PushNotificationManager.swift
│   │   └── AI/
│   │       ├── AIServiceProtocol.swift
│   │       ├── OpenAIService.swift
│   │       └── GiftRecommendationEngine.swift
│   │
│   ├── UI/ (✅ Partially Implemented)
│   │   ├── Components/ (✅ Auth components done)
│   │   │   ├── Common/
│   │   │   │   ├── LoadingIndicator.swift
│   │   │   │   ├── EmptyStateView.swift
│   │   │   │   ├── ErrorView.swift
│   │   │   │   └── RefreshableScrollView.swift
│   │   │   ├── Cards/
│   │   │   │   ├── BaseCard.swift
│   │   │   │   ├── EventCard.swift
│   │   │   │   ├── ContactCard.swift
│   │   │   │   └── GiftCard.swift
│   │   │   ├── Navigation/
│   │   │   │   ├── TabBarView.swift
│   │   │   │   └── NavigationBarView.swift
│   │   │   └── Charts/
│   │   │       ├── LineChart.swift
│   │   │       ├── PieChart.swift
│   │   │       └── BarChart.swift
│   │   ├── Styles/
│   │   │   ├── Colors.swift
│   │   │   ├── Typography.swift
│   │   │   ├── ButtonStyles.swift
│   │   │   └── CardStyles.swift
│   │   └── Extensions/
│   │       ├── Color+Theme.swift
│   │       ├── View+Extensions.swift
│   │       └── Date+Extensions.swift
│   │
│   ├── Utils/
│   │   ├── DateHelper.swift
│   │   ├── ContactsHelper.swift
│   │   ├── NotificationHelper.swift
│   │   └── ValidationHelper.swift
│   │
│   └── AppStore.swift (✅ Implemented)
│
└── Resources/
    ├── Assets.xcassets
    ├── Info.plist
    └── Localizable.strings
```

---

## 🗃️ Data Models

### Core Entities

#### Contact
```swift
struct Contact: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let phoneNumber: String?
    let dateOfBirth: Date?
    let category: ContactCategory
    let preferences: ContactPreferences
    let avatar: String?
    let createdAt: Date
    let updatedAt: Date
}

enum ContactCategory: String, CaseIterable {
    case family, friends, colleagues, other
}

struct ContactPreferences: Codable {
    let giftCategories: [GiftCategory]
    let priceRange: ClosedRange<Double>
    let interests: [String]
    let allergies: [String]
}
```

#### Event
```swift
struct Event: Identifiable, Codable {
    let id: String
    let title: String
    let description: String?
    let eventType: EventType
    let contactId: String?
    let date: Date
    let recurrence: RecurrenceRule?
    let reminders: [EventReminder]
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
}

enum EventType: String, CaseIterable {
    case birthday, anniversary, wedding, graduation, other
}

struct RecurrenceRule: Codable {
    let frequency: RecurrenceFrequency
    let interval: Int
    let endDate: Date?
}

enum RecurrenceFrequency: String, CaseIterable {
    case daily, weekly, monthly, yearly
}
```

#### Gift
```swift
struct Gift: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let category: GiftCategory
    let price: Double
    let currency: String
    let imageURL: String?
    let purchaseURL: String?
    let rating: Double?
    let tags: [String]
}

enum GiftCategory: String, CaseIterable {
    case electronics, books, clothing, jewelry, experiences, food, toys, home, sports, beauty
}
```

---

## 📊 App Navigation Structure

### Tab-Based Navigation

```
📱 Main App Tabs:
├── 🏠 Home (Dashboard)
│   ├── Upcoming Events (next 30 days)
│   ├── Today's Notifications
│   ├── Quick Actions (Add Event, Add Contact)
│   └── Recent Gift Suggestions
│
├── 👥 Contacts
│   ├── All Contacts (with search & filter)
│   ├── Import Contacts
│   ├── Contact Categories
│   └── [Contact Detail] → Events → Gift History
│
├── 🎉 Events
│   ├── Upcoming Events
│   ├── Past Events
│   ├── Calendar View
│   ├── Create Event
│   └── [Event Detail] → Edit → Reminders → Gift Suggestions
│
├── 🎁 Gifts
│   ├── Browse Categories
│   ├── AI Suggestions (for upcoming events)
│   ├── Saved Gifts
│   ├── Price Alerts
│   └── Purchase History
│
└── ⚙️ Settings
    ├── Profile
    ├── Notification Settings
    ├── Privacy Settings
    ├── Analytics & Insights
    └── Help & Support
```

---

## 🔄 Data Flow & State Management

### Store Hierarchy

```swift
@MainActor
class AppStore: ObservableObject {
    @Published var authStore: AuthStore
    @Published var contactsStore: ContactsStore
    @Published var eventsStore: EventsStore
    @Published var giftsStore: GiftsStore
    @Published var notificationsStore: NotificationsStore
    @Published var analyticsStore: AnalyticsStore
    
    // Global state
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var currentUser: User?
}
```

### Cross-Feature Communication

```
Events ←→ Contacts (Events linked to contacts)
Events ←→ Notifications (Events trigger notifications)
Events ←→ Gifts (Events suggest gifts)
Gifts ←→ Contacts (Gift preferences from contacts)
Analytics ←→ All Modules (Analytics from all activities)
```

---

## 🔔 Notification Strategy

### Notification Types

1. **Event Reminders**
   - 7 days before: "John's birthday is coming up!"
   - 3 days before: "Don't forget John's birthday on Friday"
   - 1 day before: "John's birthday is tomorrow"
   - Same day: "It's John's birthday today! 🎉"

2. **Gift Suggestions**
   - "We found perfect gifts for John's birthday"
   - "Price drop alert for saved gifts"

3. **Weekly Summary**
   - "You have 3 upcoming events this week"

### Implementation
- Local notifications for reminders
- Push notifications for real-time updates
- In-app notification center
- Smart notification scheduling

---

## 🎁 AI Integration Strategy

### Gift Recommendation Engine

```swift
protocol AIServiceProtocol {
    func generateGiftSuggestions(
        for contact: Contact, 
        event: Event, 
        budget: ClosedRange<Double>
    ) async throws -> [GiftSuggestion]
    
    func analyzeGiftPreferences(
        from history: [GiftHistory]
    ) async throws -> ContactPreferences
}
```

### AI Features
- Personalized gift suggestions based on:
  - Contact preferences
  - Event type
  - Budget range
  - Past purchase history
  - Trending gifts
- Gift category predictions
- Price optimization suggestions

---

## 📈 Analytics & Insights

### Key Metrics
- Events created/completed
- Gift spending trends
- Notification engagement rates
- Most popular gift categories
- Seasonal spending patterns

### User Insights
- "You typically spend $50-100 on birthday gifts"
- "Your friends love tech gadgets"
- "You have 5 events coming up this month"

---

## 🔒 Privacy & Security

### Data Protection
- Local data encryption
- Secure API communication
- Contact permission management
- Optional cloud sync
- GDPR compliance

### User Control
- Data export functionality
- Account deletion
- Granular privacy settings
- Offline mode support

---

## 🚀 Implementation Phases

### Phase 1: Foundation (Weeks 1-2)
- ✅ Authentication (Done)
- ✅ Basic Navigation (Done)
- 📝 Contacts Module (Core CRUD)
- 📝 Basic Events Module

### Phase 2: Core Features (Weeks 3-4)
- 📝 Event Creation & Management
- 📝 Local Notifications
- 📝 Basic Gift Suggestions
- 📝 Dashboard/Home Screen

### Phase 3: Advanced Features (Weeks 5-6)
- 📝 AI Gift Recommendations
- 📝 Analytics & Insights
- 📝 Calendar Integration
- 📝 Advanced Notifications

### Phase 4: Polish & Optimization (Weeks 7-8)
- 📝 Performance Optimization
- 📝 UI/UX Refinement
- 📝 Testing & Bug Fixes
- 📝 App Store Preparation

---

## 🛠️ Development Priorities

### Immediate Next Steps
1. **Contacts Module**: Foundation for all other features
2. **Events Module**: Core app functionality
3. **Basic Notifications**: Essential user engagement
4. **Dashboard**: Central user experience

### Success Metrics
- User creates first contact within 5 minutes
- User creates first event within 10 minutes
- User receives and acts on first notification
- User views first gift suggestion

This structure provides a comprehensive foundation for building BestWishr as a full-featured event management and gift suggestion platform while maintaining clean architecture and excellent user experience.