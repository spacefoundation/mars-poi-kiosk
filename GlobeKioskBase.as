﻿package  {		import away3d.arcane;	import away3d.cameras.*;	import away3d.containers.*;	import away3d.controllers.*;	import away3d.debug.*;	import away3d.entities.*;	import away3d.lights.*;	import away3d.loaders.parsers.*;	import away3d.materials.*;	import away3d.materials.lightpickers.*;	import away3d.materials.compilation.*;	import away3d.materials.methods.*;	import away3d.primitives.*;	import away3d.textures.*;	import away3d.utils.*;		import flash.display.*;	import flash.events.*;	import flash.filters.*;	import flash.geom.*;	import flash.text.*;	import flash.ui.*;		public class GlobeKioskBase extends GlobeBase {		public function GlobeKioskBase() {			super();						goFullScreen();			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);		}				// ---------------------------------------------------------------------		// Private.		// ---------------------------------------------------------------------				private function goFullScreen():void {			stage.displayState = StageDisplayState.FULL_SCREEN;		}				// ---------------------------------------------------------------------		// Event handlers.		// ---------------------------------------------------------------------				private function handleKey(keyEvent:KeyboardEvent):void { 			var keyPressed:String = keyEvent.keyCode.toString(); 			if (keyEvent.ctrlKey) {				if(keyPressed == "70") { //Ctrl + f					goFullScreen();				}			}		}	}	}