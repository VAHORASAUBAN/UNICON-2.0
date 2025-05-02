UniCon (Universities Connection)

UniCon is your go-to platform built to bridge students and faculty across universities. Imagine hackathons, one-on-one mentoring, doubt-clearing sessions, cultural and educational fairs, a shared digital notes library, and career-placement guidance—all under one roof.

 🚀 Why UniCon?
- Time-Tested Collaboration: Back in the day, face-to-face meetups were the only way. We’re honoring that tradition digitally.
- Practical Growth: No fluff. Straight-up resources and connections that actually level you up.
- Community-First: Your success is the only ROI we need.

 🔍 Features
1. ✅ Attendance System: Fully functional QR code-based attendance system for seamless check-ins.
2. ✅ Placement Opportunities: Curated placement listings to help students apply and track openings with ease.
3. ✅ User Profiles: Specialized dashboards for students and faculty.
4. 🚧 Hackathons & Events: Schedule, register, and participate in inter-university events. (Under Development)
5. 🚧 Mentorship Program: One-on-one sessions with senior students and faculty. (Under Development)
6. 🚧 Doubt Clearing: Drop your questions and get answers in real-time. (Under Development)
7. 🚧 Digital Notes Library: Upload, search, and download study materials. (Under Development)

 📂 Repo Structure
```
.\
├── .vscode/             # Editor config files
├── backend/             # Django REST API source
├── unicon/              # Frontend client (Flutter/web)
├── UNICON_LOGO.zip      # Branding assets
└── README.md            # Project overview (this file)
```

 🛠️ Tech Stack
- Backend: Django REST Framework + MySQL
- Frontend: Flutter (mobile/web)
- Auth: JWT-based secure login
- CI/CD: GitHub Actions

 ⚙️ Installation & Setup
1. Clone the repo
   ```bash
   git clone https://github.com/VAHORASAUBAN/UNICON-2.0.git
   cd UNICON-2.0
   ```
2. Backend
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate    # On Windows: venv\\Scripts\\activate
   pip install -r requirements.txt
   # Ensure MySQL server is running and a database named 'unicon' is created
   # Update DATABASES settings in settings.py accordingly
   python manage.py migrate
   python manage.py runserver  # Will run on localhost (usually http://127.0.0.1:8000)
   ```
3. Frontend (Mobile/Web)
   ```bash
   cd ../unicon
   flutter pub get
   flutter run
   ```
   > ⚠️ Make sure to update your API base URL in the Flutter app to match the backend IP (especially when testing on physical devices):
   ```Config.dart
   const String baseUrl = 'http://<your-local-IP>:8000/api/';
   ```
   Replace `<your-local-IP>` with the IP address of your machine running the backend server.

 📡 Architecture
UniCon follows a mobile-first client-server architecture:
- The Flutter app serves as the frontend interface for both Android, iOS, and web.
- The Django REST backend handles business logic, data validation, and database operations.
- Devices communicate with the backend via HTTP requests using the configured local IP address.

 🎯 Usage
- Hit `/api/` for backend endpoints.
- Launch the Flutter app on iOS/Android or web.
- Register as a student or faculty to dive in.

 🤝 Contributing
 Upgradation and Modification are always welcome. 
1. Fork the repo.
2. Create a feature branch: `git checkout -b feature/YourFeature`
3. Commit your changes: `git commit -m "Add YourFeature"`
4. Push to branch: `git push origin feature/YourFeature`
5. Open a Pull Request and get feedback.

We take code quality seriously—write tests and update docs.

 📜 License
This project is under the MIT License. Peace of mind for contributors and users.

---

> "Traditional values meet next-gen tech—UniCon keeps it real."

---

© 2025 UniCon Project Team. All rights reserved.
