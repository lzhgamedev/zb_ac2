import flash.external.ExternalInterface; 
import flash.geom.Rectangle;
import gfx.core.UIComponent;
import gfx.data.DataProvider;
import gfx.controls.UILoader;
import gfx.utils.Delegate;
import com.scaleform.zb.motion.Spring;
import com.scaleform.zb.controls.ScrollView;

class com.scaleform.zb.controls.ImageScroller extends UIComponent {

  public var onSpringComplete:Function;

  private var hit_area:MovieClip;
  private var image:MovieClip;

  public function ImageScroller() {
    super();
    Spring.init();
  }

  public function loadImage(file:String):Void {
    //this.image.loadMovie(file);
    this.image.attachMovie(file, file, this.getDepth());
  }

  public function springMove():Void {
    MovieClip(this).springTo({_x:this._x + 100}, 0.5);
    if( _global.gfxPlayer ) {
      onSpringComplete = Delegate.create(this, handleSpringEnd_Player);
    }
  }
 // Private Methods:
  private function configUI():Void {  
    super.configUI();
    onPress = handleMousePress;
    onRelease = handleMouseRelease;

    this.hitArea = this.hit_area;
    this.hit_area._visible = false;

    if( _global.gfxPlayer ) {
      //loadImage("zb_assets/test_img.png");
      loadImage("test_img_mc");
    }
    else {
      loadImage("test_img_mc");
    }
  }

  private function handleMousePress(controllerIdx:Number, keyboardOrMouse:Number, button:Number):Void {
    //trace("handleMousePress");
    dispatchEventAndSound({type:"press", controllerIdx:controllerIdx, button:button});   
    if(ScrollView(_parent)) {
      ScrollView(_parent).handleImageScrollerPress();
    } 
    /*
    MovieClip(this).springTo({_x:this._x + 100}, 0.5);
    if( _global.gfxPlayer ) {
      onSpringComplete = Delegate.create(this, handleSpringEnd_Player);
    }*/
  }
  private function handleMouseRelease(controllerIdx:Number, keyboardOrMouse:Number, button:Number):Void {
    handleClick(controllerIdx, button);
  }
  private function handleClick(controllerIdx:Number, button:Number):Void {
    dispatchEventAndSound({type:"click", controllerIdx:controllerIdx, button:button});    
  }
  private function handleSpringEnd_Player():Void {
    trace("Scaleform ImageScroller" + _name + "SpringEnd");
  }
}
