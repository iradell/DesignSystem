#!/bin/bash
echo "Pre-commit hook triggered!"

SWIFTLINT_BIN="/opt/homebrew/bin/swiftlint"

# Check SwiftLint exists
if [ ! -f "$SWIFTLINT_BIN" ]; then
    echo "SwiftLint not installed. Install via Homebrew: brew install swiftlint"
    exit 1
fi

# Get all staged Swift files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.swift$')

if [ -z "$STAGED_FILES" ]; then
    echo "No Swift files staged. Skipping SwiftLint."
    exit 0
fi

PASS=true

# Create temporary directory for staged versions of files
TMP_DIR=$(mktemp -d)

for FILE in $STAGED_FILES; do
    mkdir -p "$TMP_DIR/$(dirname "$FILE")"
    git show ":$FILE" > "$TMP_DIR/$FILE"
done

# Run SwiftLint on the staged versions
cd "$TMP_DIR" || exit 1
"$SWIFTLINT_BIN" lint --strict
if [ $? -ne 0 ]; then
    PASS=false
fi
cd - >/dev/null || exit 1

# Clean up
rm -rf "$TMP_DIR"

if ! $PASS; then
    echo "SwiftLint violations detected. Commit aborted."
    exit 1
fi

exit 0
