# Installation Guide
## You should know...
* EMU is a single-tenant Ruby on Rails application. Users can add/edit/delete integrations and alerts created by other users (this is intentional). If complete separation is needed, an additional EMU installation is required. 

* It supports two types of user authentication - native account creation via the database, and Google OAuth.

* 2FA is enabled by default for all native accounts. It can be disabled on a per-user basis by setting the `otp_required_for_login` flag in the users table to `false`. 

* It can be configured and scaled a number of different ways, depending on the needs of your team. Scaling this app for high availability or thousands of requests/second is outside the scope of this guide, but should be similiar to scaling any Ruby on Rails app.

* EMU was developed against Elasticsearch v7.x; older versions of Elasticsearch were not tested.

* An Ansible playbook + roles were written to speed up/standardize the installation process. This guide will assume you have a working, local installation of Ansible and are familiar with SSH. Many of our clients have highly restrictive ingress/egress firewall rules, so our Ansible roles contain copies of the required packages (rather than downloading them from the Internet).

* EMU runs through a nginx+passenger setup. Our production environment terminates the SSL at an AWS ELB. If you wish to terminate the SSL on the target machine itself, additional nginx configuration changes are needed.

## Requirements
* A Linux server running a fresh installation of Ubuntu18
* An Elasticsearch cluster running v7.x (can be local or remote)
* Ansible installed and working on your local machine
* Git installed and working on your local machine
* SSH + root access to the machine that will host the application.

## Step #1: Ensure Ansible can connect to the target machine
Update the Ansible playbook with the user account that is used to SSH to the machine.
   * [Line 4, provision.yml](https://github.com/ValiantSolutions/emu/blob/master/setup/provision.yml#L4)

## Step #2: Clone this repo to your local machine
```git clone https://github.com/ValiantSolutions/emu && cd emu```

## Step #3 (optional): Package installation
By default, the following packages will be installed on the target machine:
* Ruby 2.5.5
* MySQL
* Redis

Users may wish to configure EMU to use an external database/redis endpoint. If that is the case, you may wish to comment out the following to prevent installing additional packages:
* [Line 20, provision.yml](https://github.com/ValiantSolutions/emu/blob/master/setup/provision.yml#L20)
* [Line 17, main.yml of install-packages role](https://github.com/ValiantSolutions/emu/blob/master/setup/roles/install-packages/vars/main.yml#L17)
* [Lines 4-8, post-install role (enables redis at start)](https://github.com/ValiantSolutions/emu/blob/master/setup/roles/post-install/tasks/main.yml#L4)
* [Lines 10-14, post-install role (enables mysql at start)](https://github.com/ValiantSolutions/emu/blob/master/setup/roles/post-install/tasks/main.yml#L10)

## Step #4: Environment configuration
Environment variables specific to EMU are defined in the [provision.yml playbook](https://github.com/ValiantSolutions/emu/blob/master/setup/provision.yml#L16).
* Installation path for the application: 
  * ```app_path: /emu```
* EMU GitHub repo which will be cloned:
  * ```emu_repo: https://github.com/ValiantSolutions/emu.git```
* EMU environment
  * ```emu_env: production```
* Server name
  * ```server_name: your-emu-install.fqdn.com```
* Master key to decrypt Rails secrets. Generate one [here](https://www.randomlists.com/string?qty=12&length=32&base=16):
  * ```rails_master_key: <generated key here>```
* MySQL:
  * ```database_name: emu_prod```
  * ```database_username: <username>```
  * ```database_password: <password>```
  * ```database_host: localhost```
  * ```database_port: 3306```
* Google OAuth (optional): [setup instructions from Google dev site](https://support.google.com/googleapi/answer/6158849?hl=en&ref_topic=7013279).
  * ```google_oauth_client: <client>```
  * ```google_oauth_secret: <secret>```
* Redis
  * ```redis_connection: redis://localhost:6379/0```

## Step #5: (optional) Additional nginx configuration
Now is the time to make any changes to the nginx configuration files:
* [Main nginx configuration file](https://github.com/ValiantSolutions/emu/blob/master/setup/roles/post-install/templates/nginx.conf.j2)
* [EMU site config file](https://github.com/ValiantSolutions/emu/blob/master/setup/roles/post-install/templates/emu.j2)

## Step #5: Run playbook (from local machine)
* ```cd setup```
* ```ansible-playbook -i 'your_server_ip,' provision.yml```

## Step #6: Configure Rails secrets
We need to configure the encrypted secrets that EMU will use throughout.
You'll need to generate 3 random strings. Use links below to generate them automatically:
* [secret_key_base](https://www.randomlists.com/string?qty=12&length=128&base=36)
* [attr_encrypted](https://www.randomlists.com/string?qty=12&length=32&base=36)
* [otp_key](https://www.randomlists.com/string?qty=12&length=32&base=36)

With the 3 random strings in hand, we can add them to our encrypted rails credentails file.

* SSH to new server
* `sudo su` to root
* `su emu` to switch to the emu user
* `cd /emu`
* `EDITOR="nano" rails credentials:edit`
* Paste the following: 
  ```
  secret_key_base: <generated secret_key_base>
  attr_encrypted: <generated attr_encrypted>
  otp_key: <generated otp_key>
  ```
* Save file

## Step #7: Start application
If all went smooth, we should now be able to start our two daemons.
* `service sidekiq restart`
* `service nginx restart`
