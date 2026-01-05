# Ollama Integration - Quick Start Guide

**For Testing the New Feature**

---

## 🚀 Setup (One-Time)

### 1. Install Ollama (if not already installed)
```bash
# macOS/Linux
curl https://ollama.ai/install.sh | sh

# Windows
# Download from https://ollama.ai/download
```

### 2. Pull a Model
```bash
# Recommended for testing
ollama pull llama3.2

# Alternative (smaller, faster)
ollama pull phi4
```

### 3. Start Ollama Server
```bash
ollama serve
# Server runs at http://localhost:11434
```

---

## 📱 App Testing

### First-Time Configuration

1. **Open the App**
   - Navigate to Settings (gear icon)

2. **Find Ollama Configuration**
   - Scroll down to "Ollama Configuration" section
   - Status shows: "Not Configured"

3. **Configure Server**
   - Server URL is pre-filled: `http://localhost:11434`
   - Tap "Test Connection"
   - Wait for "Connected" status

4. **Select Model**
   - Model dropdown appears
   - Select "llama3.2" (or your pulled model)
   - Configuration auto-saves

### Generate Content with Ollama

1. **Create New Book**
   - Go back to Library
   - Tap + button
   - Fill in description or purpose (leave title empty)
   - Tap "Create"

2. **Choose Generation Mode**
   - Dialog appears: "Generate Book Title"
   - Two options shown:
     - 📋 Paste from ChatGPT (traditional)
     - 🤖 Ollama (Connected) READY badge ← Select this

3. **Watch Streaming Generation**
   - Loading dialog appears
   - Shows "Using: llama3.2 (local)"
   - Content streams in real-time
   - Wait for completion

4. **Book Created**
   - Title generated automatically
   - Book opens with generated title

---

## 🧪 Test Scenarios

### Scenario 1: Happy Path (Ollama Works)
```
✓ Ollama running
✓ Model available
✓ Generation succeeds
✓ Book created
```

### Scenario 2: Smart Fallback (Ollama Offline)
```
1. Stop Ollama server (Ctrl+C in terminal)
2. Try to generate
3. Select Ollama mode
4. Notice appears: "Ollama server unreachable. Falling back to copy-paste mode."
5. Copy-paste dialog automatically opens
6. Continue with ChatGPT workflow
```

### Scenario 3: Mode Persistence
```
1. Generate once with Ollama
2. Close app
3. Reopen app
4. Try to generate again
5. Ollama mode is pre-selected ✓
```

### Scenario 4: Reconnection
```
1. Start with Ollama offline
2. Status shows "Offline" in Settings
3. Start Ollama server
4. Tap "Refresh" button in Settings
5. Status changes to "Connected" ✓
```

---

## 🔍 What to Look For

### In Settings
- ✅ Ollama Configuration section visible
- ✅ Connection status updates correctly
- ✅ Model dropdown populates
- ✅ Test Connection button works
- ✅ Configuration persists on app restart

### In Generation
- ✅ Mode selector shows both options
- ✅ Ollama status badge correct (READY/OFFLINE/SETUP REQUIRED)
- ✅ Streaming dialog shows content in real-time
- ✅ Cancel button works during generation
- ✅ Fallback notice appears when Ollama unavailable
- ✅ Generated title appears in book

### Edge Cases
- ✅ App handles Ollama going offline during generation
- ✅ Error messages are clear and actionable
- ✅ No crashes or hangs
- ✅ UI remains responsive during generation

---

## 🐛 Known Limitations

1. **Single Model Selection**
   - Can only use one model at a time
   - Must change in Settings to switch

2. **No Model Management**
   - Can't pull new models from app
   - Must use Ollama CLI

3. **No Generation History**
   - Can't view previous generations
   - Post-MVP feature

4. **Fixed Timeout**
   - 30-second timeout for operations
   - May be too short for large models

---

## 📝 Reporting Issues

If you encounter issues, note:
- Device/OS version
- Ollama version (`ollama --version`)
- Model used
- Error messages
- Steps to reproduce

---

## 🎉 Success Indicators

You know it's working when:
- ✅ Settings show "Connected" status
- ✅ Model dropdown has entries
- ✅ Generation streams content in real-time
- ✅ Fallback notice appears when Ollama is offline
- ✅ Generated titles make sense
- ✅ Mode preference persists

---

## 🚫 Troubleshooting

### "Connection failed"
- Check Ollama is running: `ollama ps`
- Check port 11434 is not blocked
- Try: `curl http://localhost:11434/api/tags`

### "Model not found"
- Pull the model: `ollama pull llama3.2`
- Check available models: `ollama list`
- Refresh app settings

### "Generation hangs"
- Check Ollama logs
- Model may be loading (first time slow)
- Try smaller model (phi4)

### "No streaming"
- This is expected for fast generation
- Try longer prompts
- Larger models stream more noticeably

---

## ⚡ Tips for Best Experience

1. **Use Appropriate Models**
   - Small models (<7B): Fast, good for titles
   - Large models (>13B): Slower, better quality

2. **Monitor System Resources**
   - LLMs use significant RAM
   - Ensure sufficient memory available

3. **Test Fallback Early**
   - Deliberately stop Ollama
   - Verify fallback works smoothly

4. **Check Logs**
   - Ollama logs: Terminal where `ollama serve` runs
   - App logs: Flutter console

---

**Ready to test!** Start with Scenario 1 (Happy Path) then try Scenario 2 (Smart Fallback).
