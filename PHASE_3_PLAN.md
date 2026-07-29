# Phase 3: Carrier Route Management - Planning Document

## Overview
Phase 3 implements the core business logic for carriers to post and manage delivery routes. This is a foundational feature that enables the entire marketplace.

## Phase 3 Scope

### Features to Implement

#### 1. Route Data Model
**File:** `lib/models/route_model.dart` (NEW)

```dart
class Route {
  String id;
  String carrierId;
  String departureCity;
  String destinationCity;
  DateTime departureDate;
  DateTime departureTime;
  String vehicleType; // car, van, truck
  double maxWeightCapacity; // kg
  double maxParcelCount;
  String carPlate;
  bool isRecurring;
  RecurrencePattern? recurrence; // daily, weekly, etc
  double pricePerKg;
  double basePrice;
  String description;
  List<String> allowedItemTypes;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
}

enum RecurrencePattern {
  daily,
  weekly,
  biweekly,
  monthly
}
```

#### 2. Route Creation Screen
**File:** `lib/screens/carrier/create_route_screen.dart` (NEW)

Features:
- Form for entering route details
- Date/time picker for departure
- Vehicle type dropdown
- Capacity input (weight & count)
- Recurring route options
- Photo upload for vehicle/carplate
- Submit and validation

Fields:
- Departure city (required)
- Destination city (required)
- Departure date & time (required)
- Vehicle type (car/van/truck)
- Max weight capacity (kg)
- Max parcel count
- Car plate number
- Recurring: Yes/No
  - If yes: Daily/Weekly/Biweekly/Monthly
- Base price
- Price per kg
- Item type restrictions
- Description

#### 3. Route Listing Screen
**File:** `lib/screens/carrier/routes_list_screen.dart` (NEW)

Features:
- List all carrier's routes
- Filter by: Active/Completed/Cancelled
- Sort by: Date/Price
- Edit route functionality
- Delete route functionality
- View route details
- Accept/Reject bookings for route

#### 4. Route Details Screen
**File:** `lib/screens/carrier/route_details_screen.dart` (NEW)

Shows:
- Route information
- Bookings for this route
- Earnings from this route
- Map preview
- Edit/Delete options

#### 5. Route Search (Sender Side)
**File:** `lib/screens/sender/search_routes_screen.dart` (NEW)

Features:
- Search criteria:
  - Departure city
  - Destination city
  - Date range
  - Weight/parcel count needed
- Filter results by:
  - Price (low to high)
  - Departure time
  - Rating
  - Vehicle type
- Display search results with:
  - Route summary
  - Carrier info & rating
  - Price
  - Availability

## Implementation Plan

### Step 1: Route Model & Firestore Schema
**Duration:** 2-4 hours

Tasks:
- [ ] Create Route data model with Firestore serialization
- [ ] Create RecurrencePattern enum
- [ ] Create Firestore-like structure
- [ ] Add model validation methods

Firestore Collection Structure:
```
routes/
├── {routeId}/
│   ├── carrierId
│   ├── departureCity
│   ├── destinationCity
│   ├── departureDate
│   ├── departureTime
│   ├── vehicleType
│   ├── maxWeightCapacity
│   ├── maxParcelCount
│   ├── carPlate
│   ├── isRecurring
│   ├── recurrencePattern
│   ├── pricePerKg
│   ├── basePrice
│   ├── isActive
│   ├── createdAt
│   └── updatedAt
```

### Step 2: Firestore Security Rules Update
**Duration:** 1-2 hours

Rules to add:
- Carriers can create routes (write to routes/{routeId})
- Carriers can only edit/delete their own routes
- Senders can read active routes
- Only route owner can see detailed information
- Timestamp validation on server

### Step 3: Route Creation Flow
**Duration:** 6-8 hours

Tasks:
- [ ] Design UI for route creation form
- [ ] Implement form with validation
- [ ] Add city autocomplete (future: use maps API)
- [ ] Add date/time pickers
- [ ] Implement vehicle photo upload
- [ ] Save route to Firestore
- [ ] Show success/error messages

### Step 4: Route Listing (Carrier Dashboard)
**Duration:** 4-6 hours

Tasks:
- [ ] List all carrier's routes
- [ ] Implement filter buttons
- [ ] Show route stats (bookings, earnings)
- [ ] Add edit/delete functionality
- [ ] Show route status indicators
- [ ] Implement pagination or infinite scroll

### Step 5: Route Details & Booking Management
**Duration:** 4-6 hours

Tasks:
- [ ] Create route details screen
- [ ] Show all bookings for route
- [ ] Display booking status
- [ ] Allow accept/reject bookings
- [ ] Show route earnings
- [ ] Implement route editing
- [ ] Implement route cancellation

### Step 6: Route Search & Filtering (Sender)
**Duration:** 8-10 hours

Tasks:
- [ ] Create search form screen
- [ ] Implement search criteria inputs
- [ ] Connect to Firestore queries
- [ ] Implement filtering logic
- [ ] Create results display screen
- [ ] Add sorting options
- [ ] Show carrier information
- [ ] Book route from search results

### Step 7: Testing & Bug Fixes
**Duration:** 4-6 hours

Tasks:
- [ ] Test all CRUD operations
- [ ] Test validation
- [ ] Test filtering & search
- [ ] Test error handling
- [ ] Test with multiple users
- [ ] Performance optimization if needed

---

## Firestore Queries Needed

### For Carriers
```
// Get all routes for current carrier
routes
  .where('carrierId', '==', userId)
  .orderBy('departureDate', 'descending')

// Get active routes
routes
  .where('carrierId', '==', userId)
  .where('isActive', '==', true)
  .orderBy('departureDate', 'descending')

// Get recurring routes
routes
  .where('carrierId', '==', userId)
  .where('isRecurring', '==', true)
```

### For Senders
```
// Search routes by cities and date
routes
  .where('departureCity', '==', city1)
  .where('destinationCity', '==', city2)
  .where('departureDate', '>=', startDate)
  .where('departureDate', '<=', endDate)
  .where('isActive', '==', true)

// Filter by weight capacity
routes
  .where('maxWeightCapacity', '>=', requiredWeight)

// Sort by price
routes
  .orderBy('basePrice', 'ascending')
```

---

## UI/UX Considerations

### Route Creation
- Autocomplete for city selection (future: maps integration)
- Date/time picker (Flutter built-in or package)
- Toggle for recurring routes
- Clear form validation feedback
- Preview of entered data before submission

### Route Listing
- Card-based layout
- Status indicator (Active/Completed/Cancelled)
- Quick actions (Edit/Delete/View)
- Summary stats (bookings, earnings)
- Empty state message when no routes

### Search Results
- Sortable by price, time, rating
- Quick route info card
- Book button prominently displayed
- Carrier profile preview on tap
- Map preview (future)

---

## Riverpod Providers Needed

```dart
// Get all routes for carrier
final carrierRoutesProvider = FutureProvider<List<Route>>((ref) async {
  // query Firestore for current user's routes
});

// Stream of routes (real-time updates)
final carrierRoutesStreamProvider = StreamProvider<List<Route>>((ref) async* {
  // watch routes collection for current user
});

// Search routes for sender
final searchRoutesProvider = FutureProvider.family<List<Route>, SearchCriteria>((ref, criteria) async {
  // query Firestore with search criteria
});

// Get route details
final routeDetailsProvider = FutureProvider.family<Route, String>((ref, routeId) async {
  // fetch single route by id
});
```

---

## Validation Rules

### Route Creation
- Departure city: non-empty, valid city name
- Destination city: non-empty, different from departure
- Departure date: future date only
- Departure time: valid 24-hour format
- Vehicle type: one of (car, van, truck)
- Max weight capacity: positive number > 0
- Max parcel count: positive integer > 0
- Car plate: valid format for Azerbaijan (e.g., AZ123AB)
- Base price: positive number > 0
- Price per kg: positive number > 0
- Description: max 500 characters (optional)

### Search Criteria
- Departure city: non-empty
- Destination city: non-empty
- Date range: valid dates
- Weight needed: positive number (optional)
- Parcel count: positive integer (optional)

---

## Error Handling

Possible errors:
- Invalid city input
- Past date selection
- Capacity too low
- No routes found in search
- Firestore write/read errors
- Network errors
- Permission denied (non-carrier trying to create route)

---

## Timeline Estimate

| Task | Duration | Total |
|---|---|---|
| Route Model & Firestore | 2-4h | 2-4h |
| Security Rules | 1-2h | 3-6h |
| Route Creation | 6-8h | 9-14h |
| Route Listing | 4-6h | 13-20h |
| Route Details | 4-6h | 17-26h |
| Route Search | 8-10h | 25-36h |
| Testing & Fixes | 4-6h | 29-42h |

**Estimated Total: 4-5 development days**

---

## Cities/Locations Database

For MVP, implement with hardcoded list:
```dart
const List<String> azerbaijanCities = [
  'Baku',
  'Ganja',
  'Sumgayit',
  'Quba',
  'Lahij',
  'Shaki',
  'Balakan',
  'Zaqatala',
  'Ismayilli',
  'Shamakhi',
  // ... more cities
];
```

Future: Load from Firestore or API

---

## Key Files to Create

```
lib/
├── models/
│   └── route_model.dart               (NEW)
├── screens/
│   ├── carrier/
│   │   ├── create_route_screen.dart   (NEW)
│   │   ├── routes_list_screen.dart    (NEW)
│   │   └── route_details_screen.dart  (NEW)
│   └── sender/
│       └── search_routes_screen.dart  (NEW)
├── providers/
│   └── route_provider.dart            (NEW)
└── services/
    └── route_service.dart             (NEW)
```

---

## Phase 3 Success Criteria

- [x] Carriers can create routes with all required details
- [x] Routes persist to Firestore correctly
- [x] Carriers can view/edit/delete their routes
- [x] Senders can search routes by location and date
- [x] Search results show relevant routes with filters
- [x] Recurring routes work correctly
- [x] All validation rules enforced
- [x] Proper error messages displayed
- [x] Firestore RLS rules ensure data security
- [x] Performance acceptable with 1000+ routes

---

## Notes

### Cities Implementation
Start with hardcoded list of major Azerbaijani cities. Future versions can:
- Load from Firestore
- Use Google Places API
- Implement autocomplete

### Map Integration
Phase 3 uses city names only. Phase 4+ can add:
- Route visualization on map
- Distance calculation
- Real-time location tracking

### Pricing
Current implementation:
- Fixed base price + per kg pricing
- Future phases can add:
  - Dynamic pricing based on demand
  - Discounts for bulk delivery
  - Premium pricing for express

### Analytics
Track for future optimization:
- Routes created per carrier
- Average earnings per route
- Popular routes
- Search-to-booking conversion

---

## Ready for Implementation

Phase 3 is well-scoped and straightforward. The authentication from Phase 2 provides the foundation needed. After Phase 3, the app will have:
- User registration and auth
- Carrier route posting
- Sender route search

This enables the core marketplace matching functionality!
