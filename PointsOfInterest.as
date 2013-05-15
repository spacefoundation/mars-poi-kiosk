//Points of interest targetted towards a general audience
//Note: does not contain ALL mars features. If I missed a critical one, let me know!
//		Is the current selection overkill? Let me know! ;)

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
	
	public class PointsOfInterest {

		public var points:Array = [];
		
		public function PointsOfInterest() {
			definePOI();
			initPosAttrib();
		}
		
		//lon, lat, elevation => x, y, z
		//thank you: http://astro.uchicago.edu/cosmus/tech/latlong.html
		//I know, the Earth isn't perfectly round (nor Mars for that matter), but works for a kiosk :D
		public function getVec(lon:Number, lat:Number, radius:Number):Vector3D {
			var x:Number;
			var y:Number;
			var z:Number;
			
			lat = lat * Math.PI / 180
			lon = lon * Math.PI / 180
			x = -radius * Math.cos(lat) * Math.cos(lon);
			y =  radius * Math.sin(lat) ;
			z =  radius * Math.cos(lat) * Math.sin(lon);
			
			return new Vector3D(x,y,z);
		}
		
		private function initPosAttrib():void {
			var i:Number;
			for(i=0; i<points.length; i++) {
				points[i].innerVector = getVec(points[i].x, points[i].y, 115);
				points[i].outerVector = getVec(points[i].x, points[i].y, 130);
				points[i].lineSeg = new LineSegment(points[i].innerVector, points[i].outerVector, 0x33eeba99, 0x33FFFFFF, 0.001);
				points[i].enabled = false;
				
				if(points[i].x < 0) {
					points[i].x = 360 + points[i].x; //makes it easier to show/hide markers
				}
			}
		}
		
		private function definePOI():void {
			var poi:Object;
			
			/////////////////////////
			//Poles
			/////////////////////////
			
			poi = {};
			poi.title = "Northern Polar Region";
			poi.tAlign = "R";
			poi.type = "Pole";
			poi.x = 0;
			poi.y = 90;
			points.push(poi);
			
			poi = {};
			poi.title = "South Polar Cap";
			poi.tAlign = "R";
			poi.type = "Pole";
			poi.x = 0;
			poi.y = -90;
			points.push(poi);
			
			/////////////////////////
			//Popular Regions
			/////////////////////////
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Hellas Planitia";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = -70;
			poi.y = -42.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Syrtis Major";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = -70;
			poi.y = -9.9;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Solis Lacus";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 90;
			poi.y = -27.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Isidis Planitia";
			poi.tAlign = "L";
			poi.type = "Region";
			poi.x = -87;
			poi.y = 12.9;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Valles Marineris";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 59.2;
			poi.y = -13.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Argyre Planitia";
			poi.tAlign = "L";
			poi.type = "Region";
			poi.x = 44;
			poi.y = -49.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Utopia Planitia";
			poi.tAlign = "L";
			poi.type = "Region";
			poi.x = -118;
			poi.y = 49.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Vastitas Borealis";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = -180;
			poi.y = 67.3;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Acidalia Planitia";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 22;
			poi.y = 46.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Arcadia Planitia";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 168;
			poi.y = 46.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Arabia Terra";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = -5;
			poi.y = 22.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Noachis Terra";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 10;
			poi.y = -44.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Amazonis Planitia";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 164;
			poi.y = 24.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Terra Sirenum";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 150;
			poi.y = -39.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Terra Cimmeria";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = -145;
			poi.y = -34.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Amazonis Planitia";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 164;
			poi.y = -24.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Elysium Planitia";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = -155;
			poi.y = 2;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Margaritifer Terra";
			poi.tAlign = "R";
			poi.type = "Region";
			poi.x = 25;
			poi.y = -4.9;
			points.push(poi);
			
			/////////////////////////
			//Populqr Craters
			/////////////////////////
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Lomonosov Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 9.2;
			poi.y = 64.9;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Kunowsky Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 9.7;
			poi.y = 56.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Lyot Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -29.3;
			poi.y = 50.5;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			//and http://www.msss.com/mars_images/moc/3_11_99_happy/
			poi = {};
			poi.title = "Galle Crater, \"Happy Face Crater\"";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 30.95;
			poi.y = -50.95;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Newton Crater";
			poi.tAlign = "L";
			poi.type = "Crater";
			poi.x = 158.1;
			poi.y = -40.5;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "MilankoviÄ Crater"; //hmmm Ä
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 146.7;
			poi.y = 54.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Schiaparelli Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -16.7;
			poi.y = -2.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Herschel Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -129.7;
			poi.y = -14.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Cassini Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -31.8;
			poi.y = 23.6;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Tikhonravov Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -35.8;
			poi.y = 13.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Flaugergues Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -19.2;
			poi.y = -16.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Bakhuysen Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -15.6;
			poi.y = -23;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Antoniadi Crater";
			poi.tAlign = "L";
			poi.type = "Crater";
			poi.x = -60.8;
			poi.y = 21.3;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Huygens Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -55.4;
			poi.y = -14.1;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Baldet Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -65.4;
			poi.y = 22.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Oudemans Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 91.9;
			poi.y = -9.9;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Perrotin Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 78;
			poi.y = -2.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Schmidt Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 78.1;
			poi.y = -72.1;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Lowell Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 81.4;
			poi.y = -52;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "South Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -22;
			poi.y = -77;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Kepler Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -140.9;
			poi.y = -46.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Phillips Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 45.1;
			poi.y = -66.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Burroughs Crater";
			poi.tAlign = "L";
			poi.type = "Crater";
			poi.x = -117;
			poi.y = -72.2;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Reynolds Crater";
			poi.tAlign = "L";
			poi.type = "Crater";
			poi.x = -157.9;
			poi.y = -75;
			points.push(poi);
			
			/////////////////////////
			//Popular Mountains
			/////////////////////////
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Albor Tholus";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -150.4;
			poi.y = 18.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Alba Patera";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 109.6;
			poi.y = 40.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Apollinaris Patera";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -174.4;
			poi.y = -9.3;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Arsia Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 121.1;
			poi.y = -8.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Ascraeus Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 104.5;
			poi.y = 11.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Elysium Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -146.9;
			poi.y = 24.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Hecates Tholus";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -150.2;
			poi.y = 32.1;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Olympus Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 134;
			poi.y = 18.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Pavonis Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 113.4;
			poi.y = 0.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Tharsis Tholus";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 90.8;
			poi.y = 13.4;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Uranius Patera";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 92.2;
			poi.y = 26.8;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Biblis Patera";
			poi.tAlign = "L";
			poi.type = "Mountain";
			poi.x = 124.6;
			poi.y = 2.6;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Ceraunius Tholus";
			poi.tAlign = "L";
			poi.type = "Mountain";
			poi.x = 97.4;
			poi.y = 24;
			points.push(poi);
			
			/////////////////////////
			//Spacecraft
			/////////////////////////
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars 2 Lander (USSR)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -47; //47E
			poi.y = -45.0;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars 3 Lander (USSR)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 158;
			poi.y = -45.0;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars 6 Lander (USSR)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 19.45;
			poi.y = -23.92;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Viking 1 Lander (USA)";
			poi.tAlign = "L";
			poi.type = "Spacecraft";
			poi.x = 47.95;
			poi.y = 22.46;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Viking 2 Lander (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -133.74;
			poi.y = 47.93;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars Pathfinder Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 33.25;
			poi.y = 19.26;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars Polar Lander (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -164.7;
			poi.y = -76.7;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "MER Spirit Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -175.47;
			poi.y = -14.57;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "MER Opportunity Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 5.53;
			poi.y = -1.95;
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Beagle 2 Lander (UK)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -90;
			poi.y = 10.6;
			points.push(poi);
			
			//source: http://mars.jpl.nasa.gov/msl/mission/timeline/prelaunch/landingsiteselection/aboutgalecrater/
			poi = {};
			poi.title = "Curiosity Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -137.4;
			poi.y = -4.5;
			points.push(poi);
		}

	}
	
}

