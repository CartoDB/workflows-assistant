---
name: carto-cli-install
description: Step-by-step instructions for installing the CARTO CLI from source
---

# CARTO CLI Installation Guide

This skill provides detailed instructions for installing the `carto` CLI from source. The CLI is required for the workflows-assistant to interact with CARTO's platform.

## Prerequisites

Before starting installation, verify the user has:

1. **Git** - For cloning repositories
2. **Node.js 18+** - Check with `node --version`
3. **nvm** - Node Version Manager (for cloud-native repo)
4. **Corepack** - For Yarn package management
5. **A CARTO account** - With access to an organization and at least one connection

---

## Installation Overview

The CARTO CLI requires building from two repositories:

| Repository | Branch | Purpose |
|------------|--------|---------|
| `CartoDB/cloud-native` | `feat/workflows-validation-for-assistant` | Provides `@cloud-native/workflows-engine` dependency |
| `CartoDB/carto-cli` | `feature/workflows-engine-validation` | The CLI itself |

**Recommended installation directory**: A parent folder where both repos can be cloned side-by-side (e.g., `~/Projects/carto/`).

---

## Step 1: Clone and Build cloud-native

This repository provides the workflows-engine package that the CLI depends on.

```bash
# Clone with the specific branch
git clone \
  -b feat/workflows-validation-for-assistant \
  https://github.com/CartoDB/cloud-native.git

cd cloud-native
```

### Install Dependencies

```bash
# Use the correct Node version specified in the repo
nvm install && nvm use

# Enable Corepack for Yarn and install dependencies
corepack enable
yarn install
```

**Expected time**: 2-5 minutes depending on network speed.

**Common issues**:
- If `nvm` is not found, the user needs to install it first: https://github.com/nvm-sh/nvm
- If `corepack enable` fails, try with sudo or ensure Node 16.9+ is installed

After completion, return to the parent directory:

```bash
cd ..
```

---

## Step 2: Clone and Build carto-cli

```bash
# Clone with the specific branch
git clone \
  -b feature/workflows-engine-validation \
  https://github.com/CartoDB/carto-cli.git

cd carto-cli
```

### Link the workflows-engine

The CLI needs to know where the cloud-native repo is located to link the workflows-engine package:

```bash
# Replace /path/to/cloud-native with the ACTUAL absolute path
./scripts/setup-engine.sh /path/to/cloud-native
```

**Example with actual paths**:
```bash
# If cloud-native is at ~/Projects/carto/cloud-native
./scripts/setup-engine.sh ~/Projects/carto/cloud-native

# Or using absolute path
./scripts/setup-engine.sh /Users/username/Projects/carto/cloud-native
```

### Build the CLI

```bash
npm install
npm run build
npm run bundle
```

**Expected output**: A bundled CLI executable at `bundle/carto`.

---

## Step 3: Make the CLI Available Globally

Choose ONE of these options:

### Option A: Symlink to /usr/local/bin (system-wide)

```bash
# May require sudo on some systems
sudo ln -s $(pwd)/bundle/carto /usr/local/bin/carto
```

### Option B: Symlink to ~/.local/bin (user-level)

```bash
# Ensure ~/.local/bin exists and is in PATH
mkdir -p ~/.local/bin
ln -s $(pwd)/bundle/carto ~/.local/bin/carto
```

### Option C: Add to PATH temporarily (for testing)

```bash
export PATH="$(pwd)/bundle:$PATH"
```

---

## Step 4: Verify Installation

```bash
# Check CLI is accessible
which carto

# Check version
carto --version

# Verify help works
carto --help
```

**Expected output**: The path to the carto executable and version info.

---

## Step 5: Authenticate

```bash
# Login (opens browser)
carto auth login

# Verify authentication
carto auth status
```

**Important**: The `carto auth login` command will open a browser window for OAuth authentication.

---

## Troubleshooting

### Command not found: carto

**Cause**: CLI not in PATH or symlink not created correctly.

**Solutions**:
1. Verify the symlink exists: `ls -la /usr/local/bin/carto` or `ls -la ~/.local/bin/carto`
2. Check PATH includes the directory: `echo $PATH`
3. If using Option B, ensure `~/.local/bin` is in your shell profile

### setup-engine.sh fails

**Cause**: Incorrect path to cloud-native repository.

**Solutions**:
1. Use absolute path, not relative
2. Verify cloud-native was cloned and built successfully
3. Check the path points to the root of the cloud-native repo (not a subdirectory)

### npm run build fails

**Cause**: Dependencies not properly installed or Node version mismatch.

**Solutions**:
1. Delete `node_modules` and run `npm install` again
2. Check Node version: `node --version` (should be 18+)
3. Ensure setup-engine.sh completed successfully first

### Authentication fails

**Cause**: Token expired or browser issue.

**Solutions**:
1. Try `carto auth logout` then `carto auth login` again
2. Check network connectivity
3. Try a different browser if OAuth page doesn't load

---

## Quick Reference

| Step | Command | Working Directory |
|------|---------|-------------------|
| Clone cloud-native | `git clone -b feat/workflows-validation-for-assistant https://github.com/CartoDB/cloud-native.git` | Parent folder |
| Build cloud-native | `nvm install && nvm use && corepack enable && yarn install` | cloud-native/ |
| Clone carto-cli | `git clone -b feature/workflows-engine-validation https://github.com/CartoDB/carto-cli.git` | Parent folder |
| Link engine | `./scripts/setup-engine.sh /path/to/cloud-native` | carto-cli/ |
| Build CLI | `npm install && npm run build && npm run bundle` | carto-cli/ |
| Create symlink | `sudo ln -s $(pwd)/bundle/carto /usr/local/bin/carto` | carto-cli/ |
| Authenticate | `carto auth login && carto auth status` | Anywhere |

---

## After Installation

Once the CLI is installed and authenticated, the agent can:

1. Load the `carto-cli` skill for command reference
2. Use `carto connections list` to discover available data sources
3. Use `carto workflows validate` to validate workflow diagrams
4. Use `carto workflows to-sql` to generate executable SQL

---

*This skill guides installation only. For CLI usage, load the `carto-cli` skill.*
