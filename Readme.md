# ZATCA SDK Installation Guide for ARM-based MacBooks (M1/M2)

**Current SDK Version: 3.4.0**

## Requirements
- macOS Ventura or newer
- ZATCA SDK ZIP file from [official portal](https://zatca.gov.sa/)
- Homebrew package manager

---

## Installation Steps

### 1. Directory Setup
1. Create working directory:
   ```sh
   mkdir -p ~/Documents/ZATCA_SDK
   ```
2. Extract SDK ZIP:
   ```sh
   unzip zatca-einvoicing-sdk-*.zip -d ~/Documents/ZATCA_SDK
   ```

### 2. Script Configuration
1. Replace default install script:
   ```sh
   Replace install.sh with the one in this repo
   ```
2. Set permissions:
   ```sh
   chmod +x ~/Documents/ZATCA_SDK/install.sh
   chmod +x ~/Documents/ZATCA_SDK/Apps/zatca-einvoicing-sdk-*.jar
   ```

### 3. Java Setup (ARM-optimized)
1. Install JDK 11:
   ```sh
   arch -arm64 brew install openjdk@11
   ```
2. Configure environment:
   ```sh
   echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

### 4. Symbolic Linking (Critical Step) 🔗
```sh
cd ~/Documents/ZATCA_SDK/Apps
ln -sf zatca-einvoicing-sdk-*.jar zatca-einvoicing-sdk.jar
```

**Why This Matters**:  
- Maintains compatibility between SDK versions  
- Prevents "JAR not found" errors  
- Simplifies future updates  

### 5. Environment Configuration
1. Create global config:
   ```sh
   cat <<EOF > ~/Documents/ZATCA_SDK/global.json
   {
     "sdk": {
       "version": "latest",
       "rollForward": "latestPatch"
     }
   }
   EOF
   ```
2. Create CLI alias:
   ```sh
   echo 'alias fatoora="java -jar \$HOME/Documents/ZATCA_SDK/Apps/zatca-einvoicing-sdk.jar"' >> ~/.zshrc
   source ~/.zshrc
   ```

---

## Validation Tests
1. Verify Java:
   ```sh
   java -version # Should show OpenJDK 11.0.x
   ```
2. Test CLI:
   ```sh
   fatoora --help
   ```
3. Full XML validation:
   ```sh
   fatoora validatexml -f ~/Documents/ZATCA_SDK/Data/Samples/Standard/Invoice/Standard_Invoice.xml
   ```

---

## Troubleshooting
| Issue | Solution |
|-------|----------|
| `Command not found` | Run `source ~/.zshrc` |
| `Permission denied` | `chmod +x ~/Documents/ZATCA_SDK/Apps/*.jar` |
| `JAR file missing` | Verify symbolic link exists |
| `Java errors` | Reinstall with `arch -arm64 brew reinstall openjdk@11` |

---

## Alternative Implementation
For persistent issues, use the **SDK-free solution**:
```sh
# For Frappe/ERPNext users
bench get-app https://github.com/ERPGulf/zatca_erpgulf
bench --site yoursitename install-app zatca_erpgulf
```

**Benefits**:  
✅ No Java dependencies  
✅ Direct API integration  
✅ M1/M2 native support  

---

[Official Documentation](https://zatca.gov.sa/) | [Support Forum](https://zatca1.discourse.group/)  
*Verified on macOS Sonoma 14.4 | March 2025 Update*
