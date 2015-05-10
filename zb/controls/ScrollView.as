
import flash.external.ExternalInterface; 
import gfx.core.UIComponent;
import gfx.ui.InputDetails;
import com.scaleform.zb.utils.ZBMath;
import com.scaleform.zb.motion.Spring;
//import com.scaleform.zb.controls.ImageScroller;

[InspectableList("minimum", "maximum")]
class com.scaleform.zb.controls.ScrollView extends UIComponent {
  public var item:MovieClip;
  public var momentumAmount:Number = 35;

  [Inspectable(defaultValue=0, verbose=1)]
  private var offsetLeft:Number = 0;

  // Private Properties:
  private var _value:Number = 0;
  private var _minimum:Number = 0;
  private var _maximum:Number = 10;
  private var dragOffset:Object;
  private var _momentum:Object = 0;
  private var shouldMove:Boolean = false; // hai mei yong shang
  private var _lastPos:Number = 0;
  private var isPressed:Boolean = false;
  private var _scroll:Number = 0;
  private var _timer:Number = 0;
  private var _originX:Number = 0;


  private var thumbPressed:Boolean = false;
  public function ScrollView() { 
    super();
    Spring.init();
  }

  // Public Methods:

  public function get currentMomentum():Object { return _momentum;}
  public function set currentMomentum(value:Number):Void {
    _momentum = {x: value};
    shouldMove = true;
  }

  /**
   * The maximum number the {@code value} can be set to.
   */
  [Inspectable(defaultValue="10")]
  public function get maximum():Number { return _maximum; }
  public function set maximum(value:Number):Void {
    _maximum = value;
    //invalidate();
  }
  
  /**
   * The minimum number the {@code value} can be set to.
   */
  [Inspectable(defaultValue="0")]
  public function get minimum():Number { return _minimum; }
  public function set minimum(value:Number):Void {
    _minimum = value;
    //invalidate();
  } 

  /**
   * The value of the slider between the {@code minimum} and {@code maximum}.
   * @see #maximum
   * @see #minimum
   */
  [Inspectable(defaultValue="0")]
  public function get value():Number { return _value; }
  public function set value(value:Number):Void {
    _value = value;
    //invalidate();
  }

  public function MoveAbsoluteX(offset: Number):Void {
    //item._x +=  offset;
    _x =  _x + offset;
    trace(item._x);
  }

  public function handleImageScrollerPress():Void {
    beginDrag();
  }
  // Private Methods:
  private function configUI():Void {
    trace("configUI");
    _momentum = {x: 0};
    _originX = _x;
    //this.addEventListener("press", this, "beginDrag");
    Mouse.addListener(this);
    _timer = getTimer();
    onEnterFrame = update;
  }

  private function beginDrag():Void {
    trace("begin drag");
    thumbPressed = true;
    _lastPos = _root._xmouse;
    dragOffset = {x:_root._xmouse - item._x};
    onMouseMove = doDrag;
    onMouseUp = endDrag;
    isPressed = true;
  }

  private function doDrag():Void {
    var thumbPosition:Number = _root._xmouse - dragOffset.x;
    var offset:Number = _root._xmouse - _lastPos;
    _lastPos = _root._xmouse;

    //stop spring move
    MovieClip(this).springEnd();
    //Adjust the momentum
    _momentum["x"] = ZBMath.lerp(_momentum["x"], _momentum["x"] + offset * (0.01 * momentumAmount), 0.67);
    MoveAbsoluteX(offset);
    
    /*
    var trackWidth:Number = (__width - offsetLeft);
    var newValue:Number = (thumbPosition - offsetLeft) / trackWidth * (_maximum-_minimum) + _minimum;
    _value = newValue;
    updateItems();
    */
  }

  private function endDrag():Void {
    isPressed = false;
    restrictWithinBounds();
    delete onMouseUp;
    delete onMouseMove;
  }

  private function update():Void {
    var delta_time:Number = getTimer() - _timer;
    if(!isPressed) {
      _momentum -= _scroll * 0.05;
      if(_momentum > 1) {
        _scroll = ZBMath.springLerp(_scroll, 0, 20, delta_time);
        var offset:Number = ZBMath.springDampenX(_momentum, 9, delta_time);
        MoveAbsoluteX(offset);
        //restrictWithinBounds();
        return;
      }
      else
      {
        _scroll = 0;
        _momentum = 0;
      }
    }
    else _scroll = 0;

    ZBMath.springDampenX(_momentum, 9, delta_time);
  }
  private function updateItems():Void {
    //trace("width" + __width);
    var trackWidth:Number = (__width - offsetLeft);
    item._x = (_value - _minimum) / (_maximum - _minimum) * trackWidth + offsetLeft;
  }

  public function restrictWithinBounds():Void {
    MovieClip(this).springTo({_x:_originX}, 0.1);
  }
}