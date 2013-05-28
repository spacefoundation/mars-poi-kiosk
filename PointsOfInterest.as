﻿//Points of interest targetted towards a general audience
//Note: does not contain ALL mars features.
//Is the current selection overkill? Am I missing something critical? Let me know! ;)

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
	
	import Target;
	
	public class PointsOfInterest extends Sprite {

		public var points:Array = [];
		private var _activeTargInt:Number = -1;
		
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
		
		public function resetAlpha():void {
			var i:Number;
			for(i=0; i<points.length; i++) {
				points[i].targ.alpha = .55;
			}
		}
		
		public function activateTarg(targInt:Number):void {
			resetAlpha();
			_activeTargInt = targInt;
			//this.removeEventListener(Event.ENTER_FRAME, animAciveTarg);
			//this.addEventListener(Event.ENTER_FRAME, animAciveTarg);
			points[targInt].targ.alpha = 1;
		}
		
		private function initPosAttrib():void {
			var i:Number;
			for(i=0; i<points.length; i++) {
				points[i].innerVector = getVec(points[i].x, points[i].y, 115);
				points[i].outerVector = getVec(points[i].x, points[i].y, 130);
				points[i].lineSeg = new LineSegment(points[i].innerVector, points[i].outerVector, 0x33eeba99, 0x33FFFFFF, 0.001);
				points[i].enabled = true;
				points[i].targ = new Target();
				points[i].targ.alpha = .55;
				points[i].targ.poiIndex = i;
				points[i].targ.mouseEnabled = false;
				points[i].targ.titleRight.mouseEnabled = false;
				points[i].targ.titleLeft.mouseEnabled = false;
				
				
				if(points[i].tAlign == "R") {
					points[i].targ.titleRight.text = points[i].title;
				} else {
					points[i].targ.titleLeft.text = points[i].title;
				}
				
				if(points[i].x < 0) {
					points[i].x = 360 + points[i].x; //makes it easier to show/hide markers
				}
				
			}
		}
		
		private function animAciveTarg(event:Event):void {
			if(points[_activeTargInt].targ.alpha == 1) {
				points[_activeTargInt].targ.alpha = .6;
			} else {
				points[_activeTargInt].targ.alpha = 1;
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
			poi.photoURI = "assets/img/elyslbl.jpg";
			poi.photoCredit = "Photo Credit: NASA/JPL";
			poi.photoSource = "http://mars.jpl.nasa.gov/gallery/atlas/elysium-planitia.html";
			poi.description = "Elysium Planitia is the second largest volcanic region on Mars. It is 1,700 by 2,400 km in size and is also located on an uplift dome. The 3 large volcanoes, Hecates Tholus, Albor Tholus, and Elysium Mons, are smaller than those found in Tharsis but are still quite large. Elysium Mons is the largest volcano in this region, measuring 700 km across and rising 13 km above the surrounding plains.";
			poi.descriptionSource = "http://mars.jpl.nasa.gov/gallery/atlas/elysium-planitia.html";
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
			//Popular Craters
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
			poi.photoURI = "assets/img/PIA01676.jpg";
			poi.photoCredit = "Photo Credit: NASA/JPL/MSSS";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA01676";
			poi.description = "Original Caption Released with Image:\nThe story of the Mars Orbiter Camera (MOC) onboard the Mars Global Surveyor (MGS) spacecraft began with a proposal to NASA in 1985. The first MOC flew on Mars Observer, a spacecraft that was lost before it reached the red planet in 1993. Now, after 14 years of effort, a MOC has finally been placed in the desired mapping orbit. The MOC team's happiness is perhaps best expressed by the planet Mars itself. On the first day of the Mapping Phase of the MGS mission--during the second week of March 1999--MOC was greeted with this view of \"Happy Face Crater\" (center right) smiling back at the camera from its location on the east side of Argyre Planitia. This crater is officially known as Galle Crater, and it is about 215 kilometers (134 miles) across. The picture was taken by the MOC's red and blue wide angle cameras. The bluish-white tone is caused by wintertime frost. Illumination is from the upper left.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA01676";
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
			poi.photoURI = "assets/img/20030212b-01_br.jpg";
			poi.photoCredit = "Copyright: NASA/JPL/Malin Space Science Systems";
			poi.photoSource = "http://mars.jpl.nasa.gov/newsroom/pressreleases/20030212b.html";
			poi.description = "Vertically exaggerated 3-D image of Flaugergues basin showing extensive dissected terrain in upland regions draining into depressions, and smooth, possibly lakebed features of the depressions.";
			poi.descriptionSource = "http://mars.jpl.nasa.gov/newsroom/pressreleases/20030212b.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Bakhuysen Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -15.6;
			poi.y = -23;
			poi.photoURI = "assets/img/PIA01506_modest.jpg";
			poi.photoCredit = "Copyright: NASA/JPL/Malin Space Science Systems";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/pia01506";
			poi.description = "Portion of channels on the wall of Bakhuysen crater (MOC 10605). These channels (22.1°S, 344.9°W) are the best examples of integrated drainage reminiscent of terrestrial systems. The pattern is topographically controlled; the relationships emphasized by light-colored sediments viewed in this low incidence angle (11.2°), nadir viewing (emission angle = 1.5°) image. The crater rim is marked by the escarpment running diagonally in the middle left to upper right of the image (downtrack scale = 8.4 m/pixel, crosstrack = 5.8 m/pixel). No channels outside the crater rim. This suggests that the source of the fluid was confined within the crater.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/pia01506";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Antoniadi Crater";
			poi.tAlign = "L";
			poi.type = "Crater";
			poi.x = -60.8;
			poi.y = 21.3;
			poi.photoURI = "assets/img/PIA07362_modest.jpg";
			poi.photoCredit = "Copyright: NASA/JPL/Malin Space Science Systems";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/pia07362";
			poi.description = "This Mars Global Surveyor (MGS) Orbiter Camera (MOC) image shows landforms on the floor of Antoniadi Crater. The circular features were once meteor impact craters that have been almost completely eroded away.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/pia07362";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Huygens Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -55.4;
			poi.y = -14.1;
			poi.photoURI = "assets/img/PIA13801_fig1.jpg";
			poi.photoCredit = "Copyright: NASA/JPL-Caltech/Arizona State Univ.";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA13801";
			poi.description = "This image shows the context for orbital observations of exposed rocks that had been buried an estimated 5 kilometers (3 miles) deep on Mars. It covers an area about 560 kilometers (350 miles) across, dominated by the Huygens crater, which is about the size of Wisconsin.\n\nThe impact that excavated Huygens lifted material from far underground and piled some of it in the crater's rim. At about the 10 o'clock position around the rim of Huygens lies an unnamed crater about 35 kilometers (22 miles) in diameter that has punched into the uplifted rim material and exposed rocks containing carbonate minerals. The minerals were identified by observations with the Compact Reconnaissance Imaging Spectrometer for Mars on NASA's Mars Reconnaissance Orbiter.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA13801";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Baldet Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -65.4;
			poi.y = 22.7;
			poi.photoURI = "assets/img/H1640_0000_RGBN3_IMG_ColCorr_50p.jpg";
			poi.photoCredit = "Copyright: ESA/DLR/FU Berlin (G.Neukum)";
			poi.photoSource = "http://sci.esa.int/science-e/www/object/index.cfm?fobjectid=39469";
			poi.description = "The large impact crater Baldet can be seen in the lower part of this image obtained by the HRSC onboard Mars Express. The crater is situated in the north-east of Terra Sabea, on the northern edge of Syrtis Major Planum, close to where the old and cratered highlands of Mars's southern hemisphere meet the younger and smoother planes of the northern hemisphere. Crater Baldet has a diameter of 180 km and is centred at 65.4° E, 22.8° N (USGS MC-13 quadrangle).";
			poi.descriptionSource = "http://sci.esa.int/science-e/www/object/index.cfm?fobjectid=39469";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Oudemans Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 91.9;
			poi.y = -9.9;
			poi.photoURI = "assets/img/Oudemans_Crater.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL/USGS";
			poi.photoSource = "http://commons.wikimedia.org/wiki/File:Oudemans_Crater.jpg";
			poi.photoSource2 = "http://photojournal.jpl.nasa.gov/catalog/pia00177";
			poi.description = "Oudemans Crater is located at the extreme western end of Valles Marineris in the Sinai Planum region of Mars. The crater measures some 124 kilometers (77 miles) across and sports a large central peak.\n\nComplex craters like Oudemans are formed when an object, such as an asteroid or comet, impacts the planet. The size, speed and angle at which the object hits all determine the type of crater that forms. The initial impact creates a bowl-shaped crater and flings material (known as ejecta) out in all directions along and beyond the margins of the bowl forming an ejecta blanket. As the initial crater cavity succumbs to gravity, it rebounds to form a central peak while material along the bowl’s rim slumps back into the crater forming terraces along the inner wall. If the force of the impact is strong enough, a central peak forms and begins to collapse back into the crater basin, forming a central peak ring.";
			poi.descriptionSource = "http://apod.nasa.gov/apod/ap001201.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			/*
			poi = {};
			poi.title = "Perrotin Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 78;
			poi.y = -2.8;
			points.push(poi);
			*/
			
			//source: http://www.google.com/mars/
			/*
			poi = {};
			poi.title = "Schmidt Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 78.1;
			poi.y = -72.1;
			points.push(poi);
			*/
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Lowell Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 81.4;
			poi.y = -52;
			poi.photoURI = "assets/img/frostcrater4_mgs.jpg";
			poi.photoCredit = "Image Credit: Malin Space Science Systems, MGS, JPL, NASA";
			poi.photoSource = "http://apod.nasa.gov/apod/ap001201.html";
			poi.description = "In the martian southern hemisphere, autumn has arrived. As on planet Earth, the cooler temperatures bring a seasonal frost to the landscape. Of course on Mars, the surface temperatures can be really cool, reaching below minus 100 degrees C. This detailed Mars Global Surveyor synthesized color image of Lowell crater at 52 degrees south martian latitude was recorded on October 17[, 2000]. Whitish frost has begun to accumulate on floor of the 201 kilometer wide crater. The crater's weathered walls suggest Lowell is relatively old. In striking contrast, two smaller, sharp-rimmed young craters are clearly superimposed on the older features near Lowell's outer rim.";
			poi.descriptionSource = "http://apod.nasa.gov/apod/ap001201.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			/*
			poi = {};
			poi.title = "South Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -22;
			poi.y = -77;
			points.push(poi);
			*/
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Kepler Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = -140.9;
			poi.y = -46.8;
			poi.photoURI = "assets/img/PIA13681_modest.jpg";
			poi.photoCredit = "Image Credit: NASA/MOLA Science Team";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA13681";
			poi.description = "Steep interior wall of Kepler crater, rim is to the upper left and the bottom of the crater is in the lower right. Note the exposed layering near the top, and the boulders collecting at the base of the crater wall. LROC NAC M107128381R, image width is 800 meters (2625 feet).";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA13681";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			/*
			poi = {};
			poi.title = "Phillips Crater";
			poi.tAlign = "R";
			poi.type = "Crater";
			poi.x = 45.1;
			poi.y = -66.4;
			points.push(poi);
			*/
			
			//source: http://www.google.com/mars/
			/*
			poi = {};
			poi.title = "Burroughs Crater";
			poi.tAlign = "L";
			poi.type = "Crater";
			poi.x = -117;
			poi.y = -72.2;
			points.push(poi);
			*/
			
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
			poi.photoURI = "assets/img/marsd41.jpg";
			poi.photoCredit = "Image Credit: NASA/MOLA Science Team";
			poi.photoSource = "http://nssdc.gsfc.nasa.gov/planetary/mars/marsview/marsd4.html";
			poi.description = "The dark region seen here is known as Cerberus. Albor Tholus is mid-way along the top of this image.";
			poi.descriptionSource = "http://nssdc.gsfc.nasa.gov/planetary/mars/marsview/marsd4.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Alba Patera";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 109.6;
			poi.y = 40.4;
			poi.photoURI = "assets/img/PIA02803_modest.jpg";
			poi.photoCredit = "Image Credit: NASA/MOLA Science Team";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA02803";
			poi.description = " Two views of Alba Patera with topography draped over a Viking image mosaic. MOLA data have clarified the relationship between fault location and topography on and surrounding the Alba construct, providing insight into the volcanological and geophysical processes that shaped the edifice. The vertical exaggeration is 10:1. ";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA02803";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Apollinaris Patera";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -174.4;
			poi.y = -9.3;
			poi.photoURI = "assets/img/apollinaris_mgs.jpg";
			poi.photoCredit = "Image Credit: Malin Space Science Systems, MGS, JPL, NASA";
			poi.photoSource = "http://apod.nasa.gov/apod/ap990513.html";
			poi.description = " Dwarfed by Olympus Mons and the other immense shield volcanos on Mars, Apollinaris Patera rises only 3 miles or so into the thin martian atmosphere, but bright water-ice clouds can be still be seen hovering around its summit. Mars' volcanic structures known as \"paterae\" are not only smaller than its shield volcanos but older as well, with ages estimated to be around 3 billion years. Like Apollinaris Patera, narrow furrows typically extend from their central craters or calderas. It is thought that the paterae represent broad piles of easily eroded volcanic ash. This wide angle view of Apollinaris Patera was recorded last month by the Mars Global Surveyor spacecraft. The large central crater is about 50 miles across. ";
			poi.descriptionSource = "http://apod.nasa.gov/apod/ap990513.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Arsia Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 121.1;
			poi.y = -8.4;
			poi.photoURI = "assets/img/PIA02337_modest.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL/MSSS";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/pia02337";
			poi.description = "Arsia Mons (above) is one of the largest volcanoes known. This shield volcano is part of an aligned trio known as the Tharsis Montes--the others are Pavonis Mons and Ascraeus Mons. Arsia Mons is rivaled only by Olympus Mons in terms of its volume. The summit of Arsia Mons is more than 9 kilometers (5.6 miles) higher than the surrounding plains. The crater--or caldera--at the volcano summit is approximately 110 km (68 mi) across. This view of Arsia Mons was taken by the red and blue wide angle cameras of the Mars Global Surveyor Mars Orbiter Camera (MOC) system. Bright water ice clouds (the whitish/bluish wisps) hang above the volcano--a common sight every martian afternoon in this region. Arsia Mons is located at 120° west longitude and 9° south latitude. Illumination is from the left.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/pia02337";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Ascraeus Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 104.5;
			poi.y = 11.8;
			poi.photoURI = "assets/img/ascraeusMons.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL/ASU";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA14089";
			poi.description = "This VIS image shows part of the eastern flank of Ascraeus Mons, one of the large Tharsis Volcanoes. The circular pits all aligned in a row mark the collapse of the roof of a lava tube.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA14089";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Elysium Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -146.9;
			poi.y = 24.8;
			poi.photoURI = "assets/img/elysium_m9_732X520.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL/Malin Space Science Systems";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/pia00412";
			poi.description = "The Elysium region contain the second largest volcanic complex on Mars, surpassed in size by only the Tharsis complex. Elysium Mons, whose summit elevation is 16,000 m above the Martian datum, is at the crest of a regional topographic rise that emerges steeply and abruptly from the surrounding plains.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/pia00412";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Hecates Tholus";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = -150.2;
			poi.y = 32.1;
			poi.photoURI = "assets/img/PIA04813_modest.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL/Malin Space Science Systems";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA04813";
			poi.description = "This Mars Global Surveyor (MGS) Mars Orbiter Camera (MOC) red wide angle image shows Hecates Tholus, the northernmost of the three large Elysium volcanoes. The non-circular pit just southwest (toward lower left) of the center of this view is the summit caldera, a complex depression formed by collapse. This volcano has several large impact craters on its surface, indicating that it is a relatively old landform. None of the martian volcanoes are thought to be active today, and none of the MOC images of the martian volcanoes obtained thus far give any indication to the contrary. Hecates Tholus is located at 32°N, 210°W. This picture is illuminated by sunlight from the lower left and covers an area about 170 km (~105 mi) across.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA04813";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Olympus Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 134;
			poi.y = 18.4;
			poi.photoURI = "assets/img/3dom.jpg";
			poi.photoCredit = "Illustration Credit: NASA/JPL";
			poi.photoSource = "http://marsprogram.jpl.nasa.gov/gallery/atlas/olympus-mons.html";
			poi.description = "The largest of the volcanoes in the Tharsis Montes region, as well as all known volcanoes in the solar system, is Olympus Mons. Olympus Mons is a shield volcano 624 km (374 mi) in diameter (approximately the same size as the state of Arizona), 25 km (16 mi) high, and is rimmed by a 6 km (4 mi) high scarp. A caldera 80 km (50 mi) wide is located at the summit of Olympus Mons. To compare, the largest volcano on Earth is Mauna Loa. Mauna Loa is a shield volcano 10 km (6.3 mi) high and 120 km (75 mi) across. The volume of Olympus Mons is about 100 times larger than that of Mauna Loa. In fact, the entire chain of Hawaiian islands (from Kauai to Hawaii) would fit inside Olympus Mons!";
			poi.descriptionSource = "http://marsprogram.jpl.nasa.gov/gallery/atlas/olympus-mons.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Pavonis Mons";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 113.4;
			poi.y = 0.8;
			poi.photoURI = "assets/img/PIA05243_modest.jpg";
			poi.photoCredit = "Illustration Credit: NASA/JPL/Malin Space Science Systems";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/pia05243";
			poi.description = "This Mars Global Surveyor (MGS) Mars Orbiter Camera (MOC) wide angle color composite image, obtained in December 2003, shows the middle of the three Tharsis Montes, Pavonis Mons. This is a broad shield volcano--similar to the volcanoes of Hawaii--located on the martian equator at 113°W. The volcano summit is near 14 km (~8.7 mi) above the martian datum (0 elevation); the central caldera (crater near center of image) is about 45 km (~28 mi.) across and about 4.5 km (~2.8 mi.) deep. Sunlight illuminates the scene from the lower left. ";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/pia05243";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Tharsis Tholus";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 90.8;
			poi.y = 13.4;
			poi.photoURI = "assets/img/vo1_225a13_br.png";
			poi.photoCredit = "Image Credit: NASA/JPL";
			poi.photoSource = "http://mars.jpl.nasa.gov/gallery/atlas/tharsis-tholus.html";
			poi.description = "Viking 1 Orbiter image of Tharsis Tholus, Mars. The volcano is partially buried, the exposed portion measures 170 km in diameter. Note the wide bench in the lower left of the caldera, which may be the remnants of an ancient lava lake.";
			poi.descriptionSource = "http://mars.jpl.nasa.gov/gallery/atlas/tharsis-tholus.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Uranius Patera";
			poi.tAlign = "R";
			poi.type = "Mountain";
			poi.x = 92.2;
			poi.y = 26.8;
			poi.photoURI = "assets/img/vo1_759a73.jpg";
			poi.photoCredit = "Image Credit: NASA";
			poi.photoSource = "http://nssdc.gsfc.nasa.gov/imgcat/html/object_page/vo1_759a73.html";
			poi.description = "Viking 1 Orbiter view of region east of Ceraunius Fossae, Mars, showing three volcanic shields. The one to the right with the large caldera is Uranius Patera. To the left is the slightly smaller Ceraunius Tholus, showing steep sides and a large channel and impact crater to the North. Above this is the small Uranius Tholus. North is at ~12:30. The image width is 750 km. (Viking Orbiter 759A73)";
			poi.descriptionSource = "http://nssdc.gsfc.nasa.gov/imgcat/html/object_page/vo1_759a73.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Biblis Patera";
			poi.tAlign = "L";
			poi.type = "Mountain";
			poi.x = 124.6;
			poi.y = 2.6;
			poi.photoURI = "assets/img/vo2_044b50.jpg";
			poi.photoCredit = "Image Credit: NASA";
			poi.photoSource = "http://nssdc.gsfc.nasa.gov/imgcat/html/object_page/vo2_044b50.html";
			poi.description = "The small Martian volcano Biblis Patera is shown in this Viking 2 Orbiter image. The diameter of the exposed portion is about 100 km. Truncation of the flow features on the volcano's flanks by surrounding plains material indicates that part of the edifice is buried. Note the circular faults surrounding the caldera. North is at ~11:30 in this image, which is about 200 km across. (Viking Orbiter 044B50)";
			poi.descriptionSource = "http://nssdc.gsfc.nasa.gov/imgcat/html/object_page/vo2_044b50.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Ceraunius Tholus";
			poi.tAlign = "L";
			poi.type = "Mountain";
			poi.x = 97.4;
			poi.y = 24;
			poi.photoURI = "assets/img/cerauniusTholus.jpg";
			poi.photoCredit = "Image Credit: NASA";
			poi.photoSource = "http://www.jpl.nasa.gov/spaceimages/details.php?id=PIA13617";
			poi.description = "This VIS image shows part of the summit caldera of Ceraunius Tholus, one of the smaller volcanoes of the Tharsis region.";
			poi.descriptionSource = "http://www.jpl.nasa.gov/spaceimages/details.php?id=PIA13617";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			/////////////////////////
			//Spacecraft
			/////////////////////////
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars 2 Lander (USSR)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -47;
			poi.y = -45.0;
			poi.photoURI = "assets/img/mars3_iki.jpg";
			poi.photoCredit = "Illustration Credit: NASA";
			poi.photoSource = "http://nssdc.gsfc.nasa.gov/nmc/spacecraftDisplay.do?id=1971-045A";
			poi.description = "Launched: 1971\nResults: First man-made object on Mars. Failed during descent.\n\nThe Mars 2 and Mars 3 missions consisted of identical spacecraft, each with a bus/orbiter module and an attached descent/lander module. The primary scientific objectives of the Mars 2 orbiter were to image the martian surface and clouds, determine the temperature on Mars, study the topography, composition and physical properties of the surface, measure properties of the atmosphere, monitor the solar wind and the interplanetary and martian magnetic fields, and act as a communications relay to send signals from the lander to Earth.";
			poi.descriptionSource = "http://nssdc.gsfc.nasa.gov/nmc/spacecraftDisplay.do?id=1971-045A";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars 3 Lander (USSR)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 158;
			poi.y = -45.0;
			poi.photoURI = "assets/img/mars3_iki.jpg";
			poi.photoCredit = "Illustration Credit: NASA";
			poi.photoSource = "http://nssdc.gsfc.nasa.gov/nmc/spacecraftDisplay.do?id=1971-045A";
			poi.description = "Launched: 1971\nResults: First successful landing on Mars, sent signal for 20 seconds after landing.\n\nThe Mars 2 and Mars 3 missions consisted of identical spacecraft, each with a bus/orbiter module and an attached descent/lander module. The primary scientific objectives of the Mars 2 orbiter were to image the martian surface and clouds, determine the temperature on Mars, study the topography, composition and physical properties of the surface, measure properties of the atmosphere, monitor the solar wind and the interplanetary and martian magnetic fields, and act as a communications relay to send signals from the lander to Earth.";
			poi.descriptionSource = "http://nssdc.gsfc.nasa.gov/nmc/spacecraftDisplay.do?id=1971-045A";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars 6 Lander (USSR)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 19.45;
			poi.y = -23.92;
			poi.photoURI = "assets/img/mars_6-7-browse.jpg";
			poi.photoCredit = "Model Photo Credit: NSSDC Photo Gallery";
			poi.photoSource = "http://solarsystem.nasa.gov/multimedia/display.cfm?Category=Spacecraft&IM_ID=3443";
			poi.description = "Launched: 1973\nResults: Failed, contact lost just before touchdown.\n\nMars 6 was one of two landers launched by the Soviet Union during the 1973 launch window. The landers were very similar in design to the Mars 2 and Mars 3 landers dispatched by the Soviets in 1971, except that the spacecraft was now composed of a flyby vehicle (instead of an orbiter) and a lander.";
			poi.descriptionSource = "http://solarsystem.nasa.gov/missions/profile.cfm?Sort=Nation&MCode=Mars_06&Nation=USSR&Display=ReadMore";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Viking 1 Lander (USA)";
			poi.tAlign = "L";
			poi.type = "Spacecraft";
			poi.x = 47.95;
			poi.y = 22.46;
			poi.photoURI = "assets/img/27.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL-Caltech/University of Arizona";
			poi.photoSource = "http://www.nasa.gov/multimedia/imagegallery/image_feature_2055.html";
			poi.description = "Launched: 1975\nResults: Landed successfully, operated for more than 6 years. Returned extensive science results.\n\nNASA's Viking Project found a place in history when it became the first U.S. mission to land a spacecraft successfully on the surface of Mars. Two identical spacecraft, each consisting of a lander and an orbiter, were built. Each orbiter-lander pair flew together and entered Mars orbit; the landers then separated and descended to the planet's surface. Viking 2 launched 36 years ago today on Sept. 9, 1975. This photo shows a test version of the landers in the original \"Mars Yard\" built at NASA's Jet Propulsion Laboratory in 1975.\n\nThe Viking 2 lander settled down at Utopia Planitia on Sept. 3, 1976, while the Viking 1 Lander touched down on the western slope of Chryse Planitia (the Plains of Gold) on July 20, 1976.";
			poi.descriptionSource = "http://www.nasa.gov/multimedia/imagegallery/image_feature_2055.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Viking 2 Lander (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -133.74;
			poi.y = 47.93;
			poi.photoURI = "assets/img/PIA01522.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL";
			poi.photoSource = "http://photojournal.jpl.nasa.gov/catalog/PIA01522";
			poi.description = "Launched: 1975\nResults: Landed successfully, operated for more than 3.5 years. Returned extensive science results.\n\nThe boulder-strewn field of red rocks reaches to the horizon nearly two miles from Viking 2 on Mars' Utopian Plain. Scientists believe the colors of the Martian surface and sky in this photo represent their true colors. Fine particles of red dust have settled on spacecraft surfaces. The salmon color of the sky is caused by dust particles suspended in the atmosphere. Color calibration charts for the cameras are mounted at three locations on the spacecraft. Note the blue star field and red stripes of the flag. The circular structure at top is the high-gain antenna, pointed toward Earth. Viking 2 landed September 3,1976, some 4600 miles from its twin, Viking 1, which touched down on July 20.";
			poi.descriptionSource = "http://photojournal.jpl.nasa.gov/catalog/PIA01522";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars Pathfinder Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = 33.25;
			poi.y = 19.26;
			poi.photoURI = "assets/img/pathfinder01_br.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL";
			poi.photoSource = "http://mars.jpl.nasa.gov/spotlight/pathfinder-image01.html";
			poi.description = "Launched: 1996\nResults: Landed successfully, operated for just under 3 months.\nPhoto Description: Sojourner taking an Alpha Proton X-ray Spectrometer measurement of Yogi.\n\nThe lander, formally named the Carl Sagan Memorial Station following its successful touchdown, and the rover, named Sojourner after American civil rights crusader Sojourner Truth, both outlived their design lives — the lander by nearly three times, and the rover by 12 times.\n\nFrom landing until the final data transmission on September 27, 1997, Mars Pathfinder returned 2.3 billion bits of information, including more than 16,500 images from the lander and 550 images from the rover, as well as more than 15 chemical analyses of rocks and soil and extensive data on winds and other weather factors. Findings from the investigations carried out by scientific instruments on both the lander and the rover suggest that Mars was at one time in its past warm and wet, with water existing in its liquid state and a thicker atmosphere. ";
			poi.descriptionSource = "http://www.nasa.gov/multimedia/imagegallery/image_feature_2055.html";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Mars Polar Lander (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -164.7;
			poi.y = -76.7;
			poi.photoURI = "assets/img/mpl9810296.jpg";
			poi.photoCredit = "Image Credit: NASA/JPL";
			poi.photoSource = "http://mars.jpl.nasa.gov/msp98/images/mpl981029.html";
			poi.description = "Launched: 1999\nResults: Failed. Crashed just prior to landing due to premature engine shutdown.\nPhoto Description: A KSC technician looks over the Mars Polar Lander before its encapsulation inside the backshell, a protective cover.\n\nThe Mars Surveyor '98 program was comprised of two spacecraft launched separately, the Mars Climate Orbiter (formerly the Mars Surveyor '98 Orbiter) and the Mars Polar Lander (formerly the Mars Surveyor '98 Lander). They were designed to study the Martian weather, climate, and water and carbon dioxide budget.\n\nThe goal of MPL was to soft land, under propulsive power, near the edges of the south polar ice cap on Mars and to use cameras, a robotic arm and several sophisticated instruments to measure the Martian soil composition.";
			poi.descriptionSource = "http://science1.nasa.gov/missions/mars-polar-lander/";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "MER Spirit Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -175.47;
			poi.y = -14.57;
			poi.photoURI = "assets/img/494583main_pia04413-4x3_946-710.jpg";
			poi.photoCredit = "Artist Concept Image Credit: NASA/JPL/Cornell University";
			poi.photoSource = "http://www.nasa.gov/mission_pages/mer/multimedia/gallery/pia04413.html";
			poi.description = "Launched: 2003\nResults: Landed successfully in January of 2004, operated for just over 7 years, 4 months.\n\nSpirit drove 4.8 miles (7.73 kilometers), more than 12 times the goal set for the mission. The drives crossed a plain to reach a distant range of hills that appeared as mere bumps on the horizon from the landing site; climbed slopes up to 30 degrees as Spirit became the first robot to summit a hill on another planet; and covered more than half a mile (nearly a kilometer) after Spirit's right-front wheel became immobile in 2006. The rover returned more than 124,000 images. It ground the surfaces off 15 rock targets and scoured 92 targets with a brush to prepare the targets for inspection with spectrometers and a microscopic imager.";
			poi.descriptionSource = "http://www.jpl.nasa.gov/news/news.php?release=2011-160";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "MER Opportunity Rover (USA)";
			poi.tAlign = "L";
			poi.type = "Spacecraft";
			poi.x = 5.53;
			poi.y = -1.95;
			poi.photoURI = "assets/img/494583main_pia04413-4x3_946-710.jpg";
			poi.photoCredit = "Artist Concept Image Credit: NASA/JPL/Cornell University";
			poi.photoSource = "http://www.nasa.gov/mission_pages/mer/multimedia/gallery/pia04413.html";
			poi.description = "Launched: 2003\nResults: Landed successfully in January of 2004, and still running.\n\n The Mars Exploration Rover (MER) Opportunity landed on Mars on January 25, 2004. The rover was originally designed for a 90 Sol mission (a Sol, one Martian day, is slightly longer than an Earth day at 24 hours and 37 minutes). Its mission has been extended several times as it continues to make new and profound discoveries about the red planet.\n\nOpportunity landed on the opposite side of Mars from its twin, Spirit, on a flat plain known as Meridiani Planum. This region had been chosen because the Mars Global Surveyor mission had identified concentrations of the mineral hematite there and on Earth the presence of hematite is often associated with water. Opportunity’s landing is often referred to as a \"hole-in-one\" because the spacecraft unexpectedly came to a rest inside a small crater. Opportunity did indeed find hematite here, in the form of small concretions nicknamed \"blueberries.\"";
			poi.descriptionSource = "http://science1.nasa.gov/missions/mars-rovers/";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://www.google.com/mars/
			poi = {};
			poi.title = "Beagle 2 Lander (UK)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -90;
			poi.y = 10.6;
			poi.photoURI = "assets/img/roboticarm1.jpg";
			poi.photoCredit = "Image Credit: Beagle 2, all rights reserved.";
			poi.photoSource = "http://science.nasa.gov/science-news/science-at-nasa/2003/17dec_beagle2/";
			poi.description = "Launched: 2003\nResults: Failed during descent.\n\nGreat Britain's Beagle 2 lander was a barbecue grill-sized lander equipped with a suite of instruments to search for signs of life on Mars. It also had instruments to look for signs of water and study Mars' geology and atmosphere. It rode to Mars aboard the European Space Agency's Mars Express orbiter.";
			poi.descriptionSource = "http://science.nasa.gov/science-news/science-at-nasa/2003/17dec_beagle2/";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			//source: http://mars.jpl.nasa.gov/msl/mission/timeline/prelaunch/landingsiteselection/aboutgalecrater/
			poi = {};
			poi.title = "Curiosity Rover (USA)";
			poi.tAlign = "R";
			poi.type = "Spacecraft";
			poi.x = -137.4;
			poi.y = -4.5;
			poi.photoURI = "assets/img/rocknest_curiosity_960.jpg";
			poi.photoCredit = "Image Credit: NASA, JPL-Caltech, MSSS, MAHLI";
			poi.photoSource = "http://apod.nasa.gov/apod/ap121227.html";
			poi.description = "Launched: 2012\nResults: Landed successfully. Currently in operation.\n\nWith its rover named Curiosity, Mars Science Laboratory mission is part of NASA's Mars Exploration Program, a long-term effort of robotic exploration of the red planet. Curiosity was designed to assess whether Mars ever had an environment able to support small life forms called microbes. In other words, its mission is to determine the planet's \"habitability.\"\n\nTo find out, the rover carries the biggest, most advanced suite of instruments for scientific studies ever sent to the martian surface. The rover will analyze samples scooped from the soil and drilled from rocks. The record of the planet's climate and geology is essentially \"written in the rocks and soil\" -- in their formation, structure, and chemical composition. The rover's onboard laboratory will study rocks, soils, and the local geologic setting in order to detect chemical building blocks of life (e.g., forms of carbon) on Mars and will assess what the martian environment was like in the past.";
			poi.descriptionSource = "http://mars.jpl.nasa.gov/msl/mission/overview/";
			poi.descriptionSource2 = "http://www.google.com/mars/";
			points.push(poi);
			
			trace(points.length);
			
		}

	}
	
}

