# PIC-SURE Application Stack

A unified build and deployment management system for the complete PIC-SURE application stack. This root project aggregates all PIC-SURE components using Git submodules and Maven multi-module architecture.

## Overview

This repository provides centralized management for:

- **pic-sure** - Core PIC-SURE API
- **pic-sure-auth-microapp** - Authentication and authorization microservice
- **PIC-SURE-Frontend** - User interface application
- **pic-sure-hpds** - High Performance Data Store
- **picsure-dictionary** - Data dictionary service

## Key Features

- **Git Agnostic** - Works with GitHub, GitLab, Bitbucket, or any Git hosting platform
- **Version Control** - Pin specific versions/commits of each component via Git submodules
- **Portable** - Same structure and build process from sandbox to production
- **Single Command Build** - Build all components with one command
- **Environment Flexibility** - Manage different configurations via Git branches

## Prerequisites

- Java SDK 25
- Maven 3.6+
- Node.js and pnpm (for frontend)
- Git

## Quick Start

### First Time Setup

Clone the repository with all submodules:
```bash
git clone --recurse-submodules <repository-url>
cd pic-sure-application-stack
```
If you already cloned without submodules:
```bash
git submodule update --init --recursive
```
### Build All Components
```bash
./build.sh
```
This will:
1. Initialize and update all submodules to their tracked versions
2. Build all Maven projects
3. Build the frontend application

## Version Management

### Understanding Submodule Versions

Each submodule is pinned to a specific commit in the parent repository. This ensures reproducible builds across environments.

View current submodule versions:
```bash
git submodule status
```
### Updating Component Versions

To update a specific component to a new version:
```bash
# Navigate to the submodule
cd pic-sure

# Fetch latest changes
git fetch --tags

# Checkout desired version (tag, branch, or commit)
git checkout v2.2.0

# Return to root and commit the change
cd ..
git add pic-sure
git commit -m "Update pic-sure to v2.2.0"
git push
```
### Pulling Version Updates

When someone else updates submodule versions:
```bash
git pull
git submodule update --recursive
```
## Environment Management

### Multiple Environments via Branches

Manage different environment configurations using Git branches:
```bash
# Production environment
git checkout production
git submodule update --recursive
./build.sh

# Development environment
git checkout develop
git submodule update --recursive
./build.sh

# Sandbox environment
git checkout sandbox
git submodule update --recursive
./build.sh
```
Each branch can track different versions of each component, making it easy to promote changes through environments.

## Advanced Usage

### Build Specific Components

Build only Maven projects:
```bash
mvn clean install
```
Build a specific Maven module:
```bash
mvn clean install -pl pic-sure-hpds
```
Build with Maven options:
```bash
mvn clean install -DskipTests
```
### Update Submodules to Latest

Update all submodules to the latest commit on their tracked branch:
```bash
git submodule update --remote
git add .
git commit -m "Update all submodules to latest"
```
### Working on Submodule Development

To make changes within a submodule:
```bash
cd pic-sure
git checkout -b feature/my-feature
# Make changes, commit, push to submodule repository
cd ..
git add pic-sure
git commit -m "Update pic-sure to feature branch"
```
## Project Structure
```

pic-sure-application-stack/
├── .gitmodules              # Submodule configuration
├── pom.xml                  # Root Maven aggregator POM
├── build.sh                 # Unified build script
├── README.md                # This file
├── pic-sure/                # Core API (submodule)
├── pic-sure-auth-microapp/  # Auth service (submodule)
├── PIC-SURE-Frontend/       # Frontend (submodule)
├── pic-sure-hpds/           # HPDS (submodule)
└── picsure-dictionary/      # Dictionary (submodule)
```
## Platform Portability

This project is Git agnostic and works with any Git hosting platform:

- GitHub
- GitLab
- Bitbucket
- Azure DevOps
- Self-hosted Git servers

No code changes required when migrating between platforms. Simply update the URLs in `.gitmodules`.

## Troubleshooting

### Submodules are empty after clone
```bash
git submodule update --init --recursive
```
### Submodules are on detached HEAD

This is normal. Submodules are pinned to specific commits. To work on a submodule, checkout a branch within it.

### Build fails due to version mismatch

Ensure submodules are updated:
```bash
git submodule update --recursive
```
### Changes in submodule not reflected

After making changes in a submodule:
```bash
cd <submodule-directory>
git add .
git commit -m "Changes"
git push
cd ..
git add <submodule-directory>
git commit -m "Update submodule reference"
```
## Contributing

When contributing changes:

1. Make changes in the appropriate submodule repository
2. Update the parent repository to reference the new commit
3. Test the build with `./build.sh`
4. Submit pull request to the parent repository

## License

Refer to individual component repositories for licensing information.
```
