This Vagrant box replicates the environment created by Linode's [Rails 3 &amp; Ruby 1.9.2 StackScript](http://www.linode.com/stackscripts/view/?StackScriptID=1291).

The OS is Ubuntu 10.04 LTS (Lucid Lynx), and the following packages are installed:

- Rails 3
- Ruby 1.9.2
- Nginx and Passenger
- MySQL
- git

Also, the StackScript executes these actions:

- Update rubygems
- Install sqlite gem
- Install mysql gem
- Add deploy user
