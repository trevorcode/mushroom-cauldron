(local ebus (require :event-bus))
(local assets (require :assets))
(local songs (require :songs))
(local flux (require :lib.flux))

(local lg love.graphics)

(fn load-assets []
  (set assets.customers (lg.newImage :assets/customers.png))
  (set assets.tab (lg.newImage :assets/chartab.png)))

(fn update [cauldron notes dt])

(fn draw [tab]
  (lg.setColor 1 1 1 0.8)
  (lg.draw assets.tab tab.x tab.y 0 2.5 2)
  (lg.setColor 1 1 1 1)
  (lg.draw assets.customers tab.character-img tab.x tab.y 0 2 2)
  (lg.print tab.song.name (+ 36 tab.x) (+ 8 tab.y)))

(fn new []
  (let [portraits [(lg.newQuad 0 0 16 16 assets.customers)
                   (lg.newQuad 16 0 16 16 assets.customers)
                   (lg.newQuad 32 0 16 16 assets.customers)]
        song (table.remove songs (love.math.random (length songs)))
        img (. portraits (love.math.random 3))
        new-tab {:character-img img :x -100 :y 20
                 :song song}]
    (-> (flux.to new-tab 2 {:x 0})
        (: :ease "elasticout"))
    new-tab))

(fn dismiss [tab callback]
  (-> (flux.to tab 1 {:x -200})
      (: :ease "quadout")
      (: :oncomplete callback)))

{: new : draw : update : load-assets : dismiss}
