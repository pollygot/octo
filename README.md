# Getting Started

1. Set up automated deployment
	a. Configure DNS 
		i. Point Google Domain to Cloudflare
			- Cloudflare gives us the names of 2 name servers that we can plug into Google Domains (where we bought the domain) so that Google knows that Cloudflare will be taking over the routing when people hit the domain name.
		ii. Add Name Records to Cloudflare
			- Add an A record with the name @ (which sets to your domain name), pointed at the IP of your server.
			- Add a CNAME record with name www also pointed at the same IP so Cloudflare can point to `domain.com` and `www.domain.com`
	b. Set up Digital Ocean server
		i. Initial server setup (do all steps - refer to note below)
			- https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
			- NOTE: After you're done with the guide, open port 4000 with the command `sudo ufw allow 4000` so you can test the deployment later.
		ii. Install Nginx (do all steps)
			- https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04
		iii. Create server blocks (do all steps)
			- https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04
		iv. Secure Nginx with SSL certificate (do all steps - refer to note below)
			- https://www.digitalocean.com/community/tutorials/how-to-set-up-let-s-encrypt-with-nginx-server-blocks-on-ubuntu-16-04
			- NOTE:In step 4, choose option 2, Redirect. This will provide automatic redirects to HTTPS on the production server we're creating in this tutorial.
			- NOTE: After you are done with this guide, change Cloudflare's Crypto SSL setting to Full
	c. Automate deployment
		i. Install Elixir/Phoenix on server, configure SSH, and create test project (do steps 2-4 - refer to note below)
			- https://www.digitalocean.com/community/tutorials/how-to-automate-elixir-phoenix-deployment-with-distillery-and-edeliver-on-ubuntu-16-04
			- NOTE: In step 3, `Hostname example.com` should be `Hostname ssh.example.com`. Then go into your DNS and create an A record called `ssh` that points to your server IP and make sure to turn HTTP Proxy off (just click the orange cloud so it turns grey).
			- NOTE: In step 4, replace `mix phx.new --no-ecto --no-brunch myproject` with `mix phx.new myproject`
		ii. Install Nodejs and Postgres (do steps 6 & 7 - refer to note below)
			- https://devato.com/automate-elixir-phoenix-1-4-deployment-with-distillery-and-edeliver-on-ubuntu/
			- NOTE: In step 7, replace `sudo app update` with `sudo apt update`
			- NOTE: In step 7, replace`pgsql` command with `psql`
			- NOTE: Note down the username and password of your db user, you will have to use it when you copy prod.secret to the server later.
		iii. Configure Postgres settings to allow database access with password (follow this)
			- https://askubuntu.com/questions/820792/peer-authentication-failed-for-user-with-all-privileges-in-postgres-9-5
		iii. Install build-essential package 
			- Type `sudo apt-get install build-essential` in server command line
		iv. Configure Distillery and eDeliver (do steps 5-7 - refer to note below)
			- https://www.digitalocean.com/community/tutorials/how-to-automate-elixir-phoenix-deployment-with-distillery-and-edeliver-on-ubuntu-16-04
			- NOTE: In step 5, when you copy prod.secret to your server change `example.com:/home...` to `deploy@example.com:home...`
			- NOTE: In step 5, after you copy prod.secret, change it to what you see here in step 8 with the database username/password that noted down from a few steps before. If the database is on a different server, then you need to add `hostname` and the IP of the server it is on. If you don't add hostname, it defaults to localhost, which is the same server you are putting prod.secret on.
			https://devato.com/automate-elixir-phoenix-1-4-deployment-with-distillery-and-edeliver-on-ubuntu/
			- NOTE: In step 5, use the latest eDeliver dependency that you'll find here https://github.com/edeliver/edeliver
			- NOTE: In step 6, below the `pre_erlang_get_and_update_deps` function, add the `pre_erlang_clean_compile()` function that you'll find in here https://devato.com/automate-elixir-phoenix-1-4-deployment-with-distillery-and-edeliver-on-ubuntu/
		v. Start Phoenix on boot
			- `sudo nano /lib/systemd/system/example.service`
			- Paste 
				`
				[Unit]
				Description=Phoenix server for kunvince app
				After=network.target

				[Service]
				User=deploy
				Group=deploy
				Restart=on-failure

				Environment=HOME=/home/deploy/kunvince

				ExecStart= /home/deploy/kunvince/bin/kunvince foreground
				ExecStop= /home/deploy/kunvince/bin/kunvince stop

				[Install]
				WantedBy=multi-user.target
				`
			- `sudo systemctl enable example.service`
			- `sudo systemctl daemon-reload`

		vi. Configure Distillery and eDeliver (do steps 5-7 - refer to note below)
			- https://www.digitalocean.com/community/tutorials/how-to-automate-elixir-phoenix-deployment-with-distillery-and-edeliver-on-ubuntu-16-04
		vii. Migrate your database
			- Type `mix edeliver migrate production` to migrate the database on the production server.

2. Add front-end dependencies
	a. Change CSS to SCSS
		i. https://elixirforum.com/t/phoenix-1-4-webpack-4-and-bulma-bootstrap-4-sass/14354/7
	b. Add Bulma/Bulma Extensions/Animate.css
		i. https://elixirforum.com/t/phoenix-1-4-webpack-4-and-bulma-bootstrap-4-sass/14354/20
		


References
1. Restarting Stuff
	a. Rebooting the server
		- `sudo systemctl reboot`
	b. Restart Nginx
		- `sudo systemctl restart nginx`
	b. Restart postgres
		- `sudo systemctl restart postgresql`
	c. Restart SSH
		- `sudo systemctl reload sshd`
	d. Restart firewall
		- `sudo ufw reload`
2. Ports
	a. See what ports are listening
		- `netstat -nlt`
	b. Open port
		- `sudo ufw allow 8080`
	c. Close port
		- `ufw delete allow 8080`
3. Folder paths
	a. Postgres configs
		- `/etc/postgresql/9.5/main`
	b. Error logs
		- `/var/log/nginx/error.log`
4. Nginx users 
	a. Adding users
		- `sudo adduser user_name`
	b. Deleting users
		- `sudo userdel user_name`
		- Then remove their home directory with
		- `sudo rm -rf /home/username`
5. NPM
	a. See what version you are using
		- `npm -v`
		- `npm install -g npm@latest`
6. Build and deploy
		- `cd ~/myproject`
		- `mix edeliver build release`
		- `mix edeliver deploy release to production --version=2.3`
		- `mix edeliver stop production`
		- `mix edeliver start production`
		- `mix edeliver migrate production`

		- after you do the above once, bump up the version number in Mix.exs, build the release again, and then hot load it with `mix edeliver upgrade production`. 
		(if its not working, go through the whole thing again, build, release, stop and start production)
7. Useful links 
	a. Bulma Hero background image
		- https://github.com/jgthms/bulma/issues/1007
	b. Add fields to the model
		- http://wsmoak.net/2015/07/27/adding-fields-to-an-ecto-model-in-phoenix.html
	c. Seeding data
		- https://phoenixframework.org/blog/seeding-data
	d. Loading  different templates for different users
		- https://elixirforum.com/t/how-to-load-different-templates-and-views-if-a-user-is-logged-in/13682/2
	e. How to create admin routes / authentication
		- https://medium.com/@andreichernykh/phoenix-simple-authentication-authorization-in-step-by-step-tutorial-form-dc93ea350153
	f. Postgres privileges
		- https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2
	g. Many to many schemas
		- https://alchemist.camp/episodes/unified-tagging-system
	h. Nested routes
		- https://www.smoothterminal.com/articles/nested-resources-in-phoenix
8. Ubuntu commands
	`sudo`: elevates your privileges to root before executing whatever command comes after it
	`sudo !!`: reruns last command with higher privilages
	``su - root` or `su - deploy`: anytime you put a username after `su - ` it will assume the role of that user before running the command you put after it
	`CTRL + d`: drops out of your current server session
9. Git commands
	a. Reset changes since last commit 
        - `git reset HEAD --hard`



Dev ops notes
Cloudflare
Cloudflare is acting as my DNS (Domain name server) which means it will route traffic to wherever i tell it to. 	

Let’s Encrypt
I can use Lets Encrypt to give me SSL encryption. This means that a 3rd party puts a certificate on my site that tells the users browser that my site is who it says it is. This gives them a https domain when they load my site, and it also says “secure” in their browser with a lock next to it. It will also boost my Google rankings. After doing this, you need to turn SSL encryption on in Cloud Flare to FULL (in crypto tab) so that you don’t get infinite redirects.

Edeliver and Distillery
Edeliver and Distillery do all the heavy lifting when it comes to deploy your Phoenix app. Before setting up your server, follow these directions https://github.com/edeliver/edeliver

Digital Ocean
This is the VPS(Virtual Private Server) that gives you server space at a monthly rate. (like Cloud computing but easier to use and less elastic pricing). We’ll choose to run Ubuntu on the server, which is a Linux-based open source operating system. Before we finish setting up the server, we’ll want to provide it with an SSH Key.

SSH Key
This is a unique key that is generated by our computer. It has a public key, which is kind of like a type of lock, and a private key, which opens that specific lock. When we SSH into our server, it asks for the public key to make sure we should even be talking to it. After presenting the public key, it asks for the private key, and if that matches too, we can get in. 

Generating an SSH key
Can be generated in your command line by typing `ssh - keygen`. It will ask you where you want to save the key, and usually present a folder like `home/meraj/ssh/id_rsa`. Hit enter, and then go look into that folder. You’ll see 2 keys, `id_rsa` and `id_rsa.pub`. Type `cat id_rsa.pub` to print the contents of the public key, and then copy the public key into the prompt in Digital Ocean

Getting into your server
To ssh into your server, type `ssh username@IPAddress`. Your username will be sent to your email by Digital Ocean when you set up the server. The default username is usually `root`.


Questions
1. What happens when someone visits your site?
    1. When someone visits a website, their computer hits a DNS to look up who owns that website. Then it goes to Google, where I registered the site, and asks what the IP is. Google says, well, we dont have it, its being controlled by Cloudflare, so Cloudflare gives them the IP and the user’s browser makes a direct connection through port 80 (which is specified in the sites available config - what port Nginx will listen to the outside world on). Then NGINX looks inside the server (or maybe even another server) for the right files. It knows where to look because we specified an “upstream” port (like 8080) in sites available config. Localhost (127.00.0.1 means the server that the application is on, so NGINX knows to look on its own server for the files. Once it receives the files on 8080, it sends them to the user on port 80. 
2. What is the Edeliver build process?
3. When you type “mix edeliver build release” - Edeliver SSH’s into your server with the user that you put into its config, sends all your app’s files onto the server in the folder location that you told it, and builds everything for you. The build process compiles all your files(mix phx.digest), gets all the dependencies (mix deps get), node modules (npm install), build your front end assets (webpack build) and then distillery packages that all up into an artifact called a tarball. You can build as many versions of the app as you want you don’t have to deploy them, you can just have them sitting on your server, and if at any time you want to deploy them they’re already built. Generally, people do all of the above on a “build server. Then you type “mix edeliver release to production”, the build artifact is moved to a folder on your production server (specified in your sites available config). Then when you type “mix edeliver start production” it makes sure that all the traffic is going to the new version. Hot reloading (“mix edeliver upgrade production”) makes sure you don’t have any downtime.
4. How does web pack fit into all of this? How do the assets get sent to the server? where do they compile?
    1. There are 2 parts of your application, the front end code that lives on the browser, and the backend that responds to browser requests. Webpack is specifically for front end assets like, Javascript, CSS, Scss. It is part of the build step in your eDeliver. Once Webpack puts all your assets together, it puts them in 1 or two files in the priv/static folder.
    2. SOLUTION for my problem - Webpack may not have put the file in priv/static, so its not being sent to the browser. This is why the browser is only rendering HTML and no front end stuff. There are some settings that Distillery uses that may have affected the Webpack build. Look in Paul’s eDeliver config for “pre erlang clean and compile” and add that into my eDeliver config. I’ll also have to make some changes to that because its using brunch, so wherever i see brunch that will fail. (see if i can find a web pack version of this?) 
5. If i want to have 2 sites, do i need 2 deploy users
    1. If i have 2 files that have the same version ? It only deploys on the server. You can only have one port listening to each port. one of my ports is on 4000 and the other is on 4001. It will detect the domain on the outside, based on this domain, which sends the request traffic through 4001 to the place where the production files sit.

 # modified_user = Products.modify_user(content, socket.assigns.project)
    # user = Products.get_user!(socket.assigns.project, user_id)