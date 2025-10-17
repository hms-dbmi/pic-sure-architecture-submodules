# PIC-SURE Submodules and Build Management

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
- **Artifact Management** - Deploy to local Nexus or any Maven repository

## Prerequisites

- Java SDK 25
- Maven 3.6+
- Node.js and pnpm (for frontend)
- Git
- Docker and Docker Compose (for Nexus)

## Quick Start

### First Time Setup

Clone the repository with all submodules:
```bash
git clone --recurse-submodules https://github.com/hms-dbmi/pic-sure-architecture-submodules.git
cd pic-sure-architecture-submodules
```
If you already cloned without submodules:
```bash
git submodule update --init --recursive
```
### Build All Components

```bash
make build
# or
./build.sh
```


This will:
1. Initialize and update all submodules to their tracked versions
2. Build all Maven projects (skipping tests)
3. Build the frontend application

## Version Management

### Understanding Submodule Versions

Each submodule is pinned to a specific commit in the parent repository. This ensures reproducible builds across environments.

View current submodule versions:

```shell script
make status
```


This shows:
- **Staged (Makefile)** - Version defined in Makefile (what you want)
- **Current (Checked Out)** - Actually checked out version (what you have)

### Updating Component Versions

#### Using Makefile (Recommended)

1. Edit version in `Makefile`:
```makefile
PIC_SURE_VERSION := v2.21.0
```


2. Checkout the specified versions:
```shell script
make checkout-versions
```


3. Stage and commit the version update:
```shell script
make update-versions
   git commit -m "Update pic-sure to v2.21.0"
   git push
```


#### Manual Method

```shell script
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

```shell script
git pull
git submodule update --recursive
```


## Artifact Deployment

### Local Nexus (Sandbox)

Deploy artifacts to a local Nexus repository for sandbox testing:

#### 1. Start Nexus

```shell script
make nexus-start
```


Wait ~2 minutes for Nexus to start, then access at http://localhost:8081

#### 2. First Time Setup

Get the initial admin password:

```shell script
docker exec picsure-nexus cat /nexus-data/admin.password
```


Login to Nexus and:
1. Change the admin password
2. Go to **Settings** → **Repositories** → **maven-snapshots**
3. Set **Deployment policy** to **Allow redeploy**
4. Click **Save**

#### 3. Configure Credentials

Create `.env` file:

```shell script
cp .env.example .env
```


Update `.env` with your Nexus password:

```shell script
NEXUS_USERNAME=admin
NEXUS_PASSWORD=your-new-password
MAVEN_RELEASES_REPO=http://localhost:8081/repository/maven-releases/
MAVEN_SNAPSHOTS_REPO=http://localhost:8081/repository/maven-snapshots/
```


#### 4. Deploy Artifacts

```shell script
make deploy-nexus
```


View deployed artifacts at http://localhost:8081 → Browse → maven-snapshots

#### 5. Stop Nexus

```shell script
make nexus-stop
```


### GitHub Packages

To deploy to GitHub Packages instead:

1. Update `.env`:
```shell script
GITHUB_USERNAME=your-username
   GITHUB_TOKEN=ghp_your_token
   MAVEN_RELEASES_REPO=https://maven.pkg.github.com/hms-dbmi/pic-sure-architecture-submodules
   MAVEN_SNAPSHOTS_REPO=https://maven.pkg.github.com/hms-dbmi/pic-sure-architecture-submodules
```


2. Deploy:
```shell script
make deploy-artifacts
```


### Other Maven Repositories

Simply update the repository URLs in `.env` and credentials in `maven-settings.xml`.

## Environment Management

### Multiple Environments via Branches

Manage different environment configurations using Git branches:

```shell script
# Production environment
git checkout production
git submodule update --recursive
make build

# Development environment
git checkout develop
git submodule update --recursive
make build

# Sandbox environment
git checkout sandbox
git submodule update --recursive
make build
```


Each branch can track different versions of each component, making it easy to promote changes through environments.

## Makefile Commands

### Building

- `make help` - Show all available commands and current versions
- `make build` - Build all components
- `make clean` - Clean all build artifacts
- `make init` - Initialize all submodules

### Version Management

- `make status` - Show current vs staged submodule versions
- `make status-help` - Detailed help on interpreting status output
- `make checkout-versions` - Checkout all submodules to versions defined in Makefile
- `make update-versions` - Checkout and stage version changes for commit

### Artifact Deployment

- `make nexus-start` - Start local Nexus container
- `make nexus-stop` - Stop local Nexus container
- `make nexus-test` - Test Nexus connection and credentials
- `make deploy-nexus` - Deploy artifacts to local Nexus
- `make deploy-artifacts` - Deploy artifacts to configured repository (from .env)

## Advanced Usage

### Build Specific Components

Build only Maven projects:

```shell script
mvn clean install -DskipTests
```


Build a specific Maven module:

```shell script
mvn clean install -DskipTests -pl pic-sure-hpds
```


Build with tests:

```shell script
mvn clean install
```


### Working on Submodule Development

To make changes within a submodule:

```shell script
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
├── .env.example             # Example environment configuration
├── pom.xml                  # Root Maven aggregator POM
├── Makefile                 # Build and deployment automation
├── build.sh                 # Build script
├── maven-settings.xml       # Maven authentication configuration
├── docker-compose.nexus.yml # Nexus repository container
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

No code changes required when migrating between platforms. Simply update the URLs in `.gitmodules` and `.env`.

## Troubleshooting

### Submodules are empty after clone

```shell script
git submodule update --init --recursive
```


### Submodules are on detached HEAD

This is normal. Submodules are pinned to specific commits. To work on a submodule, checkout a branch within it.

### Build fails due to version mismatch

Ensure submodules are updated:

```shell script
git submodule update --recursive
```


### Changes in submodule not reflected

After making changes in a submodule:

```shell script
cd <submodule-directory>
git add .
git commit -m "Changes"
git push
cd ..
git add <submodule-directory>
git commit -m "Update submodule reference"
```


### Nexus deployment fails with 403 Forbidden

1. Verify credentials in `.env` are correct
2. Ensure **Allow redeploy** is enabled in Nexus maven-snapshots repository
3. Test connection: `make nexus-test`

### Nexus deployment fails with 401 Unauthorized

1. Check that Nexus is running: `docker ps | grep nexus`
2. Verify credentials: `make nexus-test`
3. Ensure password in `.env` matches Nexus admin password

## Contributing

When contributing changes:

1. Make changes in the appropriate submodule repository
2. Update the parent repository to reference the new commit
3. Test the build with `make build`
4. Submit pull request to the parent repository
