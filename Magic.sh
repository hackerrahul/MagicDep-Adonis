#!/bin/sh

echo "MagicDep is Running!"

GIT_VERSION="$(git --version)"
if [ "$GIT_VERSION" != "command not found" ]; then
    echo "Git Found \n"

    sleep 1

    echo "Lets Check Node Installation \n"
    if which node > /dev/null
    then
        sleep 1
        echo "Node Is Detected successfully \n"
    else
        echo "Installing Node with NVM \n"
        {
            curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh -o install_nvm.sh
            bash install_nvm.sh

            export NVM_DIR="$HOME/.nvm" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

            nvm install --lts

        } &> /dev/null

        sleep 1
        if [ $? -eq 0 ]; then
            echo "Node Installed Successfully \n"
        else
            echo "Oh Crap! Error While Installing Node \n"
            exit 0
        fi

    fi

    echo "Now, Lets Check PM2 Process Manager \n"


    if which pm2 > /dev/null
    then
        sleep 1
        echo "PM2 Is Detected successfully \n"
    else
        sleep 1
        echo "Installing PM2 Globally \n"
        {
            npm install pm2 -g

        } &> /dev/null
        sleep 1
        if [ $? -eq 0 ]; then
            echo "PM2 Installed Successfully \n"
        else
            echo "Oh Crap! Error While Installing PM2 \n"
            exit 0
        fi

    fi

    sleep 1
    echo "Lets Move on now! \n"



    read -p "Repository URL (Ending with .git) : " git_repo_url

    git_repo_url=${git_repo_url#*//}

    read -p "Branch Name : " git_branch_name

    read -p "Unique Project name in camel_case (this will be your project folder name) : " project_name

    read -p "Is this a Private Repository (y/n) : " private_repo_flag

    if [ "$private_repo_flag" == "y" ];
    then
        # Ask for username and token

        read -p "Github Username : " github_username

        read -p "Git Access Key for private Repository : " git_access_key

        echo "Cloning ($git_branch_name) branch from ($git_repo_url) Repository"

        # Clone Repo
        {
            git clone --branch $git_branch_name https://$github_username:$git_access_key@$git_repo_url ./$project_name
        } &> /dev/null

        if [ $? -eq 0 ]; then
            echo "Whoa! That was FAST! wasn't it? :) \n"

            sleep 1

            echo "Now Lets Generate the Github access token - https://github.com/settings/tokens/new \n"

            sleep 1

            echo "Lets Build the project now! \n"


        else
            echo "Oh Crap! Error While Cloning, Check if the URL is Correct of is branch really there?"
            exit 0
        fi

    else
        # Clone directly
        echo "Pulling ($git_branch_name) branch from ($git_repo_url)"

        {
            git clone --branch $git_branch_name https://$git_repo_url ./$project_name
        } &> /dev/null

        if [ $? -eq 0 ]; then
            echo "Whoa! That was FAST! Isn't it? :) Lets Build the project now! \n"
        else
            echo "Oh Crap! Error While Cloning, Check if the URL is Correct of is branch really there? \n"
            exit 0
        fi

    fi

    
    # check if .env is there or not
    read -p "Oh Wait! Before That, Do you have .env file in your project? (y/n) : " env_exist_flag
    if [ "$env_exist_flag" == "y" ]; then
        echo "Great, Lets build out the project now.\n"
    else
        echo "\n Oh! That means I have to create it!, guess what, I cannot not do that at the moment\n"
        sleep 1
        echo "But no worries, I can download from a url for you. BUT JUST FOR YOU :P \n"
        sleep 1
        echo "Host your .env file on a hosting (Make sure to add all values) and copy URL\n"
        sleep 1

        # download .env file and move into the project
        read -p "Now Give that URL for .env file (Make sure you have add all values) : " env_file_uri
        {
            cd $project_name/
            wget -O .env -q $env_file_uri || curl -o .env $env_file_uri
            cd ../
        } &> /dev/null

        if [ $? -eq 0 ]; then
            echo "Done!, Also Moved it into the project directory.\n"

            echo "Great, Lets build out the project now.\n"
        else
            echo "Oh Crap! Error While Downloading .env file, Check if the URL exist"
            exit 0
        fi

    fi


    # Install Dependencies
    echo "Building... \n"
    {
        cd $project_name/
        npm install
        node ace build --production --ignore-ts-errors
        cd build
        npm ci --production
    }

    if [ $? -eq 0 ]; then
        echo "Build Completed, Lets Move on! We are Close!!! \n"
    else
        echo "Unable to Build the project, There were errors, Please Recheck and deploy again"
        exit 0
    fi

    # Migration
    read -p "Do you want me to run migrations? (y/n)" run_migration_flag
    if [ "$run_migration_flag" == "y" ]; then

        echo "Migrations Started... \n"

        {
            cd ../
            node ace migration:run --force
        }
        if [ $? -eq 0 ]; then
            echo "Migration Completed, Lets Move on! We are this Close!!!"
        else
            echo "Unable to Migrate, There were errors, Please Recheck and start again"
            exit 0
        fi


    else
        echo "Fine Bro, Lets move on to next step!"
    fi


    # Create PM2 Conf File

    echo "Creating Ecosystem file..."

    {
        tee -a ecosystem.config.js > /dev/null <<EOT
module.exports = {
apps: [
    {
        name: '$project_name',
        script: './build/server.js',
        instances: '1',
        exec_mode: 'cluster',
        autorestart: true,
    },
],
}

EOT
    } &> /dev/null

    if [ $? -eq 0 ]; then
        echo "Done, File Created!"
    else
        echo "Error While Creating file."
        exit 0
    fi


    # run the project
    echo "Running the Project Now..."
    {
        ENV_PATH=../.env pm2 start ecosystem.config.js --watch
    }
    if [ $? -eq 0 ]; then

        echo "Project Running Successfully..."
    else
        echo "Error While Running the Project, Solve the Errors and try again..."

    fi

    sleep 1
    echo "I hope we'll meet again, make sure to star me on github - " #github link
    sleep 1
    echo "Adios!"

else
    echo "Really Bro? Install Git First!"
fi
