
class com.scaleform.zb.utils.ZBMath
{
  public static function lerp(a:Number, b:Number, d:Number):Number {
    return (b - a) * d + a;
  }

  public static function springLerp(strength:Number, deltaTime:Number):Number
  {
    if (deltaTime > 1) deltaTime = 1;
    var ms:Number = Math.round(deltaTime * 1000);
    deltaTime = 0.001 * strength;
    var cumulative:Number = 0;
    for (var i:Number = 0; i < ms; ++i) 
      cumulative = lerp(cumulative, 1, deltaTime);
    return cumulative;
  }

  public static function springDampenX (velocity: Object, strength:Number, deltaTime:Number):Number
  {
    if (deltaTime > 1) deltaTime = 1;
    var dampeningFactor:Number = 1 - strength * 0.001;
    var ms:Number = Math.round(deltaTime * 1000);
    var totalDampening:Number = Math.pow(dampeningFactor, ms);
    var vTotal:Number = velocity["x"] * ((totalDampening - 1) / Math.log(dampeningFactor));
    velocity["x"] = velocity["x"] * totalDampening;
    return vTotal * 0.06;
  }

}