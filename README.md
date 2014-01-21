Schema Loading On Dependent Databases
=====================================

[![Build Status](https://travis-ci.org/errm/slodd.png?branch=v0.1.0)](https://travis-ci.org/errm/slodd)

Slodd is a lightweight tool for loading an activerecord schema.rb into a database, like rake db:schema:load but more awesome.

Examples:

###Loading schema from github:

slodd -g errm/awesome_rails_app -t my-secret-oauth-token -d "awesome_app awesome_test"

or from a specific branch:

slodd -g errm/awesome_rails_app -t my-secret-oauth-token -r my-brillant-branch -d "awesome_app awesome_test"

###Loading schema from a file (defaults to db/schema.rb):

slodd -d awesome_test

or

slodd -f db/second_database.schema.rb -d awesome_test
