#!/bin/bash

# Flutter Clean Architecture Feature Generator
# Compatible with macOS and Unix-like systems

# Function to convert to snake_case
to_snake_case() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '_'
}

# Check if feature name is provided as an argument
if [ $# -eq 0 ]; then
    read -p "Enter the feature name (in snake_case): " FEATURE_NAME
else
    FEATURE_NAME=$1
fi

# Normalize feature name
FEATURE_NAME=$(to_snake_case "$FEATURE_NAME")

# Base feature directory
BASE_DIR="./lib/features/${FEATURE_NAME}"

# Create main feature directory
mkdir -p "$BASE_DIR"

# Create layer directories
LAYERS=("data" "domain" "presentation")
for layer in "${LAYERS[@]}"; do
    mkdir -p "$BASE_DIR/$layer"
done

# Data Layer Structure
DATA_SUBFOLDERS=("data_sources" "models" "repositories")
for subfolder in "${DATA_SUBFOLDERS[@]}"; do
    mkdir -p "$BASE_DIR/data/$subfolder"
done

# Create data layer files
DATA_FILES=(
    "data_sources/${FEATURE_NAME}_local_data_source.dart"
    "data_sources/${FEATURE_NAME}_remote_data_source.dart"
    "models/${FEATURE_NAME}_model.dart"
    "repositories/${FEATURE_NAME}_repository_impl.dart"
)
for file in "${DATA_FILES[@]}"; do
    touch "$BASE_DIR/data/$file"
done

# Domain Layer Structure
DOMAIN_SUBFOLDERS=("entities" "repositories" "use_cases")
for subfolder in "${DOMAIN_SUBFOLDERS[@]}"; do
    mkdir -p "$BASE_DIR/domain/$subfolder"
done

# Create domain layer files
DOMAIN_FILES=(
    "repositories/${FEATURE_NAME}_repository.dart"
)
for file in "${DOMAIN_FILES[@]}"; do
    touch "$BASE_DIR/domain/$file"
done

# Presentation Layer Structure
PRESENTATION_SUBFOLDERS=("blocs" "pages" "widgets")
for subfolder in "${PRESENTATION_SUBFOLDERS[@]}"; do
    mkdir -p "$BASE_DIR/presentation/$subfolder"
done

# Create presentation layer files
PRESENTATION_FILES=(
    "pages/${FEATURE_NAME}_page.dart"
    "widgets/${FEATURE_NAME}_list_widget.dart"
)
for file in "${PRESENTATION_FILES[@]}"; do
    touch "$BASE_DIR/presentation/$file"
done

# Output success message
echo -e "\033[0;32mClean Architecture feature structure for '$FEATURE_NAME' has been created successfully!\033[0m"