package  {
	
	import away3d.arcane;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.loaders.parsers.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.compilation.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.textures.*;
	import away3d.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.net.*;
	
	public class GlobeKioskBase extends GlobeBase {

		private var _logos:Logos;
		public var _touchOfMars:TouchOfMars;
		private var _scaleMult:Number = 1;
		private var _optWidth:Number = 1920; //used to scale some graphics down if screen is smaller size
		private var _ripple:Ripple;
		public var _debugText:DebugText;
		private var _touchedFramesAgo:int = 1800; //how many frames ago the screen was touched, great for a "demo mode"
		public var _markersOnOff:MarkersOnOff;
		public var _zoomInOut:ZoomInOut;
		public var _mapSelect:MapSelect;
		public var _infoPanel:InfoPanel;

		public function GlobeKioskBase() {
			super();
			
			_infoPanel = new InfoPanel();
			_infoPanel.mouseEnabled = false;
			_infoPanel.mouseChildren = false;
			_infoPanel.con.alpha = 0;
			_infoPanel.con.cacheAsBitmap = true;
			addChild(_infoPanel);
			
			_logos = new Logos();
			addChild(_logos);
			
			_markersOnOff = new MarkersOnOff();
			//_markersOnOff.mouseEnabled = true;
			//_markersOnOff.mouseChildren = false;
			//_markersOnOff MOUSE_DOWN no work! - having scope challenges with anything parent of Mars.as
			//other components added in Mars.as seems to be triggering events alright...
			stage.addEventListener(MouseEvent.MOUSE_DOWN, buttonPressCheck); //Plan B for kiosk base interface
			addChild(_markersOnOff);
			
			_zoomInOut = new ZoomInOut();
			addChild(_zoomInOut);
			
			_mapSelect = new MapSelect();
			addChild(_mapSelect);
			
			_debugText = new DebugText();
			addChild(_debugText);
			
			_ripple = new Ripple(stage);
			addChild(_ripple);
			
			_touchOfMars = new TouchOfMars();
			addChild(_touchOfMars);
			
			stage.addEventListener(Event.RESIZE, handleResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			stage.addEventListener(Event.ENTER_FRAME, initMouseHide);
			
			goFullScreen();
			
		}
		
		public function setInfoPanel(photoCredit:String, photoURI:String, infoTitle:String, infoContent:String) { //add photo URL?
			var loader:Loader;
			var urlReq:URLRequest;
			
			_infoPanel.con.alpha = 0;
			
			_infoPanel.con.photoCredit.text = photoCredit;
			_infoPanel.con.infoTitle.text = infoTitle;
			_infoPanel.con.infoContent.text = infoContent;
			
			if(photoURI == "") {
				_infoPanel.con.photo.visible = false;
				_infoPanel.con.photoCredit.visible = false;
				posInfoPanelContent();
			} else {
				_infoPanel.con.photo.visible = true;
				_infoPanel.con.photoCredit.visible = true;
				loader = new Loader();
				urlReq = new URLRequest(photoURI);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoLoaded);
				loader.load(urlReq);
			}
		}
		
		// ---------------------------------------------------------------------
		// Private.
		// ---------------------------------------------------------------------
		
		private function onPhotoLoaded(event:Event):void {
			var image:Bitmap = event.target.content as Bitmap;
			image.smoothing = true;
			
			while (_infoPanel.con.imageBorder.numChildren > 0) {
				_infoPanel.con.imageBorder.removeChildAt(0);
			}
			while (_infoPanel.con.photo.numChildren > 0) {
				_infoPanel.con.photo.removeChildAt(0);
			}
			_infoPanel.con.photo.addChild(image);
			posInfoPanelContent();
		}
		
		private function goFullScreen():void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function posInfoPanelContent():void {
			var photoScaleMult:Number;
			
			photoScaleMult =  _touchOfMars.width / _infoPanel.con.photo.width;
			
			if(_infoPanel.con.photo.visible == true) {
				_infoPanel.con.photo.width = _touchOfMars.width;
				_infoPanel.con.photo.height = _infoPanel.con.photo.height * photoScaleMult;
				_infoPanel.con.photo.x = 20;
				_infoPanel.con.photo.y = _touchOfMars.y + _touchOfMars.height + 40;
				_infoPanel.con.photoCredit.x = 20;
				_infoPanel.con.photoCredit.y = _infoPanel.con.photo.y + _infoPanel.con.photo.height;
				_infoPanel.con.photoCredit.autoSize = TextFieldAutoSize.LEFT;
				_infoPanel.con.photoCredit.width = _touchOfMars.width;
				
				//image mask
				var imageMask:Shape = new Shape();
				imageMask.graphics.beginFill(0x0);
				imageMask.graphics.drawRoundRect(0, 0, _infoPanel.con.photo.width, _infoPanel.con.photo.height, 12, 12);
				imageMask.graphics.endFill();
				imageMask.x = _infoPanel.con.photo.x;
				imageMask.y = _infoPanel.con.photo.y;
				_infoPanel.con.photo.mask = imageMask;
				
				//image border
				var imageBorder:Shape = new Shape();
				imageBorder.graphics.lineStyle(2, 0xffffff, 1, true);
				imageBorder.graphics.drawRoundRect(0, 0, _infoPanel.con.photo.width, _infoPanel.con.photo.height, 12, 12);
				imageBorder.x = _infoPanel.con.photo.x;
				imageBorder.y = _infoPanel.con.photo.y;
				_infoPanel.con.imageBorder.addChild(imageBorder);
			}
			
			_infoPanel.con.infoTitle.x = 20;
			if(_infoPanel.con.photo.visible == true) {
				_infoPanel.con.infoTitle.y = _infoPanel.con.photoCredit.y + 30;
			} else {
				_infoPanel.con.infoTitle.y = _touchOfMars.y + _touchOfMars.height + 40;
			}
			_infoPanel.con.infoTitle.autoSize = TextFieldAutoSize.LEFT;
			_infoPanel.con.infoTitle.width = _touchOfMars.width;
			_infoPanel.con.infoContent.x = 20;
			_infoPanel.con.infoContent.y = _infoPanel.con.infoTitle.y + 30;
			_infoPanel.con.infoContent.autoSize = TextFieldAutoSize.LEFT;
			_infoPanel.con.infoContent.width = _touchOfMars.width;
			stage.removeEventListener(Event.ENTER_FRAME, fadeInInfoPanel);
			stage.addEventListener(Event.ENTER_FRAME, fadeInInfoPanel);
		}
		
		// ---------------------------------------------------------------------
		// Event handlers.
		// ---------------------------------------------------------------------
		
		private function fadeInInfoPanel(event:Event) {
			_infoPanel.con.alpha += .05;
			if(_infoPanel.con.alpha >= 1) {
				_infoPanel.con.alpha = 1;
				stage.addEventListener(Event.ENTER_FRAME, fadeInInfoPanel);
			}
		}
		
		private function handleResize(event:Event):void {
			_scaleMult = stage.stageWidth / _optWidth;
			
			_touchOfMars.scaleX = _touchOfMars.scaleY = _scaleMult;
			_touchOfMars.x = 20;
			_touchOfMars.y = 10;
			
			//_infoPanel.scaleX = _infoPanel.scaleY = _scaleMult;
			_infoPanel.x = 0;
			_infoPanel.y = 0;
			_infoPanel.back.height = stage.stageHeight;
			_infoPanel.back.width = _touchOfMars.x + _touchOfMars.width + 45;
			posInfoPanelContent();
			
			_logos.scaleX = _logos.scaleY = _scaleMult;
			_logos.x = stage.stageWidth - _logos.width - 20;
			_logos.y = stage.stageHeight - _logos.height - 20;
			
			_markersOnOff.scaleX = _markersOnOff.scaleY = _scaleMult;
			_markersOnOff.x = stage.stageWidth - _markersOnOff.width - 20;
			_markersOnOff.y = 20;
			
			_zoomInOut.scaleX = _zoomInOut.scaleY = _scaleMult;
			_zoomInOut.x = stage.stageWidth / 2;
			_zoomInOut.y = 0;
			
			_mapSelect.scaleX = _mapSelect.scaleY = _scaleMult;
			_mapSelect.x = stage.stageWidth / 2;
			_mapSelect.y = stage.stageHeight;
			
			_debugText.x = 20;
			_debugText.y = stage.stageHeight - _debugText.height - 20;
			
			if(_view != null) {
				_view.width = stage.stageWidth;
				_view.height = stage.stageHeight;
			}
			
		}
		
		private function handleKey(keyEvent:KeyboardEvent):void { 
			var keyPressed:String = keyEvent.keyCode.toString(); 
			//_debugText.debug.text = keyPressed;
			if (keyEvent.ctrlKey) {
				if(keyPressed == "70") { //Ctrl + f
					goFullScreen();
				}
			}
		}
		
		private function initMouseHide(event:Event):void {
			if(_view != null) {
				stage.removeEventListener(Event.ENTER_FRAME, initMouseHide);
				//Mouse.hide(); //uncomment when finished developing...
			}
		}
		
		private function buttonPressCheck(event:MouseEvent):void {
			//markers on/off (erg.. _markersOnOff MOUSE_DOWN issues in this scope, revisit for better solution)
			if(stage.mouseX >= _markersOnOff.x && stage.mouseX <= (_markersOnOff.x + _markersOnOff.width) && stage.mouseY >= _markersOnOff.y && stage.mouseY <= (_markersOnOff.y + _markersOnOff.height)) {
				onMarkersOnOff();
			} 
			//zoom in
			else if(stage.mouseX >= (stage.stageWidth/2) - (_zoomInOut.width/2) && stage.mouseX <= (stage.stageWidth/2) && stage.mouseY <= _zoomInOut.height) {
				onZoomIn();
			} 
			//zoom out
			else if(stage.mouseX >= (stage.stageWidth/2) && stage.mouseX <= (stage.stageWidth/2) + (_zoomInOut.width/2) && stage.mouseY <= _zoomInOut.height)  {
				onZoomOut();
			}
			//select photo map
			else if(stage.mouseX >= (stage.stageWidth/2) - (_mapSelect.width/2) && stage.mouseX <= (stage.stageWidth/2) && stage.mouseY >= _mapSelect.y - _mapSelect.height) {
				onSelectMapPhoto();
			}
			//select mola map
			else if(stage.mouseX >= (stage.stageWidth/2) && stage.mouseX <= (stage.stageWidth/2) + (_mapSelect.width/2) && stage.mouseY >= _mapSelect.y - _mapSelect.height)  {
				onSelectMapMola();
			}
		}
		
		protected function onMarkersOnOff():void {
			// Override me.
		}
		
		protected function onZoomIn():void {
			// Override me.
		}
		
		protected function onZoomOut():void {
			// Override me.
		}
		
		protected function onSelectMapPhoto():void {
			// Override me.
		}
		
		protected function onSelectMapMola():void {
			// Override me.
		}

	}
	
	
	
}
