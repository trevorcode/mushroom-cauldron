(local util (require :util))
(local anim8 (require :lib.anim8))
(local ebus (require :event-bus))
(local assets (require :assets))

(local lg love.graphics)

(fn update [cauldron notes dt]
  (cauldron.animation:update dt)
  (when cauldron.pressed? 
    (set cauldron.pressed? (- cauldron.pressed? 1))
    (when (<= cauldron.pressed? 0)
      (set cauldron.pressed? nil)
      (set cauldron.animation cauldron.animations.idle)))
  (set cauldron.hover? (util.cursor-within? cauldron))
  (set cauldron.clicked? (and cauldron.hover? (love.mouse.isDown 1))))

(fn draw [cauldron]
  (lg.setColor 1 1 1)
  (when (or cauldron.hover?
            cauldron.pressed?) 
    (lg.setShader assets.outline-shader)
    (assets.outline-shader:send "outlineColor" [1 1 1 1])
    (local (w h) (assets.cauldron-sheet:getDimensions))
    (assets.outline-shader:send "stepSize" [(/ 1 w) (/ 1 h)]))
  (cauldron.animation:draw assets.cauldron-sheet cauldron.x cauldron.y 0 2 2)
  (lg.setShader))

(fn activate [cauldron]
  (set cauldron.pressed? 10)
  (ebus.push :cauldron-cleared {})
  (set cauldron.animation cauldron.animations.idle)
  (set cauldron.empty true)
  (: (assets.water-sound:clone) :play))

(fn on-click [cauldron]
  (when (util.cursor-within? cauldron)
    (activate cauldron)))

(fn keypressed [cauldron key]
  (when (= :space key)
    (activate cauldron)))

(fn mushroom-played [cauldron]
  (set cauldron.animation cauldron.animations.active)
  (set cauldron.empty false))

(fn song-played [cauldron]
  (set cauldron.animation cauldron.animations.idle)
  (set cauldron.empty true))

(fn new [{: x : y : width : height &as cauldron}]
  (set cauldron.animations
       {:idle (anim8.newAnimation (assets.cauldron-animation-grid 1 1) 1)
        :active (anim8.newAnimation (assets.cauldron-animation-grid "1-11" 1) 0.1)})
  (set cauldron.animation cauldron.animations.idle)
  (let [c cauldron]
    (ebus.subscribe :note-played (partial mushroom-played c))
    (ebus.subscribe :song-played (partial song-played c))
    c))

{: new : draw : update : keypressed : on-click}
