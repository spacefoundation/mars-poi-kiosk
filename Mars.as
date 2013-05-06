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
	
	use namespace arcane;

	public class Mars extends GlobeKioskBase
	{
		// Diffuse map for Mars surface, courtesy of NASA, remapped by Space Foundation
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
		
		//milky way skybox, courtesy of ESA, remapped by Space Foundation
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
		
		private var _awayStats:AwayStats;
		private var _poi:PointsOfInterest;

		public function Mars() {
			super();
		}

		override protected function onSetup():void {
			createLight();
			createmars();
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

		private function createmars():void {
			// Material
			var marsSurfaceTexture:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(marsXPosDiffuse), Cast.bitmapData(marsXNegDiffuse), Cast.bitmapData(marsYPosDiffuse), Cast.bitmapData(marsYNegDiffuse), Cast.bitmapData(marsZPosDiffuse), Cast.bitmapData(marsZNegDiffuse));
			var marsSurfaceMaterial:SkyBoxMaterial = new SkyBoxMaterial(marsSurfaceTexture);
			
			var backgroundTexture:BitmapCubeTexture = new BitmapCubeTexture(Cast.bitmapData(backgroundXPos), Cast.bitmapData(backgroundXNeg), Cast.bitmapData(backgroundYPos), Cast.bitmapData(backgroundYNeg), Cast.bitmapData(backgroundZPos), Cast.bitmapData(backgroundZNeg));
			
			// Geometry
			var skyBox:SkyBox = new SkyBox(backgroundTexture);
			_view.scene.addChild(skyBox);
			
			var marsSurfaceGeometry:SphereGeometry = new SphereGeometry( 115, 200, 120 );
			
			// Mesh.
			var marsSurfaceMesh:Mesh = new Mesh( marsSurfaceGeometry, marsSurfaceMaterial );
			_view.scene.addChild(marsSurfaceMesh); //temp
		}
		
		private function plotPOI():void {
			var i:Number;
			var poiLineSegSet:SegmentSet;
			
			poiLineSegSet = new SegmentSet();
			_view.scene.addChild(poiLineSegSet);
			
			_poi = new PointsOfInterest();
			
			for(i=0; i<_poi.points.length; i++) {
				poiLineSegSet.addSegment(_poi.points[i].lineSeg);
				_poi.points[i].targ = new Target();
				_poi.points[i].targ.alpha = .5;
				if(_poi.points[i].tAlign == "R") {
					_poi.points[i].targ.titleRight.text = _poi.points[i].title;
				} else {
					_poi.points[i].targ.titleLeft.text = _poi.points[i].title;
				}
				addChild(_poi.points[i].targ);
			}
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
			var camXDif:Number;
			
			//_mars.rotationY += 0.02; //temp
			
			//show/hide lines
			//It's not right yet, markers won't line up for now...
			
			
			var camAX:Number = (_cameraController.panAngle + 90) % 360;
			if(camAX < 0) {
				camAX = 360 + camAX;
			}
			
			//position, show/hide markers
			for(i=0; i<_poi.points.length; i++) {
				super.onUpdate();
				
				projVec = _view.project(_poi.points[i].lineSeg.end);
				_poi.points[i].targ.x = projVec.x;
				_poi.points[i].targ.y = projVec.y;
				
				camXDif = Math.abs(camAX - _poi.points[i].x);
				
				if((camXDif > 70 && camXDif < 295 && _poi.points[i].x != 0) || Math.abs(_cameraController.tiltAngle - _poi.points[i].y) > 70) {
					_poi.points[i].lineSeg.thickness = 0;
					_poi.points[i].targ.visible = false;
				} else {
					_poi.points[i].lineSeg.thickness = 1;
					_poi.points[i].targ.visible = true;
				}
				
			}
			
			
			
		}

		private function rand( min:Number, max:Number ):Number {
			return (max - min)*Math.random() + min;
		}
	}
}
