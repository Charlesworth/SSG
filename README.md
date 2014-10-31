SSG - Static Site Generator
===

A Static Site Generator in ruby (so nothing new!). This is very much WIP and a hobby project so commits may be few and far between and the git history will be messy. Features:

- Primarily for use with my own, super simple markup syntax: WebSpeak
- also works with Markdown (using the great Redcarpet gem)
- Will produce very simple blog websites with a generated index page
- Simple UI for site generation that anyone can use, will be a web page itself
- Theme-able: can use different bootstrap themes straight for unique styles

This project started off as a little project to produce a blog plugin for my already created website, rather than having to build my website around the blog.

How to run it
===

The website is made using the markdown docs and pictures found in the "Input" directory. Each one of the text or markdown doc files will become a web page on your site, with an autogenerated index page. The pictures on in Input will also be useable on the website if referenced in a text doc.

Once you're happy with the contents of Input, run launch.rb from the top level directory of the project. Your website will be output in the "Website" directory.

