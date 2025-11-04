(local util (require :util))
(local push (require :lib.push))

(local lg love.graphics)

(fn update [mushroom dt]
  (let [(x y) (push:toGame (love.mouse.getPosition))
        point {:x x :y y}]
    (set mushroom.hover? (util.point-within? point mushroom))
    (set mushroom.clicked? (and mushroom.hover? (love.mouse.isDown 1)))))

(fn draw [mushroom]
  (if mushroom.hover? 
      (lg.setColor 0.2 0.2 1)
      (lg.setColor 0.8 0.8 1)) 
  (when mushroom.clicked?
    (lg.setColor 0.1 0.8 1))
  (when mushroom.pressed?
    (lg.setColor 0.8 0.2 1))
  (lg.rectangle :fill mushroom.x mushroom.y mushroom.width mushroom.height))

(fn on-click [mushroom]
  (set mushroom.pressed? true)
  (print "Hello world"))

(fn new [{: x : y : width : height : img : sound}]
  {: x : y : img : sound : width : height})

{: new : draw : update : on-click}
