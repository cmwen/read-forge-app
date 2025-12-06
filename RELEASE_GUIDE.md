# ReadForge MVP Release Guide

## Overview

This guide explains how to release the ReadForge MVP APK using the automated CI/CD pipeline.

## Current Status

✅ **MVP Implementation Complete**
- Library screen with book grid
- Book creation and management
- Book detail with TOC management  
- Reader screen with sample content
- Database persistence (Drift SQLite)
- State management (Riverpod)
- Clean architecture structure
- All tests passing
- No analyzer warnings

## Release Methods

### Method 1: Tag-Based Release (Recommended)

This is the standard way to create a release:

```bash
# 1. Merge this PR to main branch
# 2. Checkout main and pull latest
git checkout main
git pull origin main

# 3. Create and push a version tag
git tag v0.1.0
git push origin v0.1.0
```

This will automatically:
- Run all tests
- Build signed APK and App Bundle
- Create a GitHub Release with artifacts
- Auto-generate or use existing keystore for signing

### Method 2: Manual Workflow Dispatch

You can also trigger a release manually from GitHub:

1. Go to **Actions** tab in GitHub
2. Select **Flutter Release** workflow
3. Click **Run workflow**
4. Enter version (e.g., `0.1.0`) or leave empty to use pubspec.yaml version
5. Choose whether to create a git tag
6. Click **Run workflow**

## Signing Configuration

### Auto-Generated Keystore (Default)

If you haven't set up signing secrets, the CI will automatically:
1. Generate a new keystore
2. Sign your APK/AAB with it
3. Provide credentials as downloadable artifact
4. Show instructions to persist the keystore for future releases

**⚠️ Important**: You MUST save the auto-generated keystore credentials to update your app later!

### Using Existing Keystore

If you have a keystore, add these secrets to your repository:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add these repository secrets:
   - `ANDROID_KEYSTORE_BASE64`: Base64-encoded keystore file
   - `ANDROID_KEYSTORE_PASSWORD`: Keystore password
   - `ANDROID_KEY_ALIAS`: Key alias
   - `ANDROID_KEY_PASSWORD`: Key password

To generate keystore locally:
```bash
# Run the keystore generation script
./scripts/signing/generate-keystore.sh

# Or manually with keytool
keytool -genkey -v -keystore release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release
```

## After Release

### Download Artifacts

Once the release workflow completes:

1. **APK and App Bundle**: Available in the GitHub Release
2. **Signing Credentials** (if auto-generated): Download from workflow artifacts

### Install the APK

You can install the APK directly on Android devices:

```bash
# Via ADB
adb install readforge-0.1.0+1.apk

# Or transfer to device and install manually
```

### Test the Release

1. Install APK on a test device
2. Create a book
3. Add chapters  
4. Test the reader
5. Verify data persists after app restart

## Troubleshooting

### Build Fails

Check the workflow logs in the Actions tab. Common issues:
- Test failures - Fix code and retry
- Signing errors - Verify secrets are set correctly
- Network issues - Retry the workflow

### Keystore Issues

If you lose your keystore:
- You cannot update the existing app on Play Store
- You must create a new app listing with a new package name
- **Always back up your keystore!**

## Next Steps After MVP Release

1. **Gather Feedback**: Share the APK with testers
2. **Iterate**: Implement missing features based on feedback
3. **v1.0 Release**: When ready, tag `v1.0.0` for the full MVP
4. **Play Store**: Prepare for Play Store submission
   - Create Play Store listing
   - Add screenshots
   - Write description
   - Set up in-app updates

## Version History

- **v0.1.0** (Alpha) - Initial MVP implementation
  - Library management
  - Book creation
  - Reader with sample content
  - Local database persistence

## Resources

- [REQUIREMENTS_MVP.md](docs/REQUIREMENTS_MVP.md) - MVP requirements
- [MVP_IMPLEMENTATION.md](docs/MVP_IMPLEMENTATION.md) - Implementation details
- [ROADMAP.md](docs/ROADMAP.md) - Product roadmap
- [SIGNING.md](SIGNING.md) - Detailed signing setup guide

---

**Ready to release?** Merge this PR and push the `v0.1.0` tag!
