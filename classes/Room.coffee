if !window?
  `var define = require('amdefine')(module)`
else
  define = window.define

define (require, exports, module) ->
  SyncedClass = require './SyncedClass'
  _ = require 'underscore'

  class Room extends SyncedClass
    constructor: (socket, settings) ->
      super 'Room', socket

      @running = false
      @users = []

      @loadSettings settings

      @room = @getSocketRoomName()

    loadSettings: (settings) ->
      @id = settings['id']
      @set 'settings', settings, false

    getSetting: (key) ->
      return @get('settings')[key]

    getSocketRoomName: () ->
      return 'room' + @id

    addUser: (user) ->
      @users.push(user)
      console.log "Added user", user['id'], "to room", @id
      @addSocket user.getSocket()
      user.getSocket().emit 'newRoom', {settings: @get 'settings'}

    removeUser: (user) ->
      @users = _.filter @users, (elem) ->
        return user['id'] != elem['id']
      @removeSocket user.getSocket()

  module.exports = Room