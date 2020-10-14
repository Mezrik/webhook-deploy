# Webhook deploy script

A simple script for Github Webhook deploy. It's not recommended to use for every opportunity.
(My use-case: VPS is accessible only through university VPN, therefore this is the only simple solution I can think of.)

## Usage

1. Setup a webhook for your repository.

   - **Payload URL** - this is where your Node.js server will be hosted (this script)
   - **Content type** - set this to "application/json"
   - **Secret** - generate somewhere secure secret key and paste it here (later it will be also needed in .env file for this script)
   - **Which events would you like to trigger this webhook?** - select the triggers which should submit webhook delivery
   - **Active** - select this checkbox

2. Clone this repository to your server.
3. Run `npm install`.
4. Create .env file in root directory and define variables required in .env.schema
   | Variable | Description |
   | ----------- | ----------- |
   | PORT | Port on which the Node.js server will run |
   | WEBHOOK_SECRET | Secret for your webhook |
   | REPOSITORY_LOCATION | The location of your cloned repository (relative or absolute). Dont forget to add backslash to the end of path (or it will point to the directory and not its contents). For example "../my-project/" |
   | BUILD_SCRIPT | NPM script used to build your application |
   | REMOTE_ORIGIN | Name of the remote which will be pulled (usually "origin") |

5. Run `npm run start`, this will run the process manager pm2 https://pm2.keymetrics.io/
6. OPTIONAL: Add cron job which will run this Node.js server after your machine is rebooted.
   - Run `crontab -e`
   - Add `@reboot /{path to this script root directory}/start.sh`
