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
The goal of the app is to provide college students with ride sharing platform via bulletin like application. WesRides will only help coordinating carpooling together and will not act as actual ride platform.

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
  * User profile screen
  * About page

#### External services
* Firebase (to handle user info, authentication, data storage, and chat)
* SideMenu CocoaPod (for sidebar navigation)
* Google Map API 

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
     * handles websocket with firebase
  7. About View Controller 
     * static stuff like credits, acknowledgements etc
  8. User Detailed View Controller
     * lets user change information like phone and email
  
* Service Classes 
  1. User Service
     * Create a user, obtain a user, obtain users excluding the current user, post posts, get followers, get timeline and observe user            profile
  2. Post Service
     * Create post and get post
  3. Contact service
     * Call / message driver

#### Data models 
* User
  - Used to store username, uid (key), phone number, email address of every user
* Post
  - Used to store time, from location, to location, amount of riders, payment if any
  
#### Helpers 
* Date Picker Helper
* Firebase Helper Classes
[Back to top ^](#)

---

### MVP Milestones
[The overall milestones of first usable build, core features, and polish are just suggestions, plan to finish earlier if possible. The last 20% of work tends to take about as much time as the first 80% so do not slack off on your milestones!]

#### Week 1
MONDAY:
 * Work on ADD (3 HRS)
 * Basic Xcode, Cocoa Pods, & Firebase Set Up. (1 HRS)
 * Work on app prototyping. (2-3 HRS)
 
TUESDAY:
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
 * Research & Basic Sidebar Controller Setup (5 HRS) 
 * User Login Persistence (singleton set up) (1 HRS) 
 
FRIDAY:
 * Advanced Sidebar Controller Setup (6 HRS) THIS IS GOOD BECAUSE YOU CAN GO BACK AND FIX STUFF

#### Week 2
MONDAY:
 * Create Rides in DB + Post Service (2 HRS)
 * Create Service Class for Rides + Ride Structure (2 HRS) 
 * Set Up Basic Timeline Table View Controller (1.5 HRS) 
 
TUESDAY:
 * Create Rides cell (5 HRS)
 * Display Rides (Populate the Cell) (1 HRS) 
 
WEDNESDAY:
 * Create Detailed Ride View Controller. (2HRS)
 * Add Contact service to detailed view controller. (2HRS)
 * Work on design of the view. (2 HRS) 

THURSDAY:
 * Create and fill some static info in About ViewController and put feedback form in there (2 HRS) 
 * Create Detailed User View Controller. (2 HRS)
 * Create forms to allow user to modificate some info in the database. (i.e. phone number, email) (2 HRS)
 
FRIDAY:
* Revisit Sidebar View Controller, update code if necessary. (3 HRS) 
* Review weekly progress (3 HRS)

#### Week 3
MONDAY:
 * Rescope Project (3 HRS)
 * Start working on chat feature - read and research about websocket chat (3 HRS)
 
TUESDAY:
 * Research and keep working on chat feature. If websocket seems too hard, switch to RESTful chat service. (6 HRS)
 
WEDNESDAY:
 * Think about design of the app (3 HRS)
 * Work on UX/UI (i.e. research on-line about best practices) (3 HRS)

THURSDAY:
 * Keep working on UX/UI, implement ideas in the storyboard (6 HRS)

FRIDAY:
 * User testing (3 HRS)
 * Review results MVP (3 HRS)
 
----------- HAVE A MVP BY THEN ----------- 

#### Week 4
MONDAY:
 * Review Project (3 HRS)
 * If progress is good, work on implementing google maps - extra (3 HRS)
 
TUESDAY:
 * Work on google maps or previous tasks (6 HRS)
 
WEDNESDAY:
 * If time permits, research about 3D touch and try to implement it (6 HRS)

THURSDAY:
 * By now I for sure should have MVP. Conduct User Testing again (3 HRS)
 * Review results (2 HRS)

FRIDAY:
 * Review progress made so far. (6 HRS)

#### Week 5
MONDAY:
 * Read through the App Store Guidelines (2 HRS)
 * Check the app if that follows the guidelines (1 HR)
 * Remove anything that does not follow the guideline if needed (0.5 HR)
 * Get Apple developer account (1 HRS)
 
TUESDAY:
 * App Icon (3 HRS)
 * App Keywords & Description (3 HRS)
 
WEDNESDAY:
 * App Screenshots (2 HRS)
 * App Keywords, Icon, Description Revisited (2 HRS)
 * Submit to App Store (2 HRS)
 
THURSDAY:
 * Submit to App Store (6 HRS)
 
FRIDAY:
 * Practice Pitching (6 HRS)
  
[Back to top ^](#)
