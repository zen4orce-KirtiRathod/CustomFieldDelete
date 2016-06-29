/*-------------------------------------------------------------------- 
 * JQuery Plugin: "EqualHeights" & "EqualWidths"
 * by:
   Scott Jehl (scott@filamentgroup.com) 
   Todd Parker (todd@filamentgroup.com)
   http://www.filamentgroup.com
 *
 * Copyright (c) 2007 Filament Group
 * Licensed under GPL (http://www.opensource.org/licenses/gpl-license.php)
 *
 * Description: Compares the heights of the first-children of a provided element 
 								  and sets their min-height to the tallest height. Sets in em units by default if pxToEm() method is available.
 * Dependencies: jQuery library, pxToEm method (article: http://www.filamentgroup.com/lab/retaining_scalable_interfaces_with_pixel_to_em_conversion/)						  
 * Usage Example: j$(element).equalHeights();
   						      Optional: to set min-height in px, pass a true argument: j$(element).equalHeights(true);
 * Version: 1.0, 08.02.2007
 * Changelog:
 *  08.02.2007 initial Version 1.0
--------------------------------------------------------------------*/
var j$ = jQuery.noConflict();
j$.fn.equalHeights = function(px) {
	j$(this).each(function(){
		var currentTallest = 0;
		j$(this).children().each(function(i){
			if(j$(this).height() > currentTallest) { currentTallest = j$(this).height(); }
		});
		if(!px || !Number.prototype.pxToEm) currentTallest = currentTallest.pxToEm(j$(this)); //use ems unless px is specified or 
		// for ie6, set height since min-height isn't supported
		var ie6 = (navigator.appName == "Microsoft Internet Explorer" && parseInt(navigator.appVersion) == 4 && navigator.appVersion.indexOf("MSIE 6.0") != -1);
		if (j$.browser.msie && (ie6)) { j$(this).children().css({'height': currentTallest}); }
		j$(this).children().css({'min-height': currentTallest}); 
	});
	return j$(this);
};

j$.fn.equalWidths = function(px) {
	j$(this).each(function(){
		var currentWidest = 0;
		j$(this).children().each(function(i){
				if(j$(this).width() > currentWidest) { currentWidest = j$(this).width(); }
		});
		if(!px || !Number.prototype.pxToEm) currentWidest = currentWidest.pxToEm(j$(this)); //use ems unless px is specified or 
		// for ie6, set width since min-width isn't supported
		var ie6 = (navigator.appName == "Microsoft Internet Explorer" && parseInt(navigator.appVersion) == 4 && navigator.appVersion.indexOf("MSIE 6.0") != -1);
		if (j$.browser.msie && (ie6)) { j$(this).children().css({'width': currentWidest}); }
		j$(this).children().css({'min-width': currentWidest}); 
	});
	return j$(this);
};


/*-------------------------------------------------------------------- 
 * javascript method: "pxToEm"
 * by:
   Scott Jehl (scott@filamentgroup.com) 
   Maggie Wachs (maggie@filamentgroup.com)
   http://www.filamentgroup.com
 *
 * Copyright (c) 2008 Filament Group
 * Dual licensed under the MIT (filamentgroup.com/examples/mit-license.txt) and GPL (filamentgroup.com/examples/gpl-license.txt) licenses.
 *
 * Description: Extends the native Number and String objects with pxToEm method. pxToEm converts a pixel value to ems depending on inherited font size.  
 * Article: http://www.filamentgroup.com/lab/retaining_scalable_interfaces_with_pixel_to_em_conversion/
 * Demo: http://www.filamentgroup.com/examples/pxToEm/	 	
 *							
 * Options:  	 								
 		scope: string or jQuery selector for font-size scoping
 		reverse: Boolean, true reverses the conversion to em-px
 * Dependencies: jQuery library						  
 * Usage Example: myPixelValue.pxToEm(); or myPixelValue.pxToEm({'scope':'#navigation', reverse: true});
 *
 * Version: 2.0, 08.01.2008 
 * Changelog:
 *		08.02.2007 initial Version 1.0
 *		08.01.2008 - fixed font-size calculation for IE
--------------------------------------------------------------------*/

Number.prototype.pxToEm = String.prototype.pxToEm = function(settings){
	//set defaults
	settings = jQuery.extend({
		scope: 'body',
		reverse: false
	}, settings);
	
	var pxVal = (this == '') ? 0 : parseFloat(this);
	var scopeVal;
	var getWindowWidth = function(){
		var de = document.documentElement;
		return self.innerWidth || (de && de.clientWidth) || document.body.clientWidth;
	};	
	
	/* When a percentage-based font-size is set on the body, IE returns that percent of the window width as the font-size. 
		For example, if the body font-size is 62.5% and the window width is 1000px, IE will return 625px as the font-size. 	
		When this happens, we calculate the correct body font-size (%) and multiply it by 16 (the standard browser font size) 
		to get an accurate em value. */
				
	if (settings.scope == 'body' && j$.browser.msie && (parseFloat(j$('body').css('font-size')) / getWindowWidth()).toFixed(1) > 0.0) {
		var calcFontSize = function(){		
			return (parseFloat(j$('body').css('font-size'))/getWindowWidth()).toFixed(3) * 16;
		};
		scopeVal = calcFontSize();
	}
	else { scopeVal = parseFloat(jQuery(settings.scope).css("font-size")); };
			
	var result = (settings.reverse == true) ? (pxVal * scopeVal).toFixed(2) + 'px' : (pxVal / scopeVal).toFixed(2) + 'em';
	return result;
};


/*-------------------------------------------------------------------- 
Utility functions
Version: 1.0, 01.18.2008

By: Maggie Costello Wachs (maggie@filamentgroup.com)
	http://www.filamentgroup.com
		
Copyright (c) 2007 Filament Group
Licensed under GPL (http://www.opensource.org/licenses/gpl-license.php)

Dependencies:
	jQuery library
--------------------------------------------------------------------*/

function sortBigToSmall(a, b) { return b - a; };

function getScrollTop(){
	return self.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
};

function getScrollLeft(){
	return self.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft;
};

function getWindowHeight(){
	var de = document.documentElement;
	return self.innerHeight || (de && de.clientHeight) || document.body.clientHeight;
};

function getWindowWidth(){
	var de = document.documentElement;
	return self.innerWidth || (de && de.clientWidth) || document.body.clientWidth;
};

// getTotalWidth/Height finds the width/height of an element including padding
jQuery.fn.getTotalWidth = function(){
	return j$(this).width() + parseInt(j$(this).css('paddingRight')) + parseInt(j$(this).css('paddingLeft'));
};

jQuery.fn.getTotalHeight = function(){
	return j$(this).height() + parseInt(j$(this).css('paddingTop')) + parseInt(j$(this).css('paddingBottom'));
};

// assign random ids to a single element or a group of child elements
jQuery.fn.setRandomId = function(settings){
	var settings = jQuery.extend({
		children: null, // selectors for child elements (acts only on the caller element by default)
		attribute: null // attribute, if not id (default)
	}, settings);
	
	var thisAttr = settings.attribute || 'id';
		
	var setId = function(el){
		var newId = 'id_' + Math.floor(Math.random()*9999);
		el.attr(thisAttr, newId);
	};
	
	if (settings.children) {
		j$(this).find(settings.children).each(setId(j$(this)));
	}
	else { setId(j$(this)); }
	
	return j$(this);
};

// Test to see if this element will fit in the viewport
/* Parameters:
	@el = element to position, required
	@leftOffset / @topOffset = optional parameter if the offset cannot be calculated (i.e., if the object is in the DOM but is set to display: 'none')
*/
function fitHorizontal(el, leftOffset){
	var leftVal = parseInt(leftOffset) || j$(el).offset().left;
	return (leftVal + j$(el).width() <= getWindowWidth() + getScrollLeft() && leftVal - getScrollLeft() >= 0);
};

function fitVertical(el, topOffset){
	var topVal = parseInt(topOffset) || j$(el).offset().top;
	return (topVal + j$(el).height() <= getWindowHeight() + getScrollTop() && topVal - getScrollTop() >= 0);
};