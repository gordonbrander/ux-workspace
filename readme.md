UX Workspace
============

Getting started
---------------

Uses [Wintersmith](https://github.com/jnordberg/wintersmith). You'll have to
install it:

    npm install -g wintersmith

Then, you'll want to install the site dependencies:

    cd ~/path/to/wintersmith-blog/
    npm install

You can write and preview your work locally:

    wintersmith preview

"Bake" your changes into static files:

    wintersmith build


Creating a new page/article
---------------------------

Create a new file anywhere in the `contents/` folder. Name it with the
appropriate file extension. We currently have plugins installed for:

* [Markdown](http://daringfireball.net/projects/markdown/): `yourfile.md`
* [Nunjucks](http://jlongster.github.io/nunjucks/): `yourfile.html`
* [Stylus](http://learnboost.github.io/stylus/): `yourfile.styl`

Here's what a file should look like:

    ---
    title: Hello!
    date: 2012-10-01 15:00
    template: cinematic.html
    ---
    
    My content goes here!

Templated files files require a _head_ section (the bit between the `---`),
written [YAML-style](http://yaml.org/).

All fields are optional except the `template` field. `template` tells
Wintersmith which template to use for rendering the content. The other fields
are just meta data exposed to the template as variables. You can add as many
or as few as you like.
