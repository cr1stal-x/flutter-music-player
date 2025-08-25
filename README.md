# AP Flutter Music Player Project (Spring 404)

This repository contains a Flutter-based frontend for a music player application, paired with a Java backend (Spring) and server-side components. The project supports local music playback, online music from a server, user authentication, and a server-backed music store with a dual-database approach. The README below consolidates the core features, architecture, setup, and guidelines pulled from the provided project description.

> Note: The original document is in Persian. This README provides a clear, developer-friendly English summary with key sections, while preserving the project’s scope and requirements.

---

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Key Features](#key-features)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Database & Data Flow](#database--data-flow)
- [UI & UX Overview](#ui--ux-overview)
- [Getting Started](#getting-started)
- [Development Guidelines](#development-guidelines)
- [Phases & Deliverables](#phases--deliverables)
- [Contribution & Quality](#contribution--quality)
- [Notes & Assumptions](#notes--assumptions)

---

## Overview

- A mobile music player app with:
    - Local music playback (files stored on the device)
    - Online songs from a server (via socket-based communication)
    - User registration and login
    - Local and server-side song catalogs with categories
    - A shop section with paid/free songs, downloads, and reviews
    - User profile, wallet/credit, and subscription options
- Frontend: Flutter (Dart) with the FlutterFlow-like workflow
- Backend: Java (Spring) with socket-based communication to the Flutter frontend
- Data persistence: dual-database setup (file-based and MySQL) as per project requirements

---

## Project Structure

- Frontend (Flutter)
    - Home
    - Music Shop
    - Song Details
    - Sign Up / Sign In (Login)
    - Music List/Category views
    - Player controls (play, pause, skip, shuffle, repeat)
    - Lyrics (optional)
    - Favorites/Watchlist
    - Lyrics and metadata storage in local state or persistent storage
    - Authentication state management (Provider or GetX recommended)
- Backend (Java Spring)
    - User management (registration, login)
    - Song catalog (local and server-side)
    - Payments (simulated via a mock gateway)
    - Socket server for real-time data exchange
    - Database persistence (MySQL for song/metadata; text-based/file-based for certain user data)
- Data exchange
    - Base64-encoded payloads for binary data (e.g., audio files, images)
    - Socket-based communication between front-end and back-end
    - Optional API endpoints as alternatives (REST/GraphQL) where applicable

---

## Key Features

- Local music browsing and playback
- Server-sourced music with categories (e.g., Iranian, foreign, local, newest)
- Song details including title, artist, album art, and rating
- Search and sort capabilities (by name, rating, time added, plays, etc.)
- Lyrics editing (optional)
- In-app playback controls with SeekBar progress
- Favorites list and “Now Playing” details
- Music Shop: login/signup, category browsing, song listing with purchase/download
- User account screen: profile picture, username, email, password changes, credits, and subscription management
- Payment screen: simulated card entry, transaction, and credit/subscription upgrade
- Real-time updates via Socket between frontend and backend
- Data persistence using:
    - MySQL for structured data (songs, users, purchases, etc.)
    - Text-based storage (for some non-binary data)
    - Optional local caching using SQLite or SharedPreferences

---

## Architecture & Tech Stack

- Frontend: Flutter (Dart)
    - State management: Provider or GetX
    - Audio playback: Just Audio (recommended)
    - File access: path_provider
    - Permissions: permission_handler
- Backend: Java (Spring)
    - Socket-based communication with the Flutter frontend
    - Database: MySQL (for songs, purchases, user data) and a text-based store (for certain metadata)
- Data formats:
    - Binary data (audio, images) in Base64 when transmitted
    - JSON payloads for structured data (where REST is used)
- Deployment considerations:
    - Multi-user concurrency via threading on the server
    - Data persistence across sessions using a database
    - No hard dependency on any one backend technology; dual-database design is required

---

## Database & Data Flow

- User data
    - Stored in the text-based database (e.g., usernames, emails, passwords, subscriptions)
- Song data
    - Stored in MySQL (title, artist, cover image path, Base64-encoded audio, rating, etc.)
    - Audio delivery from server to client occurs after a purchase/download trigger
- Data exchange
    - Socket-based exchange for real-time synchronization
    - Optional API endpoints can be used as an alternative
- Data format guidance
    - Audio and image binary data can be Base64 encoded and stored or transmitted as strings
    - Files stored locally on the device for offline playback
    - Paths or identifiers stored in the database to reference media

---

## UI & UX Overview

- Home Screen
    - Local and downloaded songs list
    - Sections to categorize songs by folders/albums
    - Song item tile with title, artist, cover, and play button
    - Search bar and sorting options
    - Bottom navigation for Home and Music Shop
    - “Favorites/Liked” list and a quick access to the current song
- Song Details
    - Album art, title, artist
    - Progress bar/Seekbar with time elapsed and remaining
    - Playback controls: play/pause, next, previous, shuffle, repeat
    - Option to add to favorites or create a “Lyrics” entry
- Music Shop
    - Sign Up / Sign In flows
    - Categories to filter songs
    - Song listings with cover art, title, artist, and rating
    - Purchase/download flow (simulated payment)
    - User account access and purchase history
- Account Screen
    - Profile image, username, email
    - Password change, logout, and account deletion
    - Wallet/credit balance and subscription management
    - Theme customization
    - Support chat link
- Payment Screen
    - Simulated card entry (dummy numbers)
    - Amount, payment button
    - Post-payment update to user balance/subscription
- Responsiveness
    - Consider across phones and tablets
    - UI components designed to adapt to screen sizes

---

## Getting Started

Note: The project uses a dual-database approach and socket-based communication. Ensure:
- Flutter environment is set up (Flutter SDK, Dart)
- Android/iOS development environment configured (emulators or devices)
- Java/JVM environment for the backend (JDK 17+ recommended)
- MySQL server available and accessible
- Socket endpoints configured for frontend-backend communication

Steps (high level):
1. Set up the backend
    - Configure MySQL (database names, user credentials)
    - Run the Spring application
    - Ensure socket server is listening for client connections
2. Set up the frontend
    - Open the Flutter project
    - Update API/socket endpoints to match backend
    - Configure permissions (file access, storage) in AndroidManifest.xml and iOS equivalents
    - Run on a device or emulator
3. Data seeding
    - Seed initial users and song catalog in the databases as per the project instructions
4. Run and test
    - Test local playback, server-sourced songs, authentication, and purchasing flow
    - Validate socket communication for real-time updates

---

## Development Guidelines

- Phase-based development
    - Phase 1 (Frontend only): Implement all frontend screens in Flutter using dummy data or mock services
    - Phase 2 (Frontend + Backend): Implement actual database access, CRUD operations via sockets, and real-time sync
- Data handling
    - Use Base64 for binary payloads when transferring media
    - Keep sensitive data secure; validate inputs on the client and server
- State management
    - Prefer GetX or Provider for simple state management
    - Persist essential user data in a local store (e.g., SharedPreferences/SQLite)
- Code quality
    - Proper naming conventions, comments, and documentation
    - Include a README in each major folder with purpose and setup steps
    - Add tests where feasible (unit tests for business logic)
- Collaboration
    - Use Git and GitHub for version control
    - Use Trello or similar for task management
    - Ensure both frontend and backend team members can work on their parts; cross-coverage is encouraged

---

## Phases & Deliverables

- Phase 1: Frontend Implementation
    - Complete UI for all listed screens on the frontend
    - No backend integration; use mock data
    - Document UI flows and any assumptions
- Phase 2: Backend Integration
    - Implement database schemas (MySQL and text-based as described)
    - Implement Socket-based communication between frontend and backend
    - Ensure synchronization of song lists, purchases, and user data
    - Validate multi-user support and data persistence after restarts
- Deliverables
    - Functional mobile app (frontend) demonstrating all screens
    - Backend server with socket communication and database integration
    - A comprehensive README and developer documentation
    - Git repository with clear commit messages and a project plan

---

## Contribution & Quality

- GitHub repository required
- Ensure all contributors understand their roles
- Maintain code quality and documentation
- Include screenshots, architecture diagrams, and usage notes in the repository
- Honor academic integrity: no plagiarism or cheating
- Any form of misrepresentation or copying will affect grading

---

## Notes & Assumptions

- The project uses a dual-database approach:
    - File/Text-based storage and MySQL for different data categories
    - If alternate databases are used, both methods need to be implemented to receive full marks
- Media storage strategy may involve local storage on device or server-provided assets
- The server must be capable of handling multiple users concurrently (threaded)
- All closeout requirements emphasize proper authentication, payments (simulated), and secure handling of credentials

---

## Quick Start Checklist

- [ ] Set up MySQL and prepare databases for users, songs, purchases
- [ ] Implement sockets on server and client or configure REST fallback
- [ ] Create user flows (Sign Up, Sign In) and profile management
- [ ] Implement local music access (permission handling)
- [ ] Build Home and Music Shop UIs with category filtering
- [ ] Implement playback controls with Just Audio
- [ ] Implement download/purchase flow and server delivery
- [ ] Ensure state persistence and theme customization
- [ ] Add tests and documentation

---

If you’d like, I can tailor this README further to reflect the exact file names, classes, and API endpoints you’re using, or format it to match a specific repository style (e.g., including badges, installation commands, and a quickstart script). Additionally, I can extract concrete code snippets or CLI commands from your project files if you provide more specifics.