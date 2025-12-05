# Flutter TODO App 📝

A beautiful, production-ready Flutter TODO application featuring **MVVM architecture**, **Riverpod state management**, and a stunning **dark theme** with notebook-style interactions.

![Flutter](https://img.shields.io/badge/Flutter-3.1.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🎯 Core Functionality
- ✅ **MVVM Architecture** - Clean separation with Models, Views, ViewModels
- ✅ **Riverpod State Management** - Type-safe dependency injection
- ✅ **Local Storage** - Fast Hive database for offline-first experience
- ✅ **Infinite Scrolling** - Efficient pagination for large task lists
- ✅ **Task Filtering** - Filter by All, Pending, or Completed
- ✅ **Swipe to Delete** - Intuitive gesture-based deletion
- ✅ **Task Sharing** - Share via email or shareable links

### 🎨 Design & UX
- 🌙 **Sexy Dark Theme** - Deep blacks with vibrant purple/pink gradients
- ✨ **Gradient Effects** - Smooth gradients on buttons and cards
- 💫 **Smooth Animations** - Polished transitions and micro-interactions
- 📓 **Notebook-Style Completion** - Swipe right to "scratch off" completed tasks
- 🎭 **Neon Glows** - Purple/pink glow effects on interactive elements
- 📱 **Fully Responsive** - Adapts to all screen sizes

### 🚀 Unique Interactions
- **Swipe Right →** to complete tasks (draws a green line across)
- **Swipe Left ←** to uncomplete tasks
- **Swipe to Delete** for quick removal
- **Pull to Refresh** for manual sync
- **Tap to Edit** for detailed task management

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/       # Colors, text styles, dimensions
│   ├── utils/          # Validators, formatters
│   └── widgets/        # Reusable components
├── models/             # Data models (Task, User, Share)
├── services/           # Business logic (Auth, Hive, Share)
├── repositories/       # Data access abstraction
├── viewmodels/         # State management (MVVM)
├── providers/          # Riverpod providers
└── views/              # UI screens & widgets
```

### MVVM Flow
```
View → ViewModel → Repository → Service → Database
  ↑                                           ↓
  └──────────── State Update ←────────────────┘
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter 3.1.0+ |
| Language | Dart 3.0.0+ |
| State Management | Riverpod 2.6.1 |
| Local Database | Hive 2.2.3 |
| Storage | shared_preferences |
| Typography | Google Fonts (Inter) |
| Sharing | share_plus |
| Utils | uuid, intl |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.1.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd todo

# Install dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## 📱 Usage

### Task Management
1. **Add Task** - Type in the bottom input field, press the gradient + button
2. **Complete Task** - Swipe right across the task (notebook scratch-off style)
3. **Uncomplete Task** - Swipe left across the task
4. **Delete Task** - Swipe left from the right edge
5. **Edit Task** - Tap on the task to open details
6. **Filter Tasks** - Tap the filter icon in the app bar

### Advanced Features
- **Share Task** - Open task details → tap share icon → choose method
- **Infinite Scroll** - Scroll down to automatically load more tasks
- **Pull to Refresh** - Pull down on the task list to refresh

## 🎨 Design System

### Color Palette
- **Primary**: Vibrant Purple (#8B5CF6)
- **Secondary**: Hot Pink (#EC4899)
- **Background**: Deep Black (#0F0F0F)
- **Surface**: Dark Gray (#1A1A1A)
- **Text**: Pure White (#FFFFFF)

### Key Design Elements
- Gradient buttons (purple → pink)
- Subtle card gradients
- Neon glow shadows
- Smooth 300ms transitions
- Rounded corners (12px)

## 📂 Project Statistics

- **Total Files**: 40+
- **Lines of Code**: ~3,500+
- **Models**: 3
- **Services**: 3
- **Repositories**: 3
- **ViewModels**: 3
- **UI Screens**: 4
- **Reusable Widgets**: 6+

## 🧪 Code Quality

✅ **Type Safety** - Full Dart null safety  
✅ **Clean Architecture** - MVVM with clear boundaries  
✅ **Immutable State** - StateNotifier pattern  
✅ **Error Handling** - Comprehensive try-catch blocks  
✅ **Code Generation** - Hive adapters via build_runner  

## 🔮 Future Enhancements

- [ ] Backend integration (Firebase/Supabase)
- [ ] Real-time multi-device sync
- [ ] Push notifications
- [ ] Task categories and tags
- [ ] Due dates and reminders
- [ ] Dark/Light theme toggle
- [ ] Search functionality
- [ ] Task attachments
- [ ] Offline sync queue

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## 👨‍💻 Author

Built with ❤️ using Flutter

---

**⭐ Star this repo if you find it helpful!**

## Development

### Adding New Features

1. **Create Model**: Define data structure in `models/`
2. **Create Service**: Implement business logic in `services/`
3. **Create Repository**: Abstract service in `repositories/`
4. **Create Provider**: Set up Riverpod provider in `providers/`
5. **Create ViewModel**: Manage state in `viewmodels/`
6. **Create View**: Build UI in `views/`

### Code Generation

When modifying Hive models, regenerate adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting

Check code quality:

```bash
flutter analyze
```

## Testing

The app architecture supports easy testing:

- **Unit Tests**: Test ViewModels with mock repositories
- **Widget Tests**: Test UI components in isolation
- **Integration Tests**: Test complete user flows

## Performance

- **Lazy Loading**: Tasks load in pages of 20
- **Efficient Rendering**: Only visible items rendered
- **Local Storage**: Fast Hive database operations
- **Stream-based Updates**: Reactive UI without rebuilds

## Future Enhancements

- Backend integration for real-time multi-device sync
- Push notifications for shared task updates
- Task categories and tags
- Due dates and reminders
- Dark mode support
- Offline sync queue
- Search functionality
- Task attachments

## License

This project is open source and available for personal and commercial use.

## Support

For issues or questions, please refer to the Flutter documentation:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
