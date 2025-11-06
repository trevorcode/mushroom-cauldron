(var assets {})
(local anim8 (require :lib.anim8))

(var outline-shader-code
     "extern vec4 outlineColor;
extern vec2 stepSize; 

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screenCoords) {
    vec4 pixel = Texel(texture, uv);
    if (pixel.a > 0.0) {
      return pixel * color;
    }

    float alpha = 0.0;
    alpha += Texel(texture, uv + vec2(stepSize.x, 0.0f)).a;
    alpha += Texel(texture, uv + vec2(-stepSize.x, 0.0f)).a;
    alpha += Texel(texture, uv + vec2(0.0f, stepSize.y)).a;
    alpha += Texel(texture, uv + vec2(0.0f, -stepSize.y)).a;

    if (alpha > 0.0) {
      return outlineColor;
    }
    else {
      return vec4(0.0, 0.0, 0.0, 0.0);
    }
}
")

(fn assets.load-assets []
  (set assets.outline-shader (love.graphics.newShader outline-shader-code))
  (set assets.bell-sound (love.audio.newSource :assets/bell.wav :static))
  (set assets.complete-sound (love.audio.newSource :assets/complete.mp3 :static))
  (set assets.water-sound (love.audio.newSource :assets/water.wav :static))
  (set assets.background (love.graphics.newImage :assets/mushroomcauldronbackground.png))
  (set assets.bigbook (love.graphics.newImage :assets/bigbook.png))
  (set assets.littlebook (love.graphics.newImage :assets/littlebook.png))
  (set assets.potion (love.graphics.newImage :assets/potion.png))
  (set assets.cat-sheet (love.graphics.newImage :assets/cat.png))
  (set assets.cat-animation-grid
       (anim8.newGrid 26 20
                      (assets.cat-sheet:getWidth)
                      (assets.cat-sheet:getHeight)))
  (set assets.cauldron-sheet (love.graphics.newImage :assets/cauldron.png))
  (set assets.cauldron-animation-grid
       (anim8.newGrid 76 49
                      (assets.cauldron-sheet:getWidth)
                      (assets.cauldron-sheet:getHeight)))
  (set assets.mushroom-sheet (love.graphics.newImage :assets/mushrooms.png))
  (set assets.mushroom-animation-grid
       (anim8.newGrid 22 22
                      (assets.mushroom-sheet:getWidth)
                      (assets.mushroom-sheet:getHeight))))

assets
