# to do 

* add shell.nix to degenerate
* add degenerate package +  service + yaml config to nixops spec
* put them somewhere (e.g. github)
* make slides

# Nix, NixOS, NixOps

Nix is a package management language

Nixpkgs is a collection of packages

NixOS is a Linux distribution

NixOps is a provisioning/configuration management system

> "a completely declarative approach to configuration management: you
write a specification of the desired configuration of your system in
NixOS’s modular language, and NixOS takes care of making it happen."


# Setting expectations

* Small community of contributors (sometimes stuff breaks, no major
  vendor to provide security patches, etc)

* Out of box experience is not too slick

* Accommodating language-specific dependency management (e.g. npm,
bundler, maven) needs thought. Haskell users love it though ;-)

* not your traditional unix fs layout

* Your home may be at risk if you do not keep up repayments on a mortgage, rent or other loans secured on it.



# Why we like configuration management

So that we know what software we're running

- and that supposedly identical machines are actually identical

To make it easy to upgrade everything

- But: managed upgrade at a time of our choosing, not a
  surprise upgrade when we don't expect it

# Why we like configuration management: RPM

```
[root@6dc26bb8c090 /]# rpm -ql make
/usr/bin/gmake
/usr/bin/make
/usr/share/doc/make-3.82
/usr/share/doc/make-3.82/AUTHORS
/usr/share/doc/make-3.82/COPYING
/usr/share/doc/make-3.82/NEWS
/usr/share/doc/make-3.82/README
...
```

RPM is the package manager we use at SB on all our production
machines (you may also know "homebrew" or "dpkg", same principle).
When you add a package, you get all the files.  When you remove it,
they all go away

Where it falls down: 

* if you have two packages which both install a
  command called make.  Or called netcat.  Or called ruby
  
* if two apps on the same machine need different versions of packages

# Why we like configuration management: Puppet

```
  package { 'postgresql-devel':
    ensure => installed,
  }

  package { 'postgresql':
    ensure => installed,
  }
```

We fix versions of packages in Gringotts, our RPM server.  When we publish
new packages from Gringotts, clients upgrade.

Where it breaks down: 

- it only manages what's in the manifest. Deleting a package in the manifest 
  doesn't remove it from the client.

- it stops at the "provisioning" layer: would be painful to install
  Ruby applications this way

# Why we like configuration management: Bundler

```
GEM
  remote: https://rubygems.org/
  specs:
    activemodel (4.2.8)
      activesupport (= 4.2.8)
      builder (~> 3.1)
    activesupport (4.2.8)
      i18n (~> 0.7)
      minitest (~> 5.1)
      thread_safe (~> 0.3, >= 0.3.4)
      tzinfo (~> 1.1)
    addressable (2.5.1)
      public_suffix (~> 2.0, >= 2.0.2)
```

Gemfile.lock has exact version numbers of all the gems we need.

If the system we're installing can't find the gem, it fails

Where it falls down: non-Ruby dependencies (e.g. libv8, libxslt, openssl)

# How Nix is different 

```
  environment.systemPackages = with pkgs; [
     firmwareLinuxNonfree sudo pmutils 
     xorg.xcursorthemes at rsync libmbim
  ];
  
  services.openssh.enable = true;

  users.extraUsers.dan = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ];
     uid = 1000;
  };
```

* Comprehensive

Everything is a "derivation", whether it's an OS package, a Ruby module
or even a configuration file.

* Isolated environments

Each package is installed into its own subdirectory under /nix/store,
and stitched together into environments.  There is a system
environment, there are per-user environments, there are per-package
requirements - no need to reinvent RVM or virtualenv for every
possible package you might want more than one variant of.

* Explicit

The environment Nix creates for you has only what you've asked for and
its declared dependencies. You never get different results if stuff
changes on servers on the internet: if your derivation (package build
recipe) fetches from external sites, you provide a hash of what you
expect to get.


# Installation demonstration

https://is.gd/sb_nix_vbox

Visit this URL and follow the instructions, then you can play along.

* we can add a package and switch
* watch it download
* see it there in the store
* remove the package: it's gone
  (but not really gone, just unavailable)
* add it again: no download needed this time


# Per package environment: rbenvbundler 

We don't have to install our packages globally, we can use nix-shell
to ask for any combination of packages we like

* as one-liner
* with shell.nix

# Building our own packages

It's a short step from having per-package hack environments to
building our own packages.  Create default.nix loosely based on 
shell.nix plus the build instructions

* use bundix 
* change src attribute to do github


# 

