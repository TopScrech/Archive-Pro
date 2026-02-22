# AGENTS Guide

## Source of truth

Use Apple documentation as the canonical reference for this setup
- https://developer.apple.com/documentation/xcode/embedding-a-helper-tool-in-a-sandboxed-app

## Terminal tools in sandboxed macOS app

Follow this exact flow when adding a new CLI tool to avoid App Store Connect upload failures

1. Place the binary in `Archive Pro/Tools/<tool-name>`
2. Keep `Tools/<tool-name>` excluded from normal target membership resources in `Archive Pro.xcodeproj/project.pbxproj` under `membershipExceptions`
3. Embed tools with a `PBXCopyFilesBuildPhase` named `Embed CLI Tools` and use:
   - `dstSubfolder = Executables`
   - `dstPath = Tools`
   - `CodeSignOnCopy` on each embedded tool
4. Never add CLI tools to `Resources` build phase

## Required helper entitlements

Helper tools must carry sandbox helper entitlements before Xcode re-signs them

- Use `Archive Pro/Tools/HelperTool.entitlements`
- Required keys:
  - `com.apple.security.app-sandbox = true`
  - `com.apple.security.inherit = true`

Sign each source tool before archive so Xcode can preserve identifier and entitlements

```bash
xattr -cr "Archive Pro/Tools/<tool-name>"
codesign --force --sign - --timestamp=none --options runtime \
  --identifier "dev.topscrech.Archive-Pro.helper.<tool-name>" \
  --entitlements "Archive Pro/Tools/HelperTool.entitlements" \
  "Archive Pro/Tools/<tool-name>"
```

## Runtime lookup requirements

Tool lookup code should prefer embedded executable locations in this order

1. `Contents/Executables/Tools/<tool-name>`
2. `Contents/MacOS/Tools/<tool-name>`
3. Bundle resource fallback only for development compatibility

## Validation before upload

Run these checks before uploading

```bash
xcodebuild -project "Archive Pro.xcodeproj" -scheme "Archive Pro" \
  -configuration Release -destination "generic/platform=macOS" archive
```

Then verify each embedded tool in the archive

- Is code signed
- Has `com.apple.security.app-sandbox`
- Has `com.apple.security.inherit`
- Uses a stable identifier like `dev.topscrech.Archive-Pro.helper.<tool-name>`

## Architecture rule

If app binary is universal (`arm64` + `x86_64`), embedded helper tools should also be universal
Arm64-only helpers can break validation or runtime behavior on Intel environments
