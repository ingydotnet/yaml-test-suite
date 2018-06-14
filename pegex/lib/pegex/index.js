// Generated by CoffeeScript 2.3.1
(function() {
  /*
  name:      Pegex
  abstract:  Acmeist PEG Parsing Framework
  author:    Ingy döt Net <ingy@ingy.net>
  license:   MIT
  copyright: 2010-2018
  */
  global.Pegex = (function() {
    class Pegex {};

    Pegex.prototype.version = '0.1.7';

    return Pegex;

  }).call(this);

  exports.pegex = function(grammar, receiver) {
    if (grammar == null) {
      throw "Argument 'grammar' required in function 'pegex'";
    }
    if (typeof grammar === 'string' || grammar instanceof Pegex.Input) {
      require('../pegex/grammar');
      grammar = new Pegex.Grammar({
        text: grammar
      });
    }
    if (receiver == null) {
      require('../pegex/tree/wrap');
      receiver = new Pegex.Tree.Wrap;
    } else if (typeof receiver === String) {
      receiver = require(receiver);
      receiver = new receiver;
    }
    require('../pegex/parser');
    return new Pegex.Parser({
      grammar: grammar,
      receiver: receiver
    });
  };

  exports.require = function(name) {
    return require(require('path').join(__dirname, name));
  };

}).call(this);
