
import com.scaleform.zb.utils.ZBMath;
//refer form tween.as
class com.scaleform.zb.motion.Spring extends MovieClip {

  private static var _instance = new Spring();

  

  private var spring_props:Object;
  private var spring_strength:Number;
  private var spring_timer:Number;
  
  private function Spring() {
    MovieClip.prototype.springTo = springTo;
    MovieClip.prototype.springEnd = springEnd;
    MovieClip.prototype.spring__start = spring__start;
    MovieClip.prototype.spring__to = spring__to;
    MovieClip.prototype.spring__run = spring__run;
  }

  // Public Methods:
  /**
   * Initialize the tween functions in the MovieClip class.  Once initialized, any MovieClip can make use of the Tween methods.
   * @return Whether Tween was initialized in the current call. If Tween was already initialized, it will return {@code false}.
   */
  public static function init():Boolean {
    if (_instance != null) { return false; }
    _instance = new Spring();
  }
  
  public function springTo(props:Object, strength:Number):Void {
    spring__start(props, strength);
  }

  public function springEnd():Void {
    for (var n:String in spring_props) {
      this[n] = spring_props[n];
    }
    delete(spring_props);
    delete(spring_strength);
    delete(spring_timer);
    delete(onEnterFrame);
  }
  // Private Methods
  private function spring__start(props:Object, strength:Number):Void {
    spring_props = props;
    spring_strength = strength;
    spring_timer = getTimer();
    onEnterFrame = spring__run;
  }

  private function spring__to(props:Object):Void {
    for (var n:String in props) {
      this[n] = props[n];
    }
  }
  private function spring__run():Void {
    var before:Object = {};
    var after:Object = {};
    var delta_time:Number;
    var spring_delta:Number;
    var offset:Number = 0;
    delta_time = getTimer() - spring_timer;
    spring_delta = ZBMath.springLerp(spring_strength, delta_time);
    for (var n:String in spring_props) {
      before[n] = this[n];
      after[n] = ZBMath.lerp(this[n], spring_props[n], spring_delta);
      offset += Math.sqrt(spring_props[n] - after[n]);
    }
    if(offset < 1) {
        springEnd();
        trace("end");
        if(this["onSpringComplete"])
          this["onSpringComplete"]();
      } else {
        spring__to(after);
      }

  }


}