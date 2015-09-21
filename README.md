trekky
======

Simple, very simple, sass and haml compiler for dear designer friend. 

## Features

Say you have a file structure like this:

    source
    ├── images
    │   └── image.jpg
    ├── index.html.haml
    ├── javascripts
    │   └── app.js
    ├── layouts
    │   └── default.haml
    └── stylesheets
        └── hola.css.sass
  
And you run: 

    trekky -s source -t public
    
You'll end up having this:

    public
    ├── images
    │   └── image.jpg
    ├── index.html
    ├── javascripts
    │   └── app.js
    └── stylesheets
        └── hola.css

## Multi-locale support

If you put this on config.rb: 

    Trekky.locales = [:en, :es]

The site will be rendered in two directories, one for each language, with the 'locale' env variable loaded up, so you can do something like this:

    ENV['locale'] == "en"

## HELP

    trekky  -h
    usage: trekky [-h] [-s source] [-t target]


## Deamon mode

Monitors source dir for changes, and copy/process on demand to target dir. 
    
    trekky -d
    
