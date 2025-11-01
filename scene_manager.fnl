(var scene nil)

(fn change-scene [new-scene]
  (new-scene.load)
  (set scene new-scene))

(fn update [dt]
  (scene.update dt))

(fn draw []
  (scene.draw))

(fn keypressed [key]
  (scene.keypressed key))

{: change-scene : update : draw : keypressed}
