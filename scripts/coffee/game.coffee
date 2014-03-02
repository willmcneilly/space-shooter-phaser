FPS = require './fps'

module.exports = class Game
  constructor: (game) ->
    @game = game

  preload: ->
    @game.load.image('bg', '/assets/images/background.png')
    @game.load.image('player', '/assets/images/player-ship.png')
    @game.load.image('enemy1', '/assets/images/enemy-green.png')
    @game.load.image('enemy2', '/assets/images/enemy-red.png')
    @game.load.image('enemy3', '/assets/images/enemy-yellow.png')
    @game.load.image('powerUp', '/assets/images/star-gold.png')
    @game.load.image('laser', '/assets/images/laser-green.png')

  create: ->
    @playerVelocity = 400
    @laserVelocity = 500
    @enemyVelocity = 100
    @baseEnemyVelocity = 100
    @cursor = null
    @lives = 3
    @score = 0
    @timeBetweenLaserBeams = 200
    @laserDelta = 0
    @averageEnemySpawnTime = 600
    @enemyDelta = 0
    @score = 0
    @lives = 3

    @background = @game.add.sprite(0, 0, 'bg')
    @createPlayer()
    @createLasers()
    @createEnemies()
    @createScoreText()
    @createLivesText()
    @cursor = @game.input.keyboard.createCursorKeys()
    @startTime = @game.time.now

  update: ->
    @player.body.velocity.x = 0

    if @cursor.left.isDown
      @player.body.velocity.x = -@playerVelocity
    else if @cursor.right.isDown
      @player.body.velocity.x = @playerVelocity

    if @cursor.up.isDown
      @fire()

    @updateEnemySpeed()
    @spawnEnemy()
    @updateScoreText()
    @updateLivesText()

    @game.physics.overlap(@player, @enemies, @playerHit, null, this)
    @game.physics.overlap(@lasers, @enemies, @enemyHit, null, this)

  createPlayer: ->
    @player = @game.add.sprite(0, 0, 'player')
    @player.body.collideWorldBounds = true
    @player.y = (@game.height - @player.height) - 20
    @player.x = @game.width / 2 - @player.width / 2

  createLasers: ->
    @lasers =  @game.add.group()
    @lasers.createMultiple(25, 'laser')
    @lasers.setAll('outOfBoundsKill', true)

  createEnemies: ->
    @enemies =  @game.add.group()
    @enemies.createMultiple(25, 'enemy1')
    @enemies.setAll('outOfBoundsKill', true)
    @enemies.setAll('scale.x', 0.5)
    @enemies.setAll('scale.y', 0.5)

  fire: ->
    if @game.time.now > @laserDelta
      @spawnOneLaserBeam()
      @laserDelta = @game.time.now + @timeBetweenLaserBeams
      bounce = @game.add.tween(@player)
      bounce
        .to({ y: @player.y + 5 }, 80, Phaser.Easing.Bounce.None)
        .to({ y: @player.y }, 80, Phaser.Easing.Bounce.None)
        .start()

  spawnOneLaserBeam: ->
    laser = @lasers.getFirstExists(false)
    laser.reset(@player.x + (@player.width / 2 - 3), @player.y)
    laser.body.velocity.y =- @laserVelocity

  spawnEnemy: ->
    if @game.time.now > @enemyDelta
      @spawnOneEnemy()
      @enemyDelta = @game.time.now + @enemySpawnTime()

  createScoreText: ->
    @scoreText = @game.add.text(20, 20, @score, { fontSize: '14px', fill: 'white'})

  createLivesText: ->
    @livesText = @game.add.text(0, 0, @lives, { fontSize: '14px', fill: 'white'})
    @livesText.anchor = new Phaser.Point(1,0)
    @livesText.x = @game.width - 20
    @livesText.y = 20

  enemySpawnTime: ->
    spawnTimeRange = @averageEnemySpawnTime * 0.2
    upper = @averageEnemySpawnTime + spawnTimeRange
    lower = @averageEnemySpawnTime - spawnTimeRange
    return @game.rnd.integerInRange(lower, upper)

  spawnOneEnemy: ->
    enemy = @enemies.getFirstExists(false)
    enemy.reset(@game.rnd.realInRange(enemy.width, @game.world.width - enemy.width), -enemy.width)
    enemy.body.velocity.y =+ @enemyVelocity
    tween = @game.add.tween(enemy.scale)
    tween
      .to({ x: 0.3, y: 0.3 }, 500, Phaser.Easing.Bounce.IN, true, 90, true, true)

  playerHit: (player, enemy) ->
    enemy.kill()
    bounce = @game.add.tween(@player)
    bounce
      .to({ alpha: 0.4 }, 100, Phaser.Easing.Bounce.None)
      .to({ alpha: @player.alpha }, 100, Phaser.Easing.Bounce.None)
      .start()
    if (@lives == 1)
      @player.kill()
      @game.state.start('postGame', false)
    @lives -= 1

  enemyHit: (laser, enemy) ->
    laser.kill()
    enemy.kill()
    @score += 1

  updateScoreText: ->
    @scoreText.content = @score

  updateLivesText: ->
    @livesText.content = @lives
    if @lives is 1
      f = @livesText.font
      f.fill = '#ff0000'
      @livesText.setStyle(f)


  updateEnemySpeed: ->
    velocityAddOn = (@game.time.now - @startTime) / 1000
    @enemyVelocity = @baseEnemyVelocity + velocityAddOn
