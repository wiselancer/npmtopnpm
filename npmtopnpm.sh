#!/bin/bash

# Check if a directory argument is passed
if [ -z "$1" ]; then
    echo "❌ Usage: $0 <directory>"
    exit 1
fi

# Get the directory from the first argument
TARGET_DIR="$1"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory $TARGET_DIR does not exist."
    exit 1
fi

# Define log file
LOGFILE="pnpm_conversion.log"

# Function to log errors
log_error() {
    echo "❌ [ERROR] $1" | tee -a "$LOGFILE"
}

# Function to restore project if something goes wrong
restore_project() {
    project_dir=$1
    backup_dir=$2
    echo "🔄 Restoring original files in $project_dir" | tee -a "$LOGFILE"
    # Restore package-lock.json and node_modules from backup
    [ -f "$backup_dir/package-lock.json.bak" ] && mv "$backup_dir/package-lock.json.bak" "$project_dir/package-lock.json"
    [ -d "$backup_dir/node_modules.bak" ] && mv "$backup_dir/node_modules.bak" "$project_dir/node_modules"
}

# Navigate to the target directory
cd "$TARGET_DIR" || exit

echo "🔍 Searching for npm projects in $TARGET_DIR..." | tee -a "$LOGFILE"

# Find all projects with package-lock.json (which implies npm usage)
find . -name 'package-lock.json' -print0 | while IFS= read -r -d '' file; do
    project_dir=$(dirname "$file")
    
    # Check if the project directory still exists
    if [ ! -d "$project_dir" ]; then
        log_error "Project directory $project_dir no longer exists. Skipping..."
        continue
    fi
    
    echo "🚀 Converting project in $project_dir to pnpm..." | tee -a "$LOGFILE"
    
    backup_dir="$project_dir/.backup"
    mkdir -p "$backup_dir"

    # Backup package-lock.json and node_modules
    mv "$project_dir/package-lock.json" "$backup_dir/package-lock.json.bak"
    mv "$project_dir/node_modules" "$backup_dir/node_modules.bak" 2>/dev/null

    # Remove node_modules and install using pnpm
    cd "$project_dir" || continue
    echo "📦 Running pnpm install in $project_dir" | tee -a "$LOGFILE"

    if pnpm install; then
        echo "✅ pnpm install succeeded in $project_dir" | tee -a "$LOGFILE"
        # Clean up backups if successful
        rm -rf "$backup_dir"
    else
        log_error "pnpm install failed in $project_dir"
        # Restore the project if pnpm install fails
        restore_project "$project_dir" "$backup_dir"
    fi

    cd - || exit
done

echo "🎉 Conversion process completed. Check $LOGFILE for details."