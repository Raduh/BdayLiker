BdayLiker
=========

About
-----
BdayLiker is a Ruby script that "likes" all birthday posts on your Facebook
wall. It can be trivially extended to add a comment to each post.

Installation
-----------
**Clone the repo**
```
git clone git@github.com:Raduh/BdayLiker.git
```

**Install the dependencies**

If you don't have bundler installed
```
gem install bundler
```
then in the project root directory,
```
bundle install
```

**Get a Facebook access token** from [here](https://developers.facebook.com/tools/explorer).

**Fill `config.json`** (in the project root directory) with the access token from
above and your birthdate.

Usage
-----
Just run
```
./liker.rb
```
