# GhostMark
GhostMark is a lightweight, open-source Markdown editor for mobile devices, built for focused, distraction-free writing.

[Get it on Google Play](https://play.google.com/store/apps/details?id=com.eunoia.ghost_mark)

## Features
- Simple and clean Markdown editor with autosave
- One-tap formatting toolbar above the keyboard (headings, bold, italic, lists, checklists, links, code)
- Instant preview of the rendered Markdown
- Open UTF-8 text files and save standard `.md` files
- Local-only storage: no account, no cloud

## Tech Stack
Frontend: Flutter (for cross-platform mobile development)

## Installation & Setup
To get started with GhostMark development using Flutter, follow these steps:
1. Clone the repository
2. Install dependencies (from the `ghost_mark/` folder)  
Make sure you have Flutter installed on your machine.  
`flutter pub get`
3. Run the app on a connected device or emulator  
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

## Issues
https://github.com/miguelpruivo/flutter_file_picker/issues/1885
