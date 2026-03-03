# Rox News
> Power by News API

<img width="3840" height="2160" alt="Screenshots - Rox News" src="https://github.com/user-attachments/assets/0cdfa6d5-f9cb-465f-aa2e-a3dd8abd5379" />

## Minimum Prerequisites
- iOS/macOS 26.0
- XCode 26

## Setup
- Clone the Repository
```bash
git clone https://github.com/jaagrav-backup/Rox-News.git
# clone it or you can directly open with Xcode from github
```

- Open in Xcode
  1. Navigate to the project folder and double-click the .xcodeproj file.
- Update Signing & Team (Required)
  1. Since Apple requires a valid developer team to build apps, you must select your own:
  2. Select the Project in the Project Navigator (the top-most icon on the left).
  3. Go to the Signing & Capabilities tab.
  4. Under the Team dropdown, select your name or your development team.
  5. Note: If you see a "Bundle Identifier" error, change it to something unique (e.g., com.yourname.projectname).
- Run the App
  1. Select your target device or simulator in the top toolbar.

## Technical Implementation
Developed the app using the MVVM architecture with the app being separated into layers of views, models and view models. Here view models hold the business functions, and APIs.
I am also using singleton classes to share filter state across multiple views. One of the shortcuts I took that I would do differently was use matchedGeomtry for the navigation 
transition, as one of the design guidelines is that it's a good idea to have intentional animations like morphing and zooming in from where the user clicks so they can easily 
figure out where they came from. It would add that cherry on top in the UX that the app currently offers.

## Features
- Everything and Top headlines news feeds
- Filters
  - Select category for top headlines
  - Select company for everything
  - Page and Items returned per page
- Article reading screen
  - Apple intelligence summaries
  - See title, description, author, source, published date and url to open news in browser
- Background extension effect along with liquid glass
- Project follows Apple's design guidelines
- Loading and Error states
