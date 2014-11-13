# TODO Need to fill out this file later.  For now it's just a place to hold the link to Jenkins.


## Continuous integration

Our [continuous integration (CI) server][ci] runs tests every time [the GitHub
repo][gh] receives a push to the "develop" branch.

[ci]: http://ec2-54-221-137-29.compute-1.amazonaws.com:8080/
[gh]: https://github.com/mdsol/minotaur

**Note:** To access our CI server you will need to be on the internal corporate
network (i.e. on VPN if outside a company office) and authorized to view the project.
Contact the technical owner of this project if you would like to be authorized to
view this project's CI server.

The tests are run by executing the `rake ci` command. Therefore, if you make any
changes to the way in which the tests are run, it is your responsibility to
update the rake "ci" task accordingly for the branch you will be pushing.

The rake "ci" task can be run locally (in exactly the same way as it is on the
CI server) as follows:

```
[bundle exec] rake ci
```

**Note:** This will overwrite your local configuration files, e.g.
"config/database.yml", with the values given on the command line using the
corresponding .dice templates found in your repository. If your local
configuration files are already set up, you can use just the following instead:

```
rake ci:run
```
