[license-url]: LICENSE
[license-image]: https://img.shields.io/github/license/adonisjs/adonis-framework?style=for-the-badge

[![license-image]][license-url]

# MagicDep Adonis
A Shell script to deploy AdonisJS 5 Projects on server or local environment by just answering some fun question's

# Lets see what it can do!
So MagicDep is a shell script that can deploy any AdonisJS 5 application easily

So Lets start from the beginning, when computer was invented... (wait, that's a little too early).

When we deploy a NodeJS application, we need an ubuntu server (as far as i know, and i know shit!!, no seriously I AM A NOOB), moving on!!

So we need a ubuntu server where we have to install NodeJS and npm or yarn, then we need a git installed if we are using version control from github or bitbucket to clone our repositories.

After all of this things, we need to build our project, run migration, setup environment so it should not be exposed to client, install a process manager, setup a script for that, install dependencies and a lot of other things, and god knows how many times we "cd foldername" while deploying.

##### So to cut all that crap, I have developed a shell script that will do everything for you (From Install NodeJS, NPM, PM2, migrations installing dependencies, everything.)

#### You just need a git pre installed on your server.

```bash
sudo apt-get install git
```

to run a shell script we need a script (ofcourse).


before that switch to sudo environment by running this command,
```bash
sudo su
```

So lets install script, just run this command.
```bash
wget -q https://raw.githubusercontent.com/hackerrahul/MagicDep-Adonis/main/Magic.sh -O magic.sh; sudo bash ./magic.sh
```

Now it will ask for some questions just answer them accordingly.

So now if your github repository is private, you need a github access token, which is mentioned while running it but why not here too.
So to get github access token, you have to navigate to this page
### https://github.com/settings/tokens/new

- Give it a note
- Set Expiration to whatever you like.
- Check the **repo** options in **Scopes**
- Generate Token Now.

So now its a NodeJs application, and NodeJS is just imcomplete without **Environment variables** isn't it?
So to install the ENV Variables to make sure our project run, we need to Store them in aour project but outside the build directory.

So at the moment, instead of entering env variables just in the command line(that will not work), We have to install it.

So Here is a Quick workflow for that.

- Copy all the content in your .env file
- go to http://gist.github.com
- Name the file as anything and paste all the content in that GIST
- Now create a Secret GIST (Make Sure - **SECRET GIST**), because i don't think you can afford your secret variables roaming around internet.

<img src="https://user-images.githubusercontent.com/17741867/173141707-400f2900-1497-415a-8297-e7976d2360d3.png" width="800" />

- Now **open it as raw** and copy the URL

<img width="732" alt="image" src="https://user-images.githubusercontent.com/17741867/173142920-c6c53b6c-562d-4fd3-889b-9f88538ae098.png">

- Copy the Direct Path of the raw file

<img width="707" alt="image" src="https://user-images.githubusercontent.com/17741867/173143447-3c9390ab-da5e-405e-bc07-cd89600d012f.png">

That's it, Pass this url in wherever you've been asked in the installation.

You're good to go, try it, star it.

Adios!


