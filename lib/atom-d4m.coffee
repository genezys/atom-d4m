{ CompositeDisposable } = require 'atom'
process = require 'child_process'


module.exports =

  config:
    watched_paths:
      title: "Watched Paths"
      description: "List of paths where a file saved will trigger a touch in D4M"
      type: "array"
      default: []
      items:
        type: "string"

  subscriptions: null

  activate: (state)->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable();

    @subscriptions.add atom.workspace.observeTextEditors (editor)=>
      editor.onDidSave (e)=>
        @onSave(e.path)

  onSave: (path)->
    for watched_path in atom.config.get("atom-d4m.watched_paths")
      if path[0...watched_path.length] == watched_path
        @touch(path)

  touch: (path)->
    command = "screen -S d4m -p 0 -X stuff \"touch \\\"#{path}\\\"\n\""
    console.log command
    process.spawn "/bin/bash", [command]

  deactivate: ->
    @subscriptions.dispose()
