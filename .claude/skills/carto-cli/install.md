# CARTO CLI Installation

Step-by-step instructions for installing the `carto` CLI from source.

## Prerequisites

Before starting installation, verify:

1. **Git** - For cloning repositories
2. **Node.js 18+** - Check with `node --version`
3. **nvm** - Node Version Manager (for cloud-native repo)
4. **Corepack** - For Yarn package management
5. **A CARTO account** - With access to an organization and at least one connection

## Installation Overview

The CARTO CLI requires building from two repositories:

| Repository | Branch | Purpose |
|------------|--------|---------|
| `CartoDB/cloud-native` | `feat/workflows-validation-for-assistant` | Provides `@cloud-native/workflows-engine` dependency |
| `CartoDB/carto-cli` | `feature/workflows-engine-validation` | The CLI itself |

**Recommended**: Clone both repos in the same parent folder (e.g., `~/Projects/carto/`).

## Step 1: Clone and Build cloud-native

```bash
# Clone with the specific branch
git clone \
  -b feat/workflows-validation-for-assistant \
  https://github.com/CartoDB/cloud-native.git

cd cloud-native

# Use the correct Node version
nvm install && nvm use

# Enable Corepack for Yarn and install dependencies
corepack enable
yarn install
```

**Expected time**: 2-5 minutes depending on network speed.

**Common issues**:
- If `nvm` is not found, install it first: https://github.com/nvm-sh/nvm
- If `corepack enable` fails, try with sudo or ensure Node 16.9+ is installed

Return to the parent directory:

```bash
cd ..
```

## Step 2: Clone and Build carto-cli

```bash
# Clone with the specific branch
git clone \
  -b feature/workflows-engine-validation \
  https://github.com/CartoDB/carto-cli.git

cd carto-cli
```

### Link the workflows-engine

```bash
# Replace with the ACTUAL absolute path to cloud-native
./scripts/setup-engine.sh /path/to/cloud-native
```

**Example**:
```bash
./scripts/setup-engine.sh ~/Projects/carto/cloud-native
```

### Build the CLI

```bash
npm install
npm run build
npm run bundle
```

**Expected output**: A bundled CLI executable at `bundle/carto`.

## Step 3: Make CLI Available Globally

Choose ONE option:

### Option A: Symlink to /usr/local/bin (system-wide)

```bash
sudo ln -s $(pwd)/bundle/carto /usr/local/bin/carto
```

### Option B: Symlink to ~/.local/bin (user-level)

```bash
mkdir -p ~/.local/bin
ln -s $(pwd)/bundle/carto ~/.local/bin/carto
```

### Option C: Add to PATH temporarily

```bash
export PATH="$(pwd)/bundle:$PATH"
```

## Step 4: Verify Installation

```bash
which carto          # Check CLI is accessible
carto --version      # Check version
carto --help         # Verify help works
```

## Step 5: Authenticate

```bash
carto auth login     # Opens browser for OAuth
carto auth status    # Verify authentication
```

**Important**: The `carto auth login` command opens a browser window.

## Troubleshooting

### Command not found: carto

**Cause**: CLI not in PATH or symlink not created correctly.

**Solutions**:
1. Verify symlink exists: `ls -la /usr/local/bin/carto`
2. Check PATH: `echo $PATH`
3. If using Option B, ensure `~/.local/bin` is in your shell profile

### setup-engine.sh fails

**Cause**: Incorrect path to cloud-native repository.

**Solutions**:
1. Use absolute path, not relative
2. Verify cloud-native was cloned and built successfully
3. Check path points to the root of cloud-native repo

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
