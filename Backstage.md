

sudo apt-get install -y python3 g++ build-essential docker.io git


# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 20

# Yarn
npm install -g corepack

npx @backstage/create-app@latest

### Github Oauth Secret erstellen

https://github.com/settings/applications/new

GitHub
* App:          Backstage Autoshop
* Client ID:    Ov23litUlgJs4WfH5vaz
* Secret   :    e95a581a19a329f7589244a401ce0d87884bd240


**Übertragen in app-config.yaml**

auth:
  # see https://backstage.io/docs/auth/ to learn about auth providers
  providers:
    # See https://backstage.io/docs/auth/guest/provider
    guest: {}
    github:
      development:
        clientId: Ov23litUlgJs4WfH5vaz
        clientSecret: e95a581a19a329f7589244a401ce0d87884bd240

