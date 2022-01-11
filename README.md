# Pizza Ordering App

## 1. Requirements
### Functional Requirements
- Show a list of pizza restaurants and have the closest to your current location at the top.   
- From the list enter into a detailed view for that restaurant and display the available menu for that location.
- Let the users add items from the menu into a shopping cart.
- Place the order.
- Display the orders state.

### Non-Functional Requirements
1. **Responsiveness**
	- Cache data
	- Concurrency
2. **Consistency**
	- Avoid race conditions
3. **Power consumption**

## 2. Development Process
### Tech Stack
#### Programming Language
**Swift**
- SwiftUI
- Combine
- Concurrency
- Archives and Serialization (Codable)
#### Frameworks
- **Alamofire**
Alamofire is an HTTP networking library written in Swift.
- **SwiftLocation**
SwiftLocation is a lightweight Swift Library that provides an easy way to work with location-related functionalities. 
- **XCTest**
Unit test framework

#### Toolchains
- **InjectionIII**
InjectionIII allows you to update the implementation of functions and any method of a class, struct or enum incrementally in the iOS simulator without having to rebuild or restart your application.
- **App Icon Generator**
https://appicon.co
- **Swiftlint**
A tool to enforce Swift style and conventions.

### How To Develop
1. Analyze, create, prioritize tasks

2. Test-driven development
   - Unit tests
   - UI Tests

3. Live coding
   Develop features and fix bugs while the app is running.

   - Modify UI and see the changes in simulator instantly.
   - Moidfy Non-UI logic and see the changes in simulator instantly.

## 3. Achitecture
The architecture pattern is MVVM.

**Model:** A model is a representation of data. They are the bits and bytes your app moves around, from tweets to User objects to to-do list tasks.
**View:** A view is responsible for displaying data to the user of your app, and handling interaction. It’s the UI of your app, or part of it.
**ViewModel:** A ViewModel represents the state of model data. It facilitates communication between views and models, through bindings, or other events and actions.

### Restaurant List
   - Restaurant List View
   - Restaurant List View Model
   - Restaurant List Model

### Restaurant
   - Restaurant View
   - Restaurant View Model
   - Restaurant Model

### Shopping Cart
   - Shopping Cart View
   - Shopping Cart View Model
   - Shopping Cart Model

### Purchase
   - Checkout View
   - Order Placed View
   - Shopping Cart View Model
   - Order Model

### Order List
   - Order List View 
   - Order List View Model
   - Order Model

### Order
   - Order View

### Service 
   - Backend API
   - Location Service

## 4. Tests
### Unit Tests
   - BackendAPI Tests
### UI Tests
   - Restaurant Related UI Tests
   - Order Related UI Tests

## 5. Assumptions
It's a code challenge, but not a real project. Time is shorter than a real project. In addition, requirements can't be as clarified as possible. So I have to make a lot of assumptions. In a real project, I would communicate to remove uncertainty.

1. Assume that the evaluation standards:
  	- Functional
  	- Without UI designer's help, the UI should be reasonable.
  	- Code is readable and expressive and functional.

2. Assume the source lines of code is within 2000. I have to limit the hidden features and UI polishing even I can make it better.

3. Assume that I shouldn't use too many 3rd party frameworks, so interviewers can more easily read the code without learning those 3rd party frameworks if necessary. 

4. Assume that I only need to develop the app for iPhone. I can develop an app for iPhone and iPad, I just don't have enough time to do it.

5. Assume I might be able to use incorrect pictures because the app can't get the necessary pictures from Backend which doens't support it.