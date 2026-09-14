# UberClone

A ride-hailing app for iOS, built with SwiftUI and MapKit. It covers the passenger
side of the flow: find a destination, see the route and fare, request a ride, and
follow it through to arrival.

<!-- Add a screenshot or screen recording here. -->

## Features

- **Live map** centred on the user, with nearby drivers shown as annotations
- **Destination search** with autocompleting address results (`MKLocalSearchCompleter`)
- **Route preview** — polyline, distance, and pickup / drop-off time estimates
  calculated with `MKDirections`
- **Fare estimates** per ride type (UberX, UberBlack, UberXL), priced from a base
  fare plus a per-mile rate over the routed distance
- **Trip flow** — request, driver matched, en route, arrival with rating and
  receipt, plus cancellation at any point before arrival
- **Side menu** with profile, trips, wallet, settings, and saved places
- Adapts to light and dark mode

## Requirements

- Xcode 14 or later
- iOS 16 or later
- No third-party dependencies — everything is SwiftUI, MapKit, and CoreLocation

## Running

```bash
open UberClone.xcodeproj
```

Pick an iPhone simulator and run. The app asks for location access on first
launch; in the simulator, set a position under **Features → Location → Custom
Location…** (or `xcrun simctl location <device> set <lat>,<lon>`) so the map has
somewhere to start from and routing has an origin.

## Project structure

```
UberClone/
├── App/                  App entry point; owns the shared view models
├── Core/
│   ├── Home/             Map presenter, home screen, map action button
│   ├── Location/         Destination search screen and its view model
│   ├── Ride/             Ride request sheet (ride types, pricing, confirm)
│   ├── Trip/             Trip sheets: loading, accepted, in progress, completed, cancelled
│   ├── SideMenu/         Drawer menu and its destinations
│   └── Profile/          Current-user view model
├── Managers/             LocationManager — CoreLocation wrapper
├── Models/               MapViewState, RideType, Trip, Driver, User, UberLocation
└── Utils/                Formatting helpers and the color theme
```

## How it works

The whole UI is driven by one state machine, `MapViewState`. `HomeView` reads it to
decide which bottom sheet to show, and `UberMapViewPresenter` reads it to decide
what the map should display:

```
noInput → searchingForLocation → locationSelected → polylineAdded
        → tripRequested → tripAccepted → tripInProgress → tripCompleted
                                                        ↘ tripCancelled
```

`LocationSearchViewModel` is the shared source of truth behind it — it holds the
selected destination, the computed route, the fare, and the current trip, and is
injected as an environment object.

## Current limitations

There is no backend yet:

- **Driver matching and pickup are simulated.** `TripLoadingView` and
  `TripAcceptedView` advance the trip on a timer. Those two call sites are what a
  real dispatcher would replace.
- **No authentication.** `User.mock` stands in for the signed-in account.
- **Drivers are generated locally** around the user's position (`Driver.mockDrivers`)
  and do not move.
- **Ride-type artwork isn't in the asset catalog**, so the ride cards fall back to
  SF Symbols. `RideType.imageName` is already wired up for when the images land.
