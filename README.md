# UniComplaints – University Complaint Registry System

A modern cloud-based complaint management platform developed using **Flutter**, **Firebase Authentication**, and **Supabase Cloud Services**. The system allows university students to register and track complaints through a mobile application while enabling administrators to manage, review, and resolve complaints through a deployed web portal.

---

# Project Overview

UniComplaints replaces traditional paper-based and email-based university complaint systems with a centralized cloud-native platform. The project demonstrates the implementation of modern cloud services, REST APIs, authentication systems, distributed client architecture, and cloud storage integration.

The system consists of:

- 📱 Flutter Android application for students
- 🌐 Web-based administration portal
- ☁️ Supabase PostgreSQL cloud backend
- 🔐 Firebase Authentication
- 🗂️ Supabase Storage for image evidence uploads
- 🔗 REST API integration

---

# Features

## Student Mobile Application

- Student Signup & Login
- Email Verification using Firebase Auth
- Persistent Login Sessions
- Register Complaints
- Upload Evidence Images
- View Complaint History
- Track Complaint Status
- View Administrator Replies
- FAQ Section
- Premium Material 3 UI Design

---

## Administrator Web Portal

- Admin Login
- View All Complaints
- Search & Filter Complaints
- Update Complaint Status
- Add Administrative Replies
- View Uploaded Evidence Images
- Responsive Dashboard Design
- Real-Time Complaint Refresh

---

# Technology Stack

| Layer             | Technology              |
| ----------------- | ----------------------- |
| Mobile Frontend   | Flutter                 |
| Web Frontend      | HTML / CSS / JavaScript |
| Authentication    | Firebase Authentication |
| Database          | Supabase PostgreSQL     |
| Cloud Storage     | Supabase Storage        |
| Backend APIs      | Supabase REST APIs      |
| Deployment        | Netlify                 |
| Local Persistence | SharedPreferences       |

---

# System Architecture

```text
                    ┌──────────────────────┐
                    │   Firebase Auth      │
                    │  Email Verification  │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │     Flutter App      │
                    │     (Students)       │
                    └──────────┬───────────┘
                               │ REST APIs
                               ▼
          ┌────────────────────────────────────┐
          │        Supabase Backend            │
          │                                    │
          │  PostgreSQL + Storage + APIs       │
          └──────────┬─────────────────────────┘
                     │
                     ▼
          ┌────────────────────────────────────┐
          │      Admin Web Portal              │
          │      (HTML/CSS/JavaScript)         │
          └────────────────────────────────────┘
```

---

# Database Structure

## Users Table

| Column       | Description                  |
| ------------ | ---------------------------- |
| student_id   | Unique university student ID |
| student_name | Full student name            |
| email        | Registered email address     |
| created_at   | Account creation timestamp   |

---

## Complaints Table

| Column         | Description                                  |
| -------------- | -------------------------------------------- |
| id             | Complaint UUID                               |
| user_id        | Foreign key linked to student                |
| student_id     | Student university ID                        |
| student_name   | Student name                                 |
| email          | Student email                                |
| complaint_type | Complaint category                           |
| location       | Incident location                            |
| accused_person | Optional accused person                      |
| description    | Detailed complaint description               |
| evidence_url   | Uploaded image URL                           |
| status         | Pending / Under Review / Resolved / Rejected |
| created_at     | Complaint creation timestamp                 |

---

## Admin Replies Table

| Column       | Description           |
| ------------ | --------------------- |
| id           | Reply UUID            |
| complaint_id | Linked complaint UUID |
| admin_name   | Administrator name    |
| reply        | Admin response        |
| created_at   | Reply timestamp       |

---

# Complaint Categories

The system currently supports:

- Academic Issue
- Faculty Complaint
- Hostel Complaint
- WiFi / Internet Issue
- Library Complaint
- Cafeteria Complaint
- Transport Complaint
- Bullying / Harassment
- Exam Related Complaint
- Maintenance Issue
- Other

---

# Authentication Flow

1. Student signs up using email/password
2. Firebase sends verification email
3. User verifies email
4. Student logs in
5. Student profile stored in Supabase
6. Session persists using Firebase Authentication

---

# Image Upload Workflow

The system uses a two-step cloud upload mechanism:

1. Complaint is created first
2. Complaint UUID is generated
3. Evidence image uploads to Supabase Storage
4. Public image URL is generated
5. Complaint record is updated with image URL

Storage structure:

```text
complaints/<complaint_uuid>/evidence.jpg
```

---

# Admin Portal

The administrator dashboard provides:

- Complaint monitoring
- Complaint filtering
- Complaint status updates
- Administrative replies
- Evidence viewing
- Real-time refresh support

The portal is deployed as a static website using Netlify.

---

# Deployment

## Student APK

The Android APK is located in:

```text
unicomplaints-final-release-build.apk
```

---

## Admin Portal

Deployed Website:

```text
https://unicomplaints-sarvanth.netlify.app/
```

---

# Project Structure

```text
registry/
│
├── lib/ (aloong with other flutter and platform outside code)
│   └── Flutter source code
│
├── portal/
│   └── index.html
│
├── results/ (apk and url)
│
│
└── README.md
```

---

# Cloud Services Used

| Cloud Service           | Purpose                                  |
| ----------------------- | ---------------------------------------- |
| Firebase Authentication | User authentication & email verification |
| Supabase PostgreSQL     | Relational cloud database                |
| Supabase Storage        | Evidence image storage                   |
| Supabase REST APIs      | Backend API services                     |
| Netlify                 | Web portal deployment                    |

---

# Cost Analysis

The project was implemented entirely using free-tier cloud services.

| Service                 | Tier Used | Cost |
| ----------------------- | --------- | ---- |
| Firebase Authentication | Free Tier | ₹0   |
| Supabase                | Free Tier | ₹0   |
| Netlify                 | Free Tier | ₹0   |

---

# Screenshots

Add screenshots here:

- Login Screen
- Signup Screen
- Home Screen
- Register Complaint
- Complaint History
- Complaint Details
- Admin Dashboard
- Admin Reply Modal

---

# Future Improvements

- Push Notifications
- AI-based Complaint Categorisation
- Complaint Analytics Dashboard
- OCR-based Evidence Analysis
- Multi-admin Role Management
- University Department Routing
- Real-Time Notifications
- Chat Support System

---

# Conclusion

UniComplaints demonstrates a complete cloud-native complaint management platform integrating mobile computing, web technologies, cloud databases, authentication systems, cloud storage, and RESTful APIs into a single scalable ecosystem. The system successfully modernizes university complaint workflows while providing transparency, accessibility, and centralized administrative control.

---
