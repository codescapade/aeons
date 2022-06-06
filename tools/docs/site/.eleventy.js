const syntaxHighlight = require('@11ty/eleventy-plugin-syntaxhighlight');
const markdownIt = require('markdown-it');

const MARKDOWN_OPTIONS = {
  html: true,
  breaks: false,
  linkify: true
};
const markdownLibrary = markdownIt(MARKDOWN_OPTIONS);

module.exports = (config) => {
  config.addPlugin(syntaxHighlight);
  config.addPassthroughCopy('src/static');

  config.setLibrary("md", markdownLibrary);


  return {
    markdownTemplateEngine: 'njk',
    dataTemplateEngine: 'njk',
    htmlTemplateEngine: 'njk',
    dir: {
      input: 'src',
      output: '../../../docs'
    },
    pathPrefix: '/aeons/'
  };
};
