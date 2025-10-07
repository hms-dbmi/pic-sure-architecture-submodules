#!/bin/bash
set -e

echo "================================"
echo "Building PIC-SURE Application Stack"
echo "================================"

# Build all Maven projects
echo "Building Maven projects..."
mvn clean install

# Build Frontend
if [ -d "PIC-SURE-Frontend" ]; then
    echo "Building Frontend..."
    cd PIC-SURE-Frontend
    pnpm install
    pnpm build
    cd ..
fi

echo "================================"
echo "Build complete!"
echo "================================"