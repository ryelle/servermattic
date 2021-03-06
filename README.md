Caveats: 
* Some of the current code relies on apt but could be easily adapted to use any package manager or something else entirely
* Although you can retrofit production hosts to use this system, I would test it on a clean install first

Step 1:

- Fork this Githhub repository which will serve as the source for your config management system.
- Clone the repository on your computer
- Edit role.sh and deploy.sh to define the correct GITURL to your Github forked repository and commit it
- When connecting to your server, you need to use the "-A" ssh parameter so you can connect to Github from your server 

This git repo is going to have lots of potentially sensitive data in it, so it should not be public for production systems. You may also want to consider restricting based on IP, as it shouldn't need to be accessible from the public world, but just from the servers you are deploying to.

Step 2: Edit your servers.dat file to fill in the appropriate information. See the included file for the expected format

Step 3: Add some stuff in your /tags/base/0001 directory.  This will mirror the filesystem via symlinks. /tags/base/0001/etc/aliases will get symlinked to /etc/aliases on the deployed host.  The only required file is etc/roles/{rolename} and the contents of this file should be the revision of the role without the leading zeros.

Step 4: If you wish to run any commands as part of applying your base role, add those to /migrations/base/0001.sh Common things to put in here would be apt-get install apache2 if you want to install apache2 from apt.

Step 5: Run the deploy.sh script on the host you wish to deploy to.  This will install the necessary support scripts and the base role

To apply additional roles first create them in git and then run role.sh apply {rolename}.  This is also how you upgrade to a new tag of an existing role.

Design Suggestions:

* If you have multiple datacenters, create a role for each datacenter which has DC-specific stuff if applicable (dc-sat, dc-iad, dc-lax, etc)
* Only create new tags for major changes which require some commands be run to apply.  If you just want to change a single file, just edit and check in that file in the current tag and then run role.sh update on your deployed hosts
* If you have files which you change frequently which require service restarts/reloads to apply, I would suggest using monit (http://www.tildeslash.com/monit/) for this.  Just check the md5sum of the config file and if it changes, have monit restart/reload the service.
* There isn't really a way to remove a role, but all the files are self-contained so it shouldnt be that hard.  Or just re-install the OS :)

Request:

If you actually use this code to do something cool, could you let us know about it?  barry 'at' automattic 'dot' com

Credit: 

Most of the code contributed by Demitrious Kelly (http://apokalyptik.com).  Remaining tidbits by Barry Abrahamson (http://barry.wordpress.com).
