This [Vagrant](http://www.vagrantup.com/) box replicates the environment created by Linode's [Rails 3 &amp; Ruby 1.9.2 StackScript](http://www.linode.com/stackscripts/view/?StackScriptID=1291).

## Included packages

- Ubuntu 10.04 LTS (Lucid Lynx)
- Rails 3
- Ruby 1.9.2
- Nginx and Passenger
- MySQL
- git

Also, these tasks are executed:

- Update rubygems
- Install sqlite gem
- Install mysql gem
- Add deploy user

## Installing

1. Install VirtualBox
2. Install Vagrant
3. Clone this repo and run Vagrant:

```bash
$ git clone git://github.com/zacwasielewski/vagrant-lucid32-rails3-ruby192.git
$ cd vagrant-lucid32-rails3-ruby192
$ vagrant up
```
## Notes

The default MySQL password is 'vagrant'. You may want to change it:

```bash
$ mysqladmin -u root -p'vagrant' password newpass
```

## Important!

If you need to run `vagrant up` after the initial install, be sure to add the `--no-provision` flag:

```bash
vagrant up --no-provision
```

This prevents Vagrant from wiping out your nginx, MySQL, or Ruby gem customizations. (When I get some free time I'll modify the post-install bash script to do this properly.)


##Requirements

- [Vagrant](http://downloads.vagrantup.com/) (v1.1.0 or above)
- [VirtualBox](https://www.virtualbox.org/)
