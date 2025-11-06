(var scene nil)
(local scene-manager {})

(fn scene-manager.change-scene [new-scene]
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

scene-manager
