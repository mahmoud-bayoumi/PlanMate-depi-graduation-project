# 📱 PlanMate – Collaborative Events Planner

## 👥 Team Members

* Mahmoud Mohamed Bayoumi
* Yasser Osama Mohamed
* Omar Ahmed Sayed
* Emy Ihab Fayez
* Fayez Sabry Fayez
* Menna Hesham Ali

---

PlanMate is a cross-platform mobile app built with **Flutter** and **Firebase** that allows users to create, manage, and collaborate on events in real-time. Whether it’s a birthday, wedding, meeting, or trip, PlanMate helps users stay organized with shared event planning, task management, and instant updates across all devices.

---

## 🚀 Objective

To build a mobile application for iOS and Android that enables users to:

* Create and manage events.
* Invite friends and collaborate in real-time.
* Track RSVPs and manage event-related tasks (e.g., booking, catering, shopping).
* Receive notifications when updates happen.

---

## 📝 Description

* Users can **register/login** to the app using secure authentication.
* Events can be created and **shared with collaborators**.
* Updates (e.g., adding tasks, marking them as complete, changing event details) sync instantly across all devices using Firebase’s real-time capabilities.
* Emphasis on:

  * **Clean UI**
  * **Secure authentication**
  * **Seamless collaboration**
  * **Deployment-ready code**

---

## 🛠️ Technologies

* **Flutter** & **Dart**
* **Firebase**

  * Authentication
  * Firestore
  * Cloud Messaging
* **Git & GitHub**
* **Unit Testing**
* **UI/UX Principles**
* **Security Essentials**
* **Mobile Deployment** (Android & iOS)

---

## 📅 Roadmap

### Week 1: Setup, UI/UX, and Flutter Basics

**Tasks:**

* Initialize Flutter project & GitHub repo.
* Create wireframes for key screens:

  * Login/Registration
  * Event Dashboard
  * Event Details
  * Task List/Notes
* Build static UI layouts for the above screens (no backend logic yet).

**Deliverables:**

* Flutter project pushed to GitHub.
* Wireframes for app flow.
* Static UI screens for Login, Dashboard, and Event Details.

---

### Week 2: Firebase Integration & Authentication

**Tasks:**

* Integrate Firebase (Android & iOS).
* Implement registration/login with Firebase Authentication.
* Design Firestore collections: `Users`, `Events`, `Tasks`, `Invitations`.
* Apply security rules to restrict data access to authenticated users only.

**Deliverables:**

* Connected Firebase project.
* Functional registration & login system.
* Firestore database with security rules.

---

### Week 3: Real-Time CRUD & Testing

**Tasks:**

* Implement CRUD operations: create, view, update, and delete events.
* Add task management with real-time sync (assign tasks, mark complete).
* Integrate state management (e.g., Provider, Riverpod, or Bloc).
* Write unit tests for core business logic.

**Deliverables:**

* Real-time event & task management.
* Smooth UI updates across all devices.
* Passing unit tests for core features.

---

### Week 4: Collaboration, Notifications & Deployment

**Tasks:**

* Add invitations and collaboration (invite users via email/username).
* Enable push notifications for updates & reminders (Firebase Cloud Messaging).
* Perform final end-to-end testing.
* Build signed APK (Android) & IPA (iOS), add app icons, and prepare store assets.

**Deliverables:**

* Event-sharing & invitations working.
* Notifications for updates/reminders.
* Release-ready builds for **Google Play Store** & **Apple App Store**.
* Completed documentation & testing report.

---

## 👩‍💻 Team Roles & Responsibilities – Detailed

* **Mahmoud Mohamed Bayoumi** → **Team Leader & AI Features**

  * **Responsibilities**: Assigns tasks, ensures feature quality, develops Splash Screen, Onboarding, and AI Chat.
  * **Splash Screen & Onboarding**: Provides a smooth first-time user experience with branded splash and guided onboarding.
  * **AI Chat**: Intelligent assistant recommending events to users and answering planning-related questions in real time.
  * **Leadership**: Oversees team progress, coordinates feature integration, and ensures timely delivery of high-quality modules.

* **Omar Ahmed Sayed** → **Authentication Module**

  * **Login & Registration**: Secure account creation and sign-in using Firebase Authentication.
  * **Reset Password**: Allows users to recover accounts via secure email flows.
  * **Focus**: Ensures robust authentication workflows and user data protection.

* **Yasser Osama Mohamed** → **Event Search & Favorites**

  * **Home Screen**: Centralized hub for upcoming and recent events with intuitive navigation.
  * **Favorites**: Allows users to bookmark and quickly access important events.
  * **Focus**: Enhances user experience by providing personalized, easy-to-access event management tools.

* **Emy Ihab Fayez** → **Event Management**

  * **Event Details**: Displays complete event information including date, location, participants, and status.
  * **User Events List**: Organizes all events the user is hosting or attending in a clear, manageable format.
  * **Focus**: Ensures seamless event tracking and user-friendly event interactions.

* **Menna Hesham Ali** → **Profile Module**

  * **User Profile**: Allows users to manage personal information, settings, and preferences.
  * **Focus**: Customizable and secure profile experience supporting personalization and account management.

* **Fayez Sabry Fayez** → **Collaboration Module (Group Chat)**

  * **PlanMate Chat**:

    * Implements a **real-time messaging system** using Firebase Firestore, ensuring low-latency and reliable communication between users.
    * Supports **one-to-many conversations** within events, allowing participants to share updates, reminders, and discussions in a centralized channel.
    * Integrates with user profiles for **identity-based messaging** (sender name, avatar, timestamp).
    * Designed with **scalability and responsiveness**, providing smooth performance across devices.
    * Enhances event engagement by fostering **seamless collaboration and coordination** among attendees before, during, and after events.

---

## 📂 Project Status

🚧 **In Progress**
This project is under active development. Contributions are welcome!

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a pull request

---

## 📎 Project Drive Link

📁 **Google Drive Folder for Docs, Assets, Screenshots And Project Files**:
[PlanMate Project Drive](https://drive.google.com/drive/folders/1oJo0dROzcJkCj9__EyeFnR49g1AHiXMr)

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

This version is fully detailed, professional, and ready for **GitHub, project submission, or documentation purposes**.

If you want, I can **also add a “Key Features Snapshot” table at the top** so someone can glance at each feature per team member in one view—makes the README extremely reader-friendly.

Do you want me to do that next?
