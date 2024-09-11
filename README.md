# 🚀 npm to pnpm Converter

This script automates the process of converting npm projects to pnpm within a specified directory.

## 📋 Features

- 🔍 Recursively searches for npm projects (identified by `package-lock.json` files)
- 🔄 Converts npm projects to pnpm
- 📦 Installs dependencies using pnpm
- 🔙 Automatic rollback in case of failures
- 📊 Provides a summary of the conversion process

## 🛠️ Prerequisites

- Bash shell
- npm
- pnpm

## 🚀 Usage

1. Clone this repository:

   ```
   git clone https://github.com/yourusername/npm-to-pnpm-converter.git
   ```

2. Navigate to the script directory:

   ```
   cd npm-to-pnpm-converter
   ```

3. Make the script executable:

   ```
   chmod +x npmtopnpm.sh
   ```

4. Run the script, specifying the target directory:
   ```
   ./npmtopnpm.sh /path/to/your/projects
   ```

## 📝 Log File

The script generates a log file named `pnpm_conversion.log` in the current directory. This file contains detailed information about the conversion process.

## 🚨 Error Handling

If an error occurs during the conversion process for a project, the script will:

- Log the error
- Attempt to restore the project to its original state
- Continue with the next project

## 📊 Summary

After processing all projects, the script provides a summary including:

- Total number of projects processed
- Number of successful conversions
- Number of failed conversions

## ⚠️ Caution

Always backup your projects before running this script. While it includes rollback functionality, it's always better to have a separate backup.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/yourusername/npm-to-pnpm-converter/issues).

## 📜 License

This project is [MIT](https://choosealicense.com/licenses/mit/) licensed.
