Pyramid Vagrant [dvlpr-vagrant]
==============================================================================

This is an alternate vagrant implementation for the Pyramid project owned by Olivent Technologies, llc.  This one leverages configuration management more than shell scripts and improves on many of the weaknesses of the original.

Objectives
------------------------------------------------------------------------------
1.  Provide a one step testing environment that works equally well on all host platforms (Windows, Mac & Linux)

2.  Provide an accurate representation of WordPress Multisite Development effort

3.  Provide the same database as the live site - or at least a miniaturized version

4.  Provide a proving ground for the build process as it is migrated to [Ansible](https://www.ansible.com/)

5.  Provide all of the utilities needed to validate, document, test, and debug project code
    *   WP-CLI
    *   PHPUnit
    *   PHPDoc
    *   PHPCS


Requirements
------------------------------------------------------------------------------

* Vagrant >= __2.0.0__
* A minified version of the database dump from the pryramid.local multi-site network.

### Certified Version Combinations:

| Date          | VirtualBox  | Vagrant  | Ubuntu 18.04  Base Box  |
|:--------------|:------------|:---------|:------------------|
| 3 Aug 2018  | 5.2.16      | 2.1.2    | v201807.12.0      |

Installation
------------------------------------------------------------------------------

1.  Clone this project into an `ansible` directory in the root of your `rdnap` project.  Please note that there should __not__ be a `dvlpr-vagrant` directory inside an `ansible` directory.  Instead, you must essentially change the name of the `dvlpr-vagrant` directory to `ansible`.  This can be done while cloning the project with one of the following commands:

    __For HTTPS__
    ```bash
    git clone REPO_URL ansible
    ```
    
    __For SSH__
    ```bash
    git clone REPO_URL ansible
    ```

2.  Run `git submodule update --recursive --init` from the project root.

3.  Add your unique GitHub Token as appropriate to the REPO_URL to and `auth.json` file in the project root directory.  This will allow both you and Ansible to use Composer with secure credentials.  You may use the following template for your `auth.json` file:

    ```JSON
    {
        "github-oauth": {
            "github.com": "<< Your GitHub Token >>"
        }
    }
    ```

4.  Copy a database backup (TBD.sql.gz) into the `ansible` directory.  There isn't currently an easy way to obtain a backup so someone will probably have to give this to you.

5.  __Either__ install the vagrant-hostsmanager plugin with `vagrant plugin install vagrant-hostsupdater` __or__ manually add the following to your hosts file.  The plugin is recommended for Mac and Linux but mileage may vary on Windows (it works but only in command windows with administrator rights).

    ```bash
    192.168.245.10      pyramid.local rd.pyramid.local rem.pyramid.local cw.pyramid.local cm.pyramid.local
    192.168.245.10      frl.pyramid.local bnb.pyramid.local bhu.pyramid.local bcp.pyramid.local
    192.168.245.10      fhm.pyramid.local toh.pyramid.local tmb.pyramid.local wpdt.pyramid.local
    192.168.245.10      rdc.pyramid.local srd.pyramid.local bhc.pyramid.local ctmb.pyramid.local
    ```

6.  __Optional:__ If you would like to see the output from ansible in color then you will need to set the environment variable `VAGRANT_FORCE_COLOR=1`.  It can actually be equal to anything as long as it is set.  In PhpStorm, this can be set in the vagrant configuration.
   
    __Windows__
    ```bash
    set VAGRANT_FORCE_COLOR=1
    ```
    
    __Mac & Linux__
    ```bash
    export VAGRANT_FORCE_COLOR=1
    ```

7.  From inside the `ansible` directory, start the provisioning process with `vagrant up`.


Usage
------------------------------------------------------------------------------

This machine is assigned the IP address `192.168.245.10` and can be accessed via `vagrant ssh` or manually with the either of the following credentials:
* User & password both = __vagrant__
* User & password both = __ubuntu__

Project files may be accessed inside the virtual machine and are found in the `/vagrant` directory.  The project is currently built (using symbolic links) into the `/data/www/pyramid.local` directory.

All of the sites in the multi-site network are configured and accessible (though some may be only placeholders in the database):

| ID | Name                            | Local URL               | Production URL                        |
|---:|:--------------------------------|:------------------------|:--------------------------------------|
|  1 | Multi-Site Root                 | <http://pyramid.local>      | <http://pyramid.net>                      |
|  2 | Readers Digest                  | <http://rd.pyramid.local>   | <https://www.rd.com>                  |
|  3 | Reminisce                       | <http://rem.pyramid.local>  | <http://www.reminisce.com>            |
|  4 | Country Woman Magazine          | <http://cw.pyramid.local>   | <http://www.countrywomanmagazine.com> |
|  5 | Country Magazine                | <http://cm.pyramid.local>   | <http://www.country-magazine.com>     |
|  6 | Farm & Ranch Living             | <http://frl.pyramid.local>  | <http://www.farmandranchliving.com>   |
|  7 | Birds & Blooms                  | <http://bnb.pyramid.local>  | <http://www.birdsandblooms.com>       |
|  8 | Best Health US                  | <http://bhu.pyramid.local>  | <http://www.besthealthus.com>         |
|  9 | Construction Pro Tips           | <http://cpt.pyramid.local>  | <https://www.constructionprotips.com> |
| 10 | Family Handyman                 | <http://fhm.pyramid.local>  | <https://www.familyhandyman.com>      |
| 11 | Taste of Home                   | <http://toh.pyramid.local>  | <https://www.tasteofhome.com>         |
| 12 | Trusted Media Brands            | <http://tmb.pyramid.local>  | <http://www.trustedmediabrands.com>   |
| 13 | WordPress Development Team      | <http://wpdt.pyramid.local> | <http://wpdt.pyramid.net>                 |
| 14 | Readers Digest Canada           | <http://rdc.pyramid.local>  | <http://www.readersdigest.ca>         |
| 15 | Selection                       | <http://srd.pyramid.local>  | <http://selection.readersdigest.ca>   |
| 16 | Best Health Canada              | <http://bhc.pyramid.local>  | <http://www.besthealthmag.ca>         |
| 17 | Contests (Trusted Media Brands) | <http://ctmb.pyramid.local> | <https://contests.tmbi.com>           |

### Blackfire

This machine comes with Blackfire profiling tools already installed. If you want to use it, you need to configure it with your personal IDs and Tokens. You can find those in the [Blackfire Docs](https://blackfire.io/docs/up-and-running/installation) (while logged in to your account).

1. Get into the VM
    ```
    vagrant ssh
    ```

2. Register the agent
    ```
    sudo blackfire-agent -register
    # Answer the prompts with Server ID and Server Token from the instructions page
    ```

3. Configure the CLI tool
    ```
    blackfire config
    # Answer with Client Id and Client Token from the instructions page
    ```

After that, you will be able to profile any of the sites with the usual `blackfire curl` command:
```
blackfire curl http://toh.pyramid.local
```

### Composer

Composer dependencies are installed automatically during the Vagrant build process as along as the `auth.json` file is correct.  To install composer dependencies manually:

```bash
cd /vagrant
composer install
```

You may be prompted for access if you did not create your `auth.json` file or if there is a problem with it.

### PHPCS

Although PHPCS is installed inside the VM, the `validate.sh` script is not written to take advantage of it.  It will currently only use the one installed via Composer.

```bash
cd /vagrant
./validate.sh
```

### RabbitMQ

This machine is configured with an instance of RabbitMQ, complete with the management interface.  It also installs and runs the workers needed to send data to the MKE API.

RabbitMQ listens on port 5672 and the management interface may be found at <http://pyramid.local:15672/>.  There are two sets of administrator credentials:
* User & password both = __vagrant__
* User & password both = __ubuntu__

The mq-resources project is installed in the `/opt/mq-resources` directory and the required php-amqplib library is also installed automatically via Composer. 

### Supervisor

The programs that accept messages from RabbitMQ (called "consumers") are run as services and managed by a program called _Supervisor_.  When you SSH into the Vagrant virtual machine you can control the status of the consumers with `supervisorctl`.

The configuration files for consumer processes are found in `/etc/supervisor/conf.d`.  A thorough explanation of how these files work may be found in the [Supervisor documentation](http://supervisord.org/configuration.html#program-x-section-settings).

#### Check the Status of Supervisor Processes

Use `status` to list all of the programs managed with _Supervisor_ and show their current state.
```bash
$ sudo supervisorctl status
mkeapi:send-form-00              RUNNING   pid 2004, uptime 2 days, 3:01:07
recipes:get-recipe-00            STOPPED   Not started
```

#### Start a Supervisor Process

Use `start` to run a consumer if it is not already.  Notice that the _recipes_ group contains only 1 process but could be more.

* To start the whole group, simple type the group name including the colon.
* To start individual processes, you must type the entire process name on both sides of the colon.
```bash
$ sudo supervisorctl start recipes:
recipes:get-recipe-00: started
```

#### Stop a Supervisor Process

Use `stop` to halt a consumer.  Notice that the _recipes_ group contains only 1 process but could be more.
* To stop the whole group, simple type the group name including the colon.
* To stop individual processes, you must type the entire process name on both sides of the colon.
```bash
$ sudo supervisorctl stop recipes:
recipes:get-recipe-00: stopped
```

### WP-CLI

[WP-CLI](http://wp-cli.org/) is a useful command line utility for WordPress.  To use it, you must first:

* `vagrant ssh` into the command line of the virtual machine
* Change directories into the document root with `cd /data/www/pyramid.local`

Though the [complete list of commands](https://developer.wordpress.org/cli/commands/) may be found online, here are solutions to some situations you may be faced with.

#### Create a User

You can [create a user account](https://developer.wordpress.org/cli/commands/user/create/) very simply by replacing the login, email, and password with appropriate values.

```bash
wp user create login your.email@example.com --user_pass=password --role=administrator --url=pyramid.local
```

#### Promote a User

If you already have a user account but with insufficient privileges, you can simply make yourself an administrator.  Replace the login with your own user ID in the line below.

```bash
wp user set-role login administrator --url=pyramid.local
```

### Xdebug

If you would like to use breakpoints for development and troubleshooting then Xdebug will need a map to connect paths on the server to those in your project.

PhpStorm has a convenient GUI for managing these mappings.  Once one is set up for a site in the multi-site network then it can easily be copied for use with the other sites.

Add the following items under the PHP&rarr;Server configuration for _rd.pyramid.local_ and duplicate for any other site you want to debug.

*   < project >/web/app &rarr; /vagrant/web/app
*   < project >/web/cfg &rarr; /vagrant/web/cfg
*   < project >/web/wp &rarr; /data/www/pyramid.local

Future Plans
------------------------------------------------------------------------------

### Short Term

Need to build a system for automatically retrieving updated databases.

### Long Term

Eventually, we will build our own base box to eliminate the need for developers to provision boxes themselves.  Since boxes can be updated with a single command, this is a very clean and reliable approach to distributing updates.

The plan is to build a Jenkins pipeline job that gathers all the necessary resources, assembles the box, and makes it ready for distribution all in one step.  This way we can make updated boxes available at regular intervals with minimal overhead.  It also allows us to respond quickly to immediate needs.
