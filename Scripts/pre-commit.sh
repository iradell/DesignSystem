#!/bin/bash
# Pre-commit hook: Run SwiftLint on staged Swift files

# Path to SwiftLint
SWIFTLINT_BIN="/opt/homebrew/bin/swiftlint"

# Check SwiftLint exists
if [ ! -f "$SWIFTLINT_BIN" ]; then
    echo "SwiftLint not installed. Install via Homebrew: brew install swiftlint"
    exit 1
fi

# Get all staged Swift files
STAGED_SWIFT_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.swift$')

# Exit if no Swift files staged
if [ -z "$STAGED_SWIFT_FILES" ]; then
    exit 0
fi

PASS=true
for file in $STAGED_SWIFT_FILES; do
    # Run SwiftLint on each file
    "$SWIFTLINT_BIN" lint --strict --quiet "$file"
    if [ $? -ne 0 ]; then
        PASS=false
    fi
done

if ! $PASS; then
    echo "SwiftLint violations detected. Commit aborted."
    exit 1
fi

exit 0
