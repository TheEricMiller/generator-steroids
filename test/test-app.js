/*global describe, beforeEach, it*/
'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');

describe('steroids:app', function () {
  before(function (done) {
    var deps = [
      [helpers.createDummyGenerator(), 'steroids:common'],
      [helpers.createDummyGenerator(), 'steroids:platform-config']
    ];
    helpers.run(path.join(__dirname, '../generators/app'))
      .inDir(path.join(os.tmpdir(), './temp-test'))
      .withOptions({ 'skip-install': true })
      .withPrompt({
        projectName: "testApp"
      })
      .withGenerators(deps)
      .on('end', done);
  });

  it('creates files', function () {
    assert.file([
      'bower.json',
      'package.json',
      '.gitignore',
      'Gruntfile.js',
      'www'
    ]);
  });
});
