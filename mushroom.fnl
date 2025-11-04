(local util (require :util))
(local push (require :lib.push))
(local ebus (require :event-bus))
(local util (require :util))

(local lg love.graphics)

(fn update [mushroom dt]
  (when mushroom.pressed? 
    (if (<= mushroom.pressed? 0)
        (set mushroom.pressed? nil)
        (set mushroom.pressed? (- mushroom.pressed? 1))))
  (set mushroom.hover? (util.cursor-within?  mushroom))
  (set mushroom.clicked? (and mushroom.hover? (love.mouse.isDown 1))))

(fn draw [mushroom]
  (if mushroom.hover? 
      (lg.setColor 0.2 0.2 1)
      (lg.setColor 0.8 0.8 1)) 
  (when mushroom.clicked?
    (lg.setColor 0.1 0.8 1))
  (when mushroom.pressed?
    (lg.setColor 0.8 0.2 1))
  (lg.rectangle :fill mushroom.x mushroom.y mushroom.width mushroom.height))

(fn activate [mushroom]
  (when mushroom.pitch 
    (set mushroom.pressed? 10)
    (let [s (mushroom.sound:clone)]
      (s:setPitch mushroom.pitch)
      (s:play))))

(fn on-click [mushroom event]
  (when (util.cursor-within? mushroom)
    (activate mushroom)))

(fn keypressed [mushroom {: key}]
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

(fn new [{: x : y : width : height : img : sound
          : tone : sound &as mushroom}]
  (set mushroom.pitch (tone->pitch tone))
  (set mushroom.key (tone->keybind tone))
  (let [m mushroom]
    (ebus.subscribe :mousepressed (partial on-click m))
    (ebus.subscribe :keypressed (partial keypressed m))
    m))

{: new : draw : update : on-click}
