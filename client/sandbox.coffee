# 
# # Sandbox
# 
# Code pertaining to a generic Sandboxing function.
# 




# Set up the eval environment.
SANDBOX_SETUP = """
<script>
var MSIE/*@cc_on =1@*/;
parent.__cling.sandbox = MSIE ?
  this :
  { eval: function (code) { return eval(code) }}

/*
// Set up our references.
this.console = {log: parent.__cling.log}
*/
</script>
"""


# A class which allows for code isolation inside of an iframe.
class Sandbox
  constructor: ->
    @_log =
      console: []
    
    
    @_iframe = document.createElement 'iframe'
    #@_iframe.iframe.style.display = 'none'
    document.body.appendChild @_iframe
    @_document = frames[frames.length - 1].document
    
    # Define our object so we can trade some objects between scopes
    cling = window.__cling = {}
    cling.console = {log: @_consolelog}
    
    # Set up our sandbox environment
    @_document.write SANDBOX_SETUP
    
    # And grab the reference to our sandbox function.
    @__sandbox_eval = window.__cling.sandbox.eval
    
    # Now remove our cling object from the global environment.
    delete window.__cling
  
  _log: (s) =>
    @_log.console.push s
  
  eval: (code) ->
    __sandbox_eval code




exports.Sandbox