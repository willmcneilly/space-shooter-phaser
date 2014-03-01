PreGame = require './pregame'
PostGame = require './postgame'
Game = require './game'

module.exports = class SpaceShooterGame
  constructor: () ->
    @game = new Phaser.Game 400, 400, Phaser.AUTO
    @registerStates()

  registerStates: ->
    @game.state.add('preGame', new PreGame(@game))
    @game.state.add('game', new Game(@game), true)
    @game.state.add('postGame', new PostGame(@game))


game = new SpaceShooterGame()
