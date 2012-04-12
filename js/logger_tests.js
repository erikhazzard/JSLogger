' ========================================================================    \nlogger_tests.coffee\n\nContains all the unit tests for the logger\n\nSome common test functions\n----------------------\nok ( state, message ) – passes if the first argument is truthy\nequal ( actual, expected, message ) – a simple comparison assertion with\n    type coercion\n\nnotEqual ( actual, expected, message ) – the opposite of the above\n\nexpect( amount ) – the number of assertions expected to run within each test\n\nstrictEqual( actual, expected, message) – offers a much stricter comparison\n    than equal() and is considered the preferred method of checking equality\n    as it avoids stumbling on subtle coercion bugs\n\ndeepEqual( actual, expected, message ) – similar to strictEqual, comparing \n    the contents (with ===) of the given objects, arrays and primitives.\n======================================================================== ';
$(document).ready(function() {
  ' ====================================================================\nLogger test\n==================================================================== ';
  var log_test;
  module('LOGGER: setup');
  test('logger setup', function() {
    ok(logger !== void 0, 'Logger object exists');
    logger.options.log_level = 'all';
    ok(logger !== void 0, 'Logger options is "all"');
    ok(logger.history !== void 0, 'Logger history exists');
    return this;
  });
  module('LOGGER: can_log()');
  test("can_log: log_level='all'", function() {
    'Make sure can_log returns proper values for log_level=\'all\' ';    equal(logger.can_log('debug'), true, 'debug: can_log returns true');
    equal(logger.can_log('error'), true, 'error: can_log returns true');
    equal(logger.can_log('info'), true, 'info: can_log returns true');
    equal(logger.can_log('warn'), true, 'warn: can_log returns true');
    return this;
  });
  test('can_log: log_level=false', function() {
    logger.options.log_level = 'none';
    equal(logger.can_log('debug'), false, 'debug: can_log returns false');
    equal(logger.can_log('error'), false, 'error: can_log returns false');
    equal(logger.can_log('info'), false, 'info: can_log returns false');
    equal(logger.can_log('warn'), false, 'warn: can_log returns false');
    return this;
  });
  test('can_log: log_level=warn', function() {
    logger.options.log_level = 'warn';
    equal(logger.can_log('info'), false, 'info: can_log returns false');
    return equal(logger.can_log('warn'), true, 'warn: can_log returns true');
  });
  test("can_log: log_level=['debug', 'error']", function() {
    logger.options.log_level = ['debug', 'error'];
    equal(logger.can_log('debug'), true, 'info: can_log returns true');
    equal(logger.can_log('error'), true, 'error: can_log returns true');
    equal(logger.can_log('info'), false, 'info: can_log returns false');
    return equal(logger.can_log('warn'), false, 'warn: can_log returns false');
  });
  module('LOGGER: log()');
  log_test = function(log_method) {
    'This function is used by two tests to test\ndifferent log methods (log() and info())';
    var meta_info;
    logger.options.log_level = 'info';
    equal(logger.can_log('info'), true, 'info: can_log returns false');
    logger.history = {};
    meta_info = {
      'answer': 42
    };
    if (log_method === 'log') {
      logger.log('info', 'some_message', meta_info);
    } else if (log_method === 'info') {
      logger.info('some_message', meta_info);
    }
    ok(logger.history.info, 'history:info: key exists');
    equal(logger.history.info.length, 1, 'history:info: key length is 1 after logging');
    equal(logger.history.info[0][0], 'info', 'history:info: first item in log is info (the log type)');
    equal(logger.history.info[0][1], 'some_message', 'history:info: second item in log is message ("some_message")');
    return equal(logger.history.info[0][2], meta_info, 'history:info: third item in log is our passed in object (meta_info)');
  };
  test("log(): test log('info', ...) call", function() {
    return log_test('log');
  });
  return test("info(): test info(...) call", function() {
    return log_test('info');
  });
});
