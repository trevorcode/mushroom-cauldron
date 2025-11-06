(local util (require :util))
(local anim8 (require :lib.anim8))
(local ebus (require :event-bus))
(local assets (require :assets))

(local lg love.graphics)

(fn update [mushroom dt]
  (mushroom.animation:update dt)
  (when mushroom.pressed? 
    (set mushroom.pressed? (- mushroom.pressed? 1))
    (when (<= mushroom.pressed? 0)
      (set mushroom.pressed? nil)
      (set mushroom.animation mushroom.animations.idle)))
  (set mushroom.hover? (util.cursor-within? mushroom))
  (set mushroom.clicked? (and mushroom.hover? (love.mouse.isDown 1))))

(fn draw [mushroom]
  (lg.setColor 1 1 1)
  (when (or mushroom.hover?
            mushroom.pressed?) 
    (lg.setShader assets.outline-shader)
    (assets.outline-shader:send "outlineColor" [1 1 1 1])
    (local (w h) (assets.mushroom-sheet:getDimensions))
    (assets.outline-shader:send "stepSize" [(/ 1 w) (/ 1 h)]))
  (mushroom.animation:draw assets.mushroom-sheet mushroom.x mushroom.y 0 2 2)
  (lg.setShader))

(fn activate [mushroom]
  (when mushroom.pitch 
    (set mushroom.pressed? 10)
    (let [s (mushroom.sound:clone)]
      (ebus.push :note-played {:note mushroom.tone})
      (set mushroom.animation mushroom.animations.active)
      (mushroom.animation:gotoFrame 1)
      (mushroom.animation:resume)
      (s:setPitch mushroom.pitch)
      (s:play))))

(fn on-click [mushroom]
  (when (util.cursor-within? mushroom)
    (activate mushroom)))

(fn keypressed [mushroom key]
  (when (= mushroom.key key)
    (activate mushroom)))

(fn tone->keybind [tone]
  (case tone
    :c :q
    :d :w
    :e :e
    :f :r
    :g :u
    :a :i
    :b :o
    :high-c :p
    _ nil))

(fn tone->pitch [tone]
  (case tone
    :c 1.0
    :d (^ 2 (/ 2 12))
    :e (^ 2 (/ 4 12))
    :f (^ 2 (/ 5 12))
    :g (^ 2 (/ 7 12))
    :a (^ 2 (/ 9 12))
    :b (^ 2 (/ 11 12))
    :high-c 2
    _ nil))

(fn tone->anim-column [tone]
  (case tone
    :c 1
    :d 4
    :e 6
    :f 2
    :g 7
    :a 3
    :b 5
    :high-c 8
    _ nil))

(fn new [{: x : y : width : height
          : tone : sound &as mushroom}]
  (set mushroom.pitch (tone->pitch tone))
  (set mushroom.key (tone->keybind tone))
  (set mushroom.animations
       {:idle (anim8.newAnimation (assets.mushroom-animation-grid 1 (tone->anim-column tone)) 1)
        :active (anim8.newAnimation (assets.mushroom-animation-grid "1-4" (tone->anim-column tone) 1 (tone->anim-column tone)) 0.05 :pauseAtEnd)})
  (set mushroom.animation mushroom.animations.idle)
  mushroom
  )

{: new : draw : update : on-click : keypressed }
