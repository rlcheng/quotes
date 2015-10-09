##README
This is a JSON API app that contains quotes from famous people.

[![Dependency Status](https://gemnasium.com/rlcheng/quotes.svg)](https://gemnasium.com/rlcheng/quotes)
[![Build Status](https://travis-ci.org/rlcheng/quotes.svg?branch=master)](https://travis-ci.org/rlcheng/quotes)
[![Code Climate](https://codeclimate.com/github/rlcheng/quotes/badges/gpa.svg)](https://codeclimate.com/github/rlcheng/quotes)
[![Coverage Status](https://coveralls.io/repos/rlcheng/quotes/badge.svg?branch=master&service=github)](https://coveralls.io/github/rlcheng/quotes?branch=master)

###To install:

```sh
bundle install
rake db:migrate
rake db:seed
rails s
```

###Verify install:
```sh
curl http://localhost:3000/ping
```
or go to the **URL** via your favorite browser

###Production Deployment
Done via **AWS Nginx+Passenger Capistrano** @ http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/
Go to http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/ping to see if server is up.

###Usage
Currently without need to establish session
#####get quotes#index
- To get all quotes, using Postman (Chrome plugin), set as **GET**, http://localhost:3000/quotes or http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/quotes
- On the **Header** tab, need it to be header => `Content-Type` and value => `application/json`
- Hit `send` and you will see quotes#index returned.

#####post quotes#create
- To create a new quote, using Postman, set as **POST**, http://localhost:3000/quotes or http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/quotes
- On the **Header** tab, need it to be header => `Content-Type` and value => `application/json`
- On the **Body** tab, need it to be **raw** and the format of the new quote should be like the following:
```sh
{
    "author": "Confucius",
    "body": "Wherever you go, go with all your heart."
}
```
- Hit `send` and you will see the app do a quotes#show in the following format:
```sh
{
  "data": {
    "id": "3",
    "type": "quotes",
    "attributes": {
      "author": "Confucius",
      "body": "Wherever you go, go with all your heart."
    }
  }
}
```

#####patch quotes#update
- To update a quote, using Postman, set as **PATCH**, http://localhost:3000/quotes/1 or http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/quotes/1 Substitude 1 for the ID of the quote you wish to update.
- On the **Header** tab, need it to be header => `Content-Type` and value => `application/json`
- On the **Body** tab, need it to be **raw** and the format of the new quote should be like the following:
```sh
{
    "author": "Confucius",
    "body": "Choose a job you love, and you will never have to work a day in your life."
}
```
- Hit `send` and you will see the app do a quotes#show in the following format:
```sh
{
  "data": {
    "id": "3",
    "type": "quotes",
    "attributes": {
      "author": "Confucius",
      "body": "Choose a job you love, and you will never have to work a day in your life."
    }
  }
}
```

#####get quote#show
- To get a single quote, using Postman, set as **GET**, http://localhost:3000/quotes/1 or http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/quotes/1 Substitude 1 for the ID of the quote you wish to see.
- On the **Header** tab, need it to be header => `Content-Type` and value => `application/json`
- Hit `send` and you will see the app do a quotes#show

#####delete quote#destroy
- To delete a quote, using Postman, set as **DELETE**, http://localhost:3000/quotes/1 or http://ec2-52-26-70-53.us-west-2.compute.amazonaws.com/quotes/1  Substitute 1 for the ID of the quote you wish to destroy.
- On the **Header** tab, need it to be header => `Content-Type` and value => `application/json`
- Hit `send` and you should get a status **204** in return, but to be sure you can print the index again.

####AWS Nginx+Passenger Capistrano Guide
#####Local Host
1. Add Capistrano gems into gemfile (already done for you, see gemfile for list of needed gems)
2. At project root do command `cap install` (already done for you, Capfile and config/deploy* files created.
3. Modify **Capfile** and **deploy.rb** (already done for you but take a look at the files).
4. Within **deploy.rb** there’s a line that sets the rvm ruby version as well as the gemset it is using (2.2.2@quotes). Need to set up the gemset quotes. Easiest way to do this is run the following: 
```sh
rvm gemset create quotes
rvm gemset use quotes
gem install bundle
bundle install
```
5. sign up for AWS if you havent. Launch a new EC2 instance, choose Ubuntu. micro if you want it to stay free.
6. Create key pair.
7. Add HTTP port 80 into the security group.
8. Select the newly created key pair.
9. Deploy
10. Add the private key to your keychain `ssh-add location_of_file/file_name.pem`
11. Login via `ssh ubuntu@your_aws_public_DNS_or_IP`

#####Remote Host
1. Do the following commands in order, this makes the following step in installing nginx much smoother (note you dont have to create the swapfile if your AWS instance is not a micro, micro has 1GB ram and no swapfile space by default): 
```sh
sudo apt-get install libcurl4-openssl-dev
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap
```
2. Follow Steps 1~7: https://www.digitalocean.com/community/tutorials/how-to-install-rails-and-nginx-with-passenger-on-ubuntu
3. For step 7 to work do this: http://askubuntu.com/questions/257108/trying-to-start-nginx-on-vps-i-get-nginx-unrecognized-service
4. Add new user if you wish (let it be a sudoer if you want). You can have the base **ubuntu** account deploy or you can create an account just for deployment.

#####Local Host
1. Test nginx by opening your browser and going to your AWS instance’s public DNS. You should see a Welcome to Nginx page.
2. Update **config/deploy/production.rb**, add the following line: 
```sh
server ‘your_aws_instance_public_dns’, user: ‘your_user_name’, roles: %w{app db web}
```

#####Remote Host
1. Install Postgres: 
```sh
sudo apt-get install postgresql
sudo apt-get install libpq-dev
```
2. Create Postgres user according to **database.yml**: 
```sh
$ sudo -u postgres psql
create user paid_programmer with password 'password';
alter role paid_programer superuser createrole createdb replication;
create database jokes_production owner paid_prorammer;
```
3. Install git: `sudo apt-get install git`
4. Setup github access, add another key to your account: https://help.github.com/articles/generating-ssh-keys/
5. Update nginx configuration: `sudo /opt/nginx/conf/nginx.conf`
```sh
server {

        listen       80;

        server_name  put_your_aws_instance_public_DNS_here;

        passenger_enabled on;

        rails_env production;

        root /var/www/your_app_name_here/current/public;
        .....
```
Comment out all html paths within the server block.
6. Restart nginx `sudo service nginx restart`
7. Create `/var/www/` via `sudo mkdir` and then do `sudo chown -R your_user /var/www`
8. Create gemset that matches what you have in the deploy.rb. See the first Step 4 for Local Host.

#####Local Host
1.  Create a new **secret_key_base**, use cmd `rake secret` and then copy the output key

#####Remote Host
1. Edit `~/.profile` go to the end of the file and add in `export SECRET_KEY_BASE = paste_the_secret_key_generated_from_local_host_here`
2. Exit remote host and log back in. verify existance of key by doing `echo $SECRET_KEY_BASE`
3. Restart nginx `sudo service nginx restart`

#####Local Host
1. Deploy the production code: `cap production deploy`
2. From browser check to see if it deployed. Use your favorite browser and go to ** *URL/ping* **
