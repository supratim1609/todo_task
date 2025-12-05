# Contributing to Flutter TODO App

Thank you for your interest in contributing! 🎉

## How to Contribute

### Reporting Bugs
- Use the GitHub Issues tab
- Describe the bug clearly
- Include steps to reproduce
- Add screenshots if applicable

### Suggesting Features
- Open a GitHub Issue with the "enhancement" label
- Describe the feature and its benefits
- Explain the use case

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Update documentation if needed
4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```
5. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

## Code Style Guidelines

### Dart/Flutter
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues
- Keep functions small and focused
- Add documentation comments for public APIs

### Architecture
- Maintain MVVM pattern
- Use Riverpod for state management
- Keep ViewModels testable
- Separate business logic from UI

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

### Commit Messages
- Use present tense ("Add feature" not "Added feature")
- Be descriptive but concise
- Reference issues when applicable

## Development Setup

```bash
# Install dependencies
flutter pub get

# Generate code (Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Check code quality
flutter analyze

# Format code
flutter format lib/
```

## Questions?

Feel free to open an issue for any questions or clarifications!

Thank you for contributing! 🚀
