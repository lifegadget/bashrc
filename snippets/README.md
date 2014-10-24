# Bash Snippets

Snippets are components or groupings of functionality that might be useful for someone operating at the command-line. Typically these *snippets* would be sourced by an individual's `.bashrc` or `.bash_profile` bash initializer script. 

## machine

This is meant to be provisioned into Vagrant virtual machines which in turn are composed by docker images. This allows the following lifecycle events to be executed:

- **start** - starts infrastructure components; if dependencies with lockers is not met then they will be started too
- **stop** - starts infrastructure components
- **restart** - stops then starts infra components; in most cases but will use "restart signals" where the infrastructure supports a more efficient restart method (like nginx)

- **init** - Run during Vagrant provisioning; similar to a "start" but with more data preparation than a *start* or *restart* which would hope for an existing storage locker

In addition to these clear "state change" commands, this script also provides:

- **inventory** - 