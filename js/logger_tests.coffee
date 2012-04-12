''' ========================================================================    
    logger_tests.coffee

    Contains all the unit tests for the logger

    Some common test functions
    ----------------------
    ok ( state, message ) – passes if the first argument is truthy
    equal ( actual, expected, message ) – a simple comparison assertion with
        type coercion

    notEqual ( actual, expected, message ) – the opposite of the above

    expect( amount ) – the number of assertions expected to run within each test

    strictEqual( actual, expected, message) – offers a much stricter comparison
        than equal() and is considered the preferred method of checking equality
        as it avoids stumbling on subtle coercion bugs

    deepEqual( actual, expected, message ) – similar to strictEqual, comparing 
        the contents (with ===) of the given objects, arrays and primitives.
    ======================================================================== '''
$(document).ready( ()->
    ''' ====================================================================
        Logger test
        ==================================================================== '''
    module('LOGGER: setup')
    test('logger setup', ()->
        #Just make sure we set everything up - the setup() tests will
        #   show up for this test
        #
        
        ok(logger != undefined,
            'Logger object exists')

        logger.options.log_level = 'all'
        ok(logger != undefined,
            'Logger options is "all"')

        ok(logger.history != undefined,
            'Logger history exists')

        return @
    )

    #------------------------------------
    #
    #can_log tests
    #
    #------------------------------------
    module('LOGGER: can_log()')

    #log_level = 'all'
    test("can_log: log_level='all'", ()->
        '''Make sure can_log returns proper values for log_level='all' '''
        
        equal( logger.can_log('debug'),
            true,
            'debug: can_log returns true')
        equal( logger.can_log('error'),
            true,
            'error: can_log returns true')
        equal( logger.can_log('info'),
            true,
            'info: can_log returns true')
        equal( logger.can_log('warn'),
            true,
            'warn: can_log returns true')
        return @
    )
    #log_level = 'none' (log nothing)
    test('can_log: log_level=false', ()->
        
        logger.options.log_level = 'none'

        equal( logger.can_log('debug'),
            false,
            'debug: can_log returns false')
        equal( logger.can_log('error'),
            false,
            'error: can_log returns false')
        equal( logger.can_log('info'),
            false,
            'info: can_log returns false')
        equal( logger.can_log('warn'),
            false,
            'warn: can_log returns false')
        return @
    )

    #log_level = 'warn'
    test('can_log: log_level=warn', ()->
        #Should only show warn messages
        
        logger.options.log_level = 'warn'
        equal( logger.can_log('info'),
            false,
            'info: can_log returns false')
        equal( logger.can_log('warn'),
            true,
            'warn: can_log returns true')
    )

    #log_level = ['debug', 'error']
    test("can_log: log_level=['debug', 'error']", ()->
        #Should only show warn messages
        
        logger.options.log_level = ['debug', 'error']
        equal( logger.can_log('debug'),
            true,
            'info: can_log returns true')
        equal( logger.can_log('error'),
            true,
            'error: can_log returns true')
        equal( logger.can_log('info'),
            false,
            'info: can_log returns false')
        equal( logger.can_log('warn'),
            false,
            'warn: can_log returns false')
    )

    #------------------------------------
    #
    #logger.log tests
    #
    #------------------------------------
    module('LOGGER: log()')

    log_test = (log_method)->
        '''This function is used by two tests to test
        different log methods (log() and info())'''
        
        #Set level to info
        logger.options.log_level = 'info'
        equal( logger.can_log('info'),
            true,
            'info: can_log returns false')
         
        #Clear history
        logger.history = {}

        #Info object we'll log
        meta_info = { 'answer': 42 }

        #Log a message (use log or logger.info)
        #   NOTE: These two functions should work exactly the same,
        #   that's why we're calling them like this
        if log_method == 'log'
            logger.log(
                'info',
                'some_message',
                meta_info
            )
        else if log_method == 'info'
            logger.info(
                'some_message',
                meta_info
            )
    
        #Now check history
        ok(logger.history.info,
            'history:info: key exists')
        equal(logger.history.info.length,
            1,
            'history:info: key length is 1 after logging')
        #Check info about history, make sure message was saved properly
        equal(logger.history.info[0][0],
            'info',
            'history:info: first item in log is info (the log type)'
        )
        equal(logger.history.info[0][1],
            'some_message',
            'history:info: second item in log is message ("some_message")'
        )
        equal(logger.history.info[0][2],
            meta_info,
            'history:info: third item in log is our passed in object (meta_info)'
        )

    #Now the tests
    test("log(): test log('info', ...) call", ()->
        log_test('log')
    )
    test("info(): test info(...) call", ()->
        log_test('info')
    )
)
