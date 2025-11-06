(local util (require :util))
(local ebus (require :event-bus))
(local assets (require :assets))

(local lg love.graphics)

(fn update [book dt]
  (when book.pressed? 
    (set book.pressed? (- book.pressed? 1))
    (when (<= book.pressed? 0)
      (set book.pressed? nil)))
  (set book.hover? (util.cursor-within? book)))

(fn draw [book]
  (when (or book.hover? book.pressed?) 
    (lg.setShader assets.outline-shader)
    (assets.outline-shader:send "outlineColor" [1 1 1 1])
    (local (w h) (assets.littlebook:getDimensions))
    (assets.outline-shader:send "stepSize" [(/ 1 w) (/ 1 h)]))
  (lg.draw assets.littlebook book.x book.y 0 2 2)
  (lg.setShader))

(fn activate [book]
  (set book.pressed? 10)
  (: (assets.water-sound:clone) :play))

(fn on-click [book]
  (when (util.cursor-within? book)
    (activate book)))

(fn keypressed [book key]
  (when (= :h key)
    (activate book)))

(fn new [{: x : y &as book}]
  (let [(w h) (assets.littlebook:getDimensions)]
    (tset book :width (* 2 w))
    (tset book :height (* 2 h))
    book))

{: new : draw : update : keypressed : on-click}
