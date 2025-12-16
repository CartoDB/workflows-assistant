# CARTO Workflows Assistant

An AI-powered assistant for building CARTO Workflows using [OpenCode](https://opencode.ai) and the `carto` CLI.

## Prerequisites

- A CARTO account with access to an organization and at least one connection

## Setup

### 1. Install OpenCode

Follow the instructions at https://opencode.ai to install OpenCode. In macOS, should be enough to run:

```shell
brew install opencode
```

### 2. Configure OpenCode

Create `~/.config/opencode/opencode.jsonc` with the following content:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "google-vertex-anthropic": {
      "models": {},
      "options": {
        "project": "carto-ai-staff-usage",
        "location": "us-east5"
      }
    }
  }
}
```

### 3. Install the CARTO CLI

The CLI requires the `@cloud-native/workflows-engine` package from the `CartoDB/cloud-native` repository.

```bash
# Clone the cloud-native repository (required dependency)
git clone \
  -b feat/workflows-validation-for-assistant \
  https://github.com/CartoDB/cloud-native.git

# Install cloud-native dependencies (required for building workflows-engine)
cd cloud-native
# Review the cloud-native README
nvm install && nvm use
corepack enable && yarn install
cd ..

# Clone the data-ps-team repository
git clone \
  -b feature/workflows-engine-cli \
  https://github.com/CartoDB/data-ps-team.git

# Specify the custom path to cloud-native to link workflows-engine
cd data-ps-team/code/carto-cli
./scripts/setup-engine.sh /path/to/cloud-native

# Build the CLI
npm install
npm run build
npm run bundle
```

The bundled CLI will be available at `bundle/carto`. Add it to your PATH or create a symlink:

```bash
# Option A: Create symlink to make 'carto' available globally, you may need sudo
ln -s $(pwd)/bundle/carto /usr/local/bin/carto

# Option B: symlink to the local bin folder if you have it configured
ln -s $(pwd)/bundle/carto $HOME/.local/bin/carto
```

### 4. Clone this repository

```bash
git clone https://github.com/CartoDB/workflows-assistant.git
cd workflows-assistant
```

### 5. Configure environment variables

Copy the `.env.template` file to `.env` and fill in the required values:

```bash
cp .env.template .env
# Edit .env with your configuration values
```

Before using the assistant, source the environment file to load the variables:

```bash
source .env
```

### 6. Authenticate with CARTO

```bash
carto auth login
carto auth status  # verify authentication
```

## Usage

Start OpenCode in the repository directory:

```bash
cd workflows-assistant
opencode
```

Press `Tab` to cycle through agents:
- **Build** (default) - General coding assistant
- **Plan** - Planning mode
- **Workflows-Assistant** - The CARTO Workflows assistant

Select **Workflows-Assistant** to test the workflows agent.


## Contributing

If you test this tool and run into any issues, missing functionality, or come up with feedback, please create an issue in [this GitHub repository](https://github.com/CartoDB/workflows-assistant/issues).

## Troubleshooting

Some things that can help you diagnose errors if something is not working:

**Authentication issues**
```bash
carto auth logout
carto auth login
```

**Check available connections**
```bash
carto connections list
```

**Verify CLI is working**
```bash
carto workflows-engine components list --provider bigquery
```
