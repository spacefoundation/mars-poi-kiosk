package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class Ripple extends MovieClip {
		private var _stage:Stage;
		
		public function Ripple(stage:Stage) {
			_stage = stage;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_stage.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		}
		
		private function onTouch(event:MouseEvent):void {
			this.x = _stage.mouseX;
			this.y = _stage.mouseY;
			this.gotoAndPlay(1);
		}
	}
	
}
