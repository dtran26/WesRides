## Table of Contents
  * [App Design](#app-design)
    * [Objective](#objective)
    * [Audience](#audience)
    * [Experience](#experience)
  * [Technical](#technical)
    * [Screens](#Screens)
    * [External services](#external-services)
    * [Views, View Controllers, and other Classes](#Views-View-Controllers-and-other-Classes)
  * [MVP Milestones](#mvp-milestones)
    * [Week 1](#week-1)
    * [Week 2](#week-2)
    * [Week 3](#week-3)
    * [Week 4](#week-4)
    * [Week 5](#week-5)
    * [Week 6](#week-6)

---

### App Design

#### Objective
The goal of the app is to provide college students with ride sharing platform

#### Audience
College students

#### Experience
Users will be able to:
 - Create new rides
 - View existing created rides
 - View their own rides
 - Chat with other users 
 - View Google Map (?)

[Back to top ^](#)

---

### Technical

#### Screens
  * Login Screen
  * Rides timeline 
  * View ride from timeline
  * Create a new ride
  * Chat with other users
  * View user past and upcoming rides
  * About page

#### External services
* Firebase (to handle user info, authentication, data storage, and chat)

#### Views, View Controllers, and other Classes
* Views
  1. Ride cell
     * A cell with brief info about the ride on the timeline
* View Controllers
  1. Login View Controller
     * handles all login logic
  2. Timeline View Controller
     * timeline for all the rides
  3. Create Ride View Controller
     * handles the logic for creating a new ride
  4. Detailed Ride View Controller
     * displays detailed version of the ride
  5. Sidebar View Controller
     * handles navigation logic
  6. Chat View Controller
  7. About View Controller
* Other Classes
  * Firebase Helper Classes

#### Data models
* User
* Post

#### Helpers
* Date Picker Helper
[Back to top ^](#)

---

### MVP Milestones
[The overall milestones of first usable build, core features, and polish are just suggestions, plan to finish earlier if possible. The last 20% of work tends to take about as much time as the first 80% so do not slack off on your milestones!]

#### Week 1
MONDAY and TUESDAY: 
 * Create Wireframe	(1.5 DAYS)
 * Work on ADD (3 HRS)
 * Basic Xcode, Cocoa Pods, & Firebase Set Up. (1 HRS)
 * Create Folder & Project Structure for Xcode project			(.5 HRS)
 * Basic Login & User Setup	(3 HRS)	
 * Create Login View Controller (1 HRS)
 * User Authentication with Firebase (2 HRS)

WEDNESDAY:
 * Username View Controller Setup	(3 HRS)
 * Refactoring User class	(3 HRS)
    * Include Username
    * Reset Users on Firebase
   
THURSDAY:
 * Basic Sidebar Controller Setup (3 HRS)
 * User Login Persistence (3 HRS)
 
FRIDAY:
 * Basic Sidebar Controller Setup (6 HRS)
#### Week 2
MONDAY:
 * Create Rides (3 HRS)
 * Set Up Basic Table View Controller (3 HRS)
 
TUESDAY:
 * Create Rides cell (6 HRS)
 * Display Rides (3 HRS)
 
WEDNESDAY:
 * Detailed Ride ViewController (6 HRS)

THURSDAY:
 * About ViewController (5 HRS)

FRIDAY:
* Revisit Sidebar View Controller (3 HRS)

#### Week 3
MONDAY:
 * Rescope Project (3 HRS)
 * Start working on chat feature (3 HRS)
 
TUESDAY:
 * Research and work on chat feature (6 HRS)
 
WEDNESDAY:
 * Think about design of the app (3 HRS)
 * Work on UX/UI (3 HRS)

THURSDAY:
 * Keep working on UX/UI (6 HRS)

FRIDAY:
 * User testing (3 HRS)
 * Review results (3 HRS)

#### Week 4
MONDAY:
 * Review Project (3 HRS)
 * If progress is good, work on implementing google maps - extra (3 HRS)
 
TUESDAY:
 * Work on google maps or previous tasks (6 HRS)
 
WEDNESDAY:
 * Work on google maps or previous tasks (6 HRS)

THURSDAY:
 * Go back and try and refactor previous code (6 HRS)

FRIDAY:
 * Review progress (6 HRS)


#### Week 5
MONDAY:
 * Read through the App Store Guidelines (2 HRS)
 * Check the app if that follows the guidelines (1 HR)
 * Get Apple developer account (3 HRS)
 
TUESDAY:
 * Remove anything that does not follow the guideline if needed (0.5 HR)
 * App Icon (3 HRS)
 * App Keywords & Description (3 HRS)
 
WEDNESDAY:
 * App Screenshots (3 HRS)
 * App Keywords, Icon, Description Revisited (3 HRS)
 
THURSDAY:
 * Submit to App Store (6 HRS)
 
FRIDAY:
 * Submit to App Store (6 HRS)
  
[Back to top ^](#)
