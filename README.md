# GhostMark
GhostMark is a lightweight, open-source Markdown editor for mobile devices, designed to provide a seamless writing experience with direct publishing to WordPress.

## Features
- Simple and clean Markdown editor
- Minimalistic UI for distraction-free writing
- Markdown rendering for preview

## Tech Stack
Frontend: Flutter (for cross-platform mobile development)

## Installation & Setup
To get started with Modera development using Flutter, follow these steps:
1. Clone the repository
2. Install dependencies  
Make sure you have Flutter installed on your machine.  
`flutter pub get`
3. Run the app
For iOS (make sure you have Xcode installed):  
`flutter run`

## Riverpod
Riverpod is configured to use code generation, run the following command to run code generation.
```bash
flutter pub run build_runner build
```

## Troubleshoot
Google Play Error: "This App Bundle contains native code, and you've not uploaded debug symbols. We recommend you upload a symbol file to make your crashes and ANRs easier to analyze and debug."
1. Go to [YOUR_PROJECT]\build\app\intermediates\merged_native_libs\release\out\lib
2. Note that 3 folders exist inside
- arm64-v8a
- armeabi-v7a
- x86_64
3. Select these 3 folders and create a .zip file. The name doesn't matter.
4. Upload this new *.zip file as a Symbol File.

## Contributing
Contributions are welcome! If you'd like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch (`feature-branch-name`).
3. Commit your changes.
4. Push to your fork and submit a pull request.

## License
GhostMark is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact
For any questions or feedback, feel free to open an issue or reach out!
