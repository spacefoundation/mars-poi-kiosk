package
{
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
	import flash.system.*
	
	use namespace arcane;

	public class Mars extends GlobeKioskBase
	{
		// Diffuse photo map for Mars surface, courtesy of NASA, remapped for this project by Space Foundation
		[Embed(source="./skybox/x-pos-diffuse.png")]
		public static var marsXPosDiffuse:Class;
		
		[Embed(source="./skybox/x-neg-diffuse.png")]
		public static var marsXNegDiffuse:Class;
		
		[Embed(source="./skybox/y-pos-diffuse.png")]
		public static var marsYPosDiffuse:Class;
		
		[Embed(source="./skybox/y-neg-diffuse.png")]
		public static var marsYNegDiffuse:Class;
		
		[Embed(source="./skybox/z-pos-diffuse.png")]
		public static var marsZPosDiffuse:Class;
		
		[Embed(source="./skybox/z-neg-diffuse.png")]
		public static var marsZNegDiffuse:Class;
		
		// Diffuse MOLA map for Mars surface, courtesy of NASA, remapped for this project by Space Foundation
		[Embed(source="./skybox/x-pos-mola-diffuse.png")]
		public static var marsXPosMolaDiffuse:Class;
		
		[Embed(source="./skybox/x-neg-mola-diffuse.png")]
		public static var marsXNegMolaDiffuse:Class;
		
		[Embed(source="./skybox/y-pos-mola-diffuse.png")]
		public static var marsYPosMolaDiffuse:Class;
		
		[Embed(source="./skybox/y-neg-mola-diffuse.png")]
		public static var marsYNegMolaDiffuse:Class;
		
		[Embed(source="./skybox/z-pos-mola-diffuse.png")]
		public static var marsZPosMolaDiffuse:Class;
		
		[Embed(source="./skybox/z-neg-mola-diffuse.png")]
		public static var marsZNegMolaDiffuse:Class;
		
		//milky way skybox, courtesy of ESA, remapped for this project by Space Foundation
		//NOTE: orientation to Mars is not correct yet, need to consult an expert ;)
		//Note to self: look into generated options using Yale Bright Start Catalog for added bling
		[Embed(source="./skybox/x-pos-background.png")]
		public static var backgroundXPos:Class;
		
		[Embed(source="./skybox/x-neg-background.png")]
		public static var backgroundXNeg:Class;
		
		[Embed(source="./skybox/y-pos-background.png")]
		public static var backgroundYPos:Class;
		
		[Embed(source="./skybox/y-neg-background.png")]
		public static var backgroundYNeg:Class;
		
		[Embed(source="./skybox/z-pos-background.png")]
		public static var backgroundZPos:Class;
		
		[Embed(source="./skybox/z-neg-background.png")]
		public static var backgroundZNeg:Class;
		
		private var atmosphereMaterial:ColorMaterial;
		private var atmosphereDiffuseMethod:BasicDiffuseMethod;
		private var atmosphereSpecularMethod:BasicSpecularMethod;
		
		private var _marsSurfaceMesh:Mesh;
		
		private var _awayStats:AwayStats;
		private var _poi:PointsOfInterest;
		private var _poiEnabled:Boolean = true;

		public function Mars() {
			super();
		}
		
		public function toggleMarkers():void {
			var i:Number;
			if(_poiEnabled == true) {
				for(i=0; i<_poi.points.length; i++) {
					_poi.points[i].enabled = false;
				}
				_poiEnabled = false;
				_markersOnOff.gotoAndStop('off');
			} else {
				for(i=0; i<_poi.points.length; i++) {
					_poi.points[i].enabled = true;
				}
				_poiEnabled = true;
				_markersOnOff.gotoAndStop('on');
			}
		}

		override protected function onSetup():void {
			createLight();
			createSky();
			createMars("photo");
			plotPOI();
		}
		
		private function createLight():void {
			// Light object.
			var light:PointLight = new PointLight();
			light.ambientColor = 0xffffec;
			light.ambient = 0.40;
			light.diffuse = 2;
			light.specular = 0.5;
			light.x = 10000;
			_lightPicker.lights = [ light ];
		}

		private function createMars(texureName:String):void {
			var marsSurfaceTexture:BitmapCubeTexture;
			var marsSurfaceMaterial:SkyBoxMaterial;
			var marsSurfaceGeometry:SphereGeometry;
			
			//toggling the maps constantly causes memory resources to run out fast and bad things to happen
			//calling this twice seemed to resolve the issue:
			//http://www.craftymind.com/2008/04/09/kick-starting-the-garbage-collector-in-actionscript-3-with-air/
			flash.system.System.gc();
			flash.system.System.gc();
			
			// Texture
			if(texureName == "photo") {
				marsSurfaceTexture = new BitmapCubeTexture(Cast.bitmapData(marsXPosDiffuse), Cast.bitmapData(marsXNegDiffuse), Cast.bitmapData(marsYPosDiffuse), Cast.bitmapData(marsYNegDiffuse), Cast.bitmapData(marsZPosDiffuse), Cast.bitmapData(marsZNegDiffuse));
			} else if(texureName == "mola") {
				marsSurfaceTexture = new BitmapCubeTexture(Cast.bitmapData(marsXPosMolaDiffuse), Cast.bitmapData(marsXNegMolaDiffuse), Cast.bitmapData(marsYPosMolaDiffuse), Cast.bitmapData(marsYNegMolaDiffuse), Cast.bitmapData(marsZPosMolaDiffuse), Cast.bitmapData(marsZNegMolaDiffuse));
			}
			
			// Material
			marsSurfaceMaterial = new SkyBoxMaterial(marsSurfaceTexture);
			
			// Geometry
			marsSurfaceGeometry = new SphereGeometry( 115, 200, 120 );
			
			// Mesh
			_marsSurfaceMesh = new Mesh( marsSurfaceGeometry, marsSurfaceMaterial );
			_view.scene.addChild(_marsSurfaceMesh);
		}
		
		private function createSky():void {
			var backgroundTexture:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(backgroundXPos), Cast.bitmapData(backgroundXNeg), Cast.bitmapData(backgroundYPos), Cast.bitmapData(backgroundYNeg), Cast.bitmapData(backgroundZPos), Cast.bitmapData(backgroundZNeg));
			var skyBox:SkyBox = new SkyBox(backgroundTexture);
			_view.scene.addChild(skyBox);
		}
		
		private function setMapTexture(textureName:String):void {
			_view.scene.removeChild(_marsSurfaceMesh);
			_marsSurfaceMesh = null;
			createMars(textureName);
		}
		
		private function plotPOI():void {
			var i:Number;
			var poiLineSegSet:SegmentSet;
			
			poiLineSegSet = new SegmentSet();
			_view.scene.addChild(poiLineSegSet);
			
			_poi = new PointsOfInterest();
			
			for(i=0; i<_poi.points.length; i++) {
				poiLineSegSet.addSegment(_poi.points[i].lineSeg);
				_poi.points[i].targ.targHit.addEventListener(MouseEvent.CLICK, onTargSelected);
				addChild(_poi.points[i].targ);
			}
			
			//put the info panel back on top
			addChild(_infoPanel);
			addChild(_touchOfMars);
		}
		
		private function onTargSelected(event:MouseEvent):void {
			var photoURI:String = "";
			var photoCredit:String = "";
			var description:String = "";
			_poi.activateTarg(event.target.parent.poiIndex);
			
			if("photoURI" in _poi.points[event.target.parent.poiIndex]) {
				photoURI = _poi.points[event.target.parent.poiIndex].photoURI;
				photoCredit = _poi.points[event.target.parent.poiIndex].photoCredit;
			}
			
			if("description" in _poi.points[event.target.parent.poiIndex]) {
				description = _poi.points[event.target.parent.poiIndex].description
			}
			
			setInfoPanel(photoCredit, photoURI, _poi.points[event.target.parent.poiIndex].title, description);
		}
		
		private function modulateDiffuseMethod(vo : MethodVO, t:ShaderRegisterElement, regCache:ShaderRegisterCache, sharedRegisters:ShaderRegisterData):String
		{
			var viewDirFragmentReg:ShaderRegisterElement = atmosphereDiffuseMethod.sharedRegisters.viewDirFragment;
			var normalFragmentReg:ShaderRegisterElement = atmosphereDiffuseMethod.sharedRegisters.normalFragment;
			
			var code:String = "dp3 " + t + ".w, " + viewDirFragmentReg + ".xyz, " + normalFragmentReg + ".xyz\n" + 
							"mul " + t + ".w, " + t + ".w, " + t + ".w\n";
			
			return code;
		}
		
		private function modulateSpecularMethod(vo : MethodVO, t:ShaderRegisterElement, regCache:ShaderRegisterCache, sharedRegisters:ShaderRegisterData):String
		{
			var viewDirFragmentReg:ShaderRegisterElement = atmosphereDiffuseMethod.sharedRegisters.viewDirFragment;
			var normalFragmentReg:ShaderRegisterElement = atmosphereDiffuseMethod.sharedRegisters.normalFragment;
			var temp:ShaderRegisterElement = regCache.getFreeFragmentSingleTemp();
			regCache.addFragmentTempUsages(temp, 1);
			
			var code:String = "dp3 " + temp + ", " + viewDirFragmentReg + ".xyz, " + normalFragmentReg + ".xyz\n" + 
							"neg" + temp + ", " + temp + "\n" +
							"mul " + t + ".w, " + t + ".w, " + temp + "\n";
				
				regCache.removeFragmentTempUsage(temp);
			
			return code;
		}

		override protected function onUpdate():void {
			var i:Number;
			var projVec:Vector3D;
			var projVecCam:Vector3D;
			var camXDif:Number;
			var distance:Number;
			
			/*
			if( > 1800) {
				//_mars.rotationY += 0.02; //temp
			}
			*/
			
			//position, show/hide markers
			for(i=0; i<_poi.points.length; i++) {
				distance = Math.sqrt(Math.pow(_poi.points[i].lineSeg.end.x-_view.camera.x, 2)+Math.pow(_poi.points[i].lineSeg.end.y-_view.camera.y, 2)+Math.pow(_poi.points[i].lineSeg.end.z-_view.camera.z, 2));
				if(distance > _cameraController.distance || _poi.points[i].enabled == false) {	
					_poi.points[i].lineSeg.thickness = 0;
					_poi.points[i].targ.visible = false;
				} else {
					_poi.points[i].lineSeg.thickness = 1;
					_poi.points[i].targ.visible = true;
				}
				
				//for 2D overlay
				projVec = _view.project(_poi.points[i].lineSeg.end);
				_poi.points[i].targ.x = projVec.x;
				_poi.points[i].targ.y = projVec.y;
			}
			
		}
		
		override protected function onMarkersOnOff():void {
			toggleMarkers();
		}
		
		override protected function onZoomIn():void {
			_zoomInOut.gotoAndPlay('zoomIn');
			_cameraController.distance -= 25;
			if(_cameraController.distance < 150) {
				_cameraController.distance = 150;
			}
		}
		
		override protected function onZoomOut():void {
			_zoomInOut.gotoAndPlay('zoomOut');
			_cameraController.distance += 25;
			if(_cameraController.distance > 300) {
				_cameraController.distance = 300;
			}
		}
		
		override protected function onSelectMapPhoto():void {
			_mapSelect.gotoAndStop('photo');
			setMapTexture('photo');
		}
		
		override protected function onSelectMapMola():void {
			_mapSelect.gotoAndStop('mola');
			setMapTexture('mola');
		}
	}
}
