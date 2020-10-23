#! /usr/bin/env -S node -r esm

//
// Mathjax options
//
const mjopt = {}
mjopt.inline = false;    // process as inline math
mjopt.em = 16;          // em-size in pixels
mjopt.ex = 8;           // ex-size in pixels
mjopt.width = 80 * 16;  // width of container in pixels
mjopt.fontCache = true;
mjopt.assistiveMml = false;
mjopt.dist = false;

//
// Configure MathJax
//
MathJax = {
    options: {
        enableAssistiveMml: mjopt.assistiveMml
    },
    loader: {
        paths: {mathjax: 'mathjax-full/es5'},
        source: (mjopt.dist ? {} : require('mathjax-full/components/src/source.js').source),
        require: require,
        load: ['adaptors/liteDOM', 'input/mml/entities']
    },
    startup: {
        typeset: false
    },
    svg: {
        fontCache: (mjopt.fontCache ? 'local' : 'none')
    }
}

//
//  Load the startup modules
//
require('mathjax-full/' + (mjopt.dist ? 'es5' : 'components/src/mml-svg') + '/mml-svg.js');
const sharp = require('sharp');

//
//  Wait for MathJax to start up, and then typeset the math
//
MathJax.startup.promise.then(() => {

    const jayson = require('jayson');

    // create a server
    const server = jayson.server({
      mathml2svg: function(args, callback) {
        MathJax.mathml2svgPromise(args[0] || '', {
            display: !mjopt.inline,
            em: mjopt.em,
            ex: mjopt.ex,
            containerWidth: mjopt.width
        }).then((node) => {
            const adaptor = MathJax.startup.adaptor;
            // output as svg
            callback(null, (adaptor.outerHTML(node)));
        }).catch((err) => {
            console.log(err)
            callback(null, ''); // return empty string for predictable (=empty string) error handling in python
          });
      },
      svg2png: function(args, callback) {
        svgBuffer = Buffer.from(args[0]);
        sharp(svgBuffer)
          .png()
          .toBuffer()
          .then( data => { callback(null, data.toString('base64')); })
          .catch( err => { console.log(err); callback(null, ''); });
      }
    });

    server.http().listen(3000);

}).catch(err => console.log(err));