# AP Flutter Music Player Project (Spring 404)

This repository contains a Flutter-based frontend for a music player application, paired with a Java backend (using socket) and server-side components.
The project supports local music playback, online music from a server, user authentication, and a server-backed music store with a dual-database approach.

---

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Key Features](#key-features)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Database & Data Flow](#database--data-flow)
- [UI & UX Overview](#ui--ux-overview)

---

## Overview

- A mobile music player app with:
    - Local music playback (files stored on the device)
    - Online songs from a server (via socket-based communication)
    - User registration and login
    - Local and server-side song catalogs with categories
    - A shop section with paid/free songs, downloads, and reviews
    - User profile, wallet/credit, and subscription options
    - Playlist section that supports offline and online playlists
- Frontend: Flutter (Dart)
- Backend: Java with socket-based communication to the Flutter frontend
- Data persistence: dual-database setup (file-based and MySQL)

---

## Project Structure

- **Frontend (Flutter)**
    - Home
    - Music Shop
    - Song Details
    - Sign Up / Sign In
    - Music List/Category views
    - Player controls (play, pause, skip, shuffle, repeat)
    - Favorites/Watchlist
    - Playlists (offline/online)
    - Chat server
    - Authentication state management (Provider)

- **Backend (Java)**
    - User management (registration, login)
    - Song catalog (local and server-side)
    - Payments (mock gateway)
    - Socket server for real-time data exchange
    - Database persistence (MySQL + text-based store)

---

## Key Features

- Local music browsing and playback
- Server-sourced music with categories
- Creating playlists (local and online)
- Chat screen with server support
- Search and sort capabilities
- In-app playback controls with SeekBar
- Music Shop: login/signup, category browsing, purchase/download
- User account screen: profile, wallet/credits, subscription
- Payment simulation
- Real-time updates via Socket
- Dual-database persistence

---

## Architecture & Tech Stack

- **Frontend**: Flutter (Dart)
    - State management: Provider
    - Audio: Just Audio
    - File access: path_provider
    - Permissions: permission_handler
    - Models: on-audio-query
- **Backend**: Java
    - Socket server
    - MySQL + text-based storage
- **Data**
    - Base64 for audio/images
    - JSON for structured payloads
    - Local storage for offline playback

---

## Database & Data Flow

- **User data**: text-based database (username, email, password, subscription)
- **Song data**: MySQL (title, artist, cover path, Base64 audio, rating, etc.)
- **Exchange**: Socket-based, Base64 for binary, JSON for structured
- **Offline**: Files stored locally, playlists saved in SQLite

---

## UI & UX Overview

### Home Screen
- Local and downloaded songs
- Sections by folders/albums
- Song tiles with cover, title, artist
- Search/sort options
- Bottom navigation for Home/Shop
- Favorites and quick access to current song


---

### Song Details
- Album art, title, artist
- Progress bar with time
- Controls: play, pause, next, shuffle, repeat
- Favorites and lyrics option


---

### Music Shop
- Sign Up / Sign In
- Category filters
- Song listings with rating & cover
- Purchase/download flow
- Account access and purchase history


---

### Account Screen
- Profile image, username, email
- Password change, logout, delete
- Wallet/credits, subscription management
- Theme customization
- Support chat

---

### Payment Screen
- Dummy card entry
- Amount and payment button
- Updates balance/subscription

---

### Responsiveness
- Optimized for phones/tablets
- Adaptive UI components

### Screenshots

<div align="center">
<img src="screenshots/photo_2_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_22_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_11_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_16_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_14_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_6_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_18_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_15_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_4_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_13_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_8_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_20_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_3_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_5_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_1_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_12_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_7_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_19_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_10_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_9_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>
<img src="screenshots/photo_17_2025-08-25_20-22-59.jpg" alt="screenshot" width="200"/>

</div>

---

