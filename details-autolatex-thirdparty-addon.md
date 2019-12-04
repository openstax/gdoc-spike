## Autolatex Google Docs Addon

From reading this article [How to write academic documents with Google Docs](https://lcolladotor.github.io/2019/04/02/how-to-write-academic-documents-with-googledocs/) I’ve found this plugin:

**Auto-LaTeX Equations**

Google Drive Addon with over 300,000 installations: https://gsuite.google.com/marketplace/app/autolatex_equations/850293439076
Homepage: http://autolatex.com

* It provides Latex equations rendered and editable again with one click. They only need to be enclosed by `$$` at the beginning and the end
* Plugin seems to use heavily [Codecogs Latex Editor](https://www.codecogs.com/latex/eqneditor.php) on the fly LaTeX rendering capabilities.
* When no add on is installed the equation is still visible. Test document you can view: https://docs.google.com/document/d/11blgrC6LL66JzaIM2wuOd1FDktjfBDRgmxxDGnVg964/edit?usp=sharing

### How codecogs on the fly latex image rendering service works

When you open [Codecogs Latex Editor](https://www.codecogs.com/latex/eqneditor.php) you can type in LaTeX equations and get a link to a gif.

E.g. on the equation `x^2` you get the this image url:

```
https://latex.codecogs.com/gif.latex?x%5E2
```

which looks rendered like this:

![](https://latex.codecogs.com/gif.latex?x%5E2)

Auto-LaTeX equations can url encrypt and decrypt from/to codecogs url parameters to text and back to an image. This is how it works.