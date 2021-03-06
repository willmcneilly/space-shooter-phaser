PreGame = require './pregame'
PostGame = require './postgame'
Game = require './game'

module.exports = class SpaceShooterGame
  constructor: () ->
    @game = new Phaser.Game 451, 750, Phaser.AUTO
    @registerStates()

  registerStates: ->
    @game.state.add('preGame', new PreGame(@game), true)
    @game.state.add('game', new Game(@game))
    @game.state.add('postGame', new PostGame(@game))


game = new SpaceShooterGame()
