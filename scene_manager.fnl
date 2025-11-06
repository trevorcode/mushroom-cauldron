(var scene nil)
(local ebus (require :event-bus))
(local scene-manager {})

(fn scene-manager.change-scene [new-scene]
  (ebus.clear-subscriptions :scene)
  (new-scene.load)
  (set scene new-scene))

(fn scene-manager.update [dt]
  (scene.update dt))

(fn scene-manager.draw []
  (scene.draw))

(fn scene-manager.keypressed [key]
  (scene.keypressed key))

(fn scene-manager.mousepressed [x y button istouch presses]
  (scene.mousepressed x y button istouch presses))

(fn scene-manager.mousereleased [x y button istouch presses]
  (scene.mousereleased x y button istouch presses))

(fn change-scene [{: new-scene}]
  (local s (require new-scene))
  (scene-manager.change-scene s))

(ebus.subscribe :change-scene change-scene :manager)

scene-manager
