<style type="text/css">
.PartRowWrapper{
   position: relative;
   float: left;
   left: 0.00%;
   width: 100.00%;
   margin-bottom: 0.2%;
}
.PartRow {
	margin: 5px;
	padding: 5px;
	height:auto;
	min-height:30px;
	height:auto !important;        /* for IE as it does not support min-height */
	height:30px;    
}
.c1{
   position: relative;
   float: left;
   left: 0.1%;
   width: 5.00%;
   height: 28px;
   border-bottom: 1px solid #CCC;
}
.c2{
   position: relative;
   float: left;
   left: 0.3%;
   width: 35.00%;
   height: 28px;
   border-bottom: 1px solid #CCC;
}
.c3{
   position: relative;
   float: left;
   left: 0.5%;
   width: 11.80%;
   height: 28px;
   border-bottom: 1px solid #CCC; 
}
.c4{
   position: relative;
   float: left;
   left: 0.7%;
   width: 11.80%;
   height: 28px;
   border-bottom: 1px solid #CCC;
   
}
.c4PL {
   position: relative;
   float: left;
   left: 0.7%;
   width: 5.00%;
   height: 28px;
   border-bottom: 1px solid #CCC;
   
}
.c5{
   position: relative;
   float: left;
   left: 0.9%;
   width: 9.80%;
   height: 28px;
   text-align:right;
   border-bottom: 1px solid #CCC;
}
.c6 {
   position: relative;
   float: left;
   left: 1.1%;
   width: 9.80%;
   height: 28px;
   text-align:right;
   border-bottom: 1px solid #CCC;
}
.c7{
   position: relative;
   float: left;
   left: 1.3%;
   width: 9.80%;
   height: 28px;
   text-align:right;
   border-bottom: 1px solid #CCC;	
}

nav.partApp {
	margin: 0px 0px 0px 0px; 
	text-align: left;
}

nav.partApp ul ul {
	display: none;
}

	nav.partApp ul li:hover > ul {
		display: block;
	}


nav.partApp ul {
	background: #efefef; 
	background: linear-gradient(top, #efefef 0%, #bbbbbb 100%);  
	background: -moz-linear-gradient(top, #efefef 0%, #bbbbbb 100%); 
	background: -webkit-linear-gradient(top, #efefef 0%,#bbbbbb 100%); 
	box-shadow: 0px 0px 9px rgba(0,0,0,0.15);
	padding: 0px 3px 0px 3px;
	border-radius: 2px;  
	list-style: none;
	position: relative;
	display: inline-table;
}
	nav.partApp ul:after {
		content: ""; clear: both; display: block;
	}

	nav.partApp ul li {
		float: left;
	}
		nav.partApp ul li:hover {
			background: #4b545f;
			background: linear-gradient(top, #4f5964 0%, #5f6975 40%);
			background: -moz-linear-gradient(top, #4f5964 0%, #5f6975 40%);
			background: -webkit-linear-gradient(top, #4f5964 0%,#5f6975 40%);
		}
			nav.partApp ul li:hover a {
				color: #fff;
			}
		
		nav.partApp ul li a {
			display: block; padding: 0px;
			color: #757575; text-decoration: none;
		}
			
		
	nav.partApp ul ul {
		background: #5f6975; border-radius: 0px; padding: 0;
		position: absolute; top: 100%;
	}
		nav.partApp ul ul li {
			float: none; 
			border-top: 1px solid #6b727c;
			border-bottom: 1px solid #575f6a; position: relative;
			padding-left: 15px;
		}
			nav.partApp ul ul li a {
				padding: 10px 140px;
				color: #fff;
			}	
				nav.partApp ul ul li a:hover {
					background: #4b545f;
				}
		
	nav.partApp ul ul ul {
		position: absolute; left: 100%; top:0;
	}
	
#box {
    margin-top: 20px;
}
.bt, .clicked {
    height: 20px;
    color: #666;
    font-size: 13px;
    padding: 1px 1px 1px 1px
    text-decoration: none;
    background: #f9f9f9;
}

a.bt:link {text-decoration: none;} //the original link with no underline
a.bt:visited {text-decoration: none;} //the visited link with no underline
a.bt:hover {text-decoration: none;}

#box .bt {
    background: -moz-linear-gradient(top,  #fff,  #f3f3f3);
    background: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#f3f3f3));

    /* For Internet Explorer 5.5 - 7 */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffffff, endColorstr=#f3f3f3);
    /* For Internet Explorer 8 */
    -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffffff, endColorstr=#f3f3f3)";
}
#box .bt:hover {
    background: #f3f3f3;
    background: -moz-linear-gradient(top,  #fff,  #e9e9e9);
    background: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#e9e9e9));

    /* For Internet Explorer 5.5 - 7 */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffffff, endColorstr=#e9e9e9);
    /* For Internet Explorer 8 */
    -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#ffffff, endColorstr=#e9e9e9)";
}
#box .bt:active, .clicked {
    background: #e9e9e9;
    background: -moz-linear-gradient(top,  #e9e9e9,  #fff);
    background: -webkit-gradient(linear, left top, left bottom, from(#e9e9e9), to(#fff));

    /* For Internet Explorer 5.5 - 7 */
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#e9e9e9, endColorstr=#ffffff);
    /* For Internet Explorer 8 */
    -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#e9e9e9, endColorstr=#ffffff)";
}
.btleft {
    border: 1px solid #e3e3e3;
    -webkit-border-radius: .5em 0 0 .5em;
    -moz-border-radius: .5em 0 0 .5em;
    border-radius: .5em 0 0 .5em;
}
.btleft span {
    font-size: 15px;
}
.btmiddle {
    border: 1px solid #e3e3e3;
    border-width: 1px 0;
    margin: 0 -4px;
}            
.btright {
    border: 1px solid #e3e3e3;
    -webkit-border-radius: 0 .5em .5em 0;
    -moz-border-radius: 0 .5em .5em 0;
    border-radius: 0 .5em .5em 0;
}
.btmiddle span, .btright span {
    font-size: 9px;
    position: relative;
    top: -2px;
}
#menu {
    margin: 10px 0 0 100px;
    display: none;
}
#triangle {
    border: 1px solid #d9d9d9;
    border-width: 2px 0 0 2px;
    width:10px;
    height:10px;
    /* for firefox, safari, chrome, etc. */
    -webkit-transform: rotate(45deg);
    -moz-transform: rotate(45deg);
    -o-transform:rotate(45deg);
    z-index: 1;
    position: relative;
    bottom: -4px;
    margin-left: 25px;
    background: #fff;
}
#tooltip_menu {
    background: #fff;
    -webkit-border-radius: .5em;
    -moz-border-radius: .5em;
    border-radius: .5em;
    width: 220px;
    -webkit-box-shadow: 0px 0px 3px rgba(0,0,0,.5);
    -moz-box-shadow: 0px 0px 3px rgba(0,0,0,.5);
    box-shadow: 0px 0px 3px rgba(0,0,0,.5);
    padding: 2px;
}
#tooltip_menu a {
    z-index: 2;
    padding: 0 0 7px 2px;
    display: block;
    text-decoration: none;
    color: #0066cc;
    font-size: 13px;
}
#tooltip_menu a:hover {
    background: #0066cc;
    color: #fff;
}
#tooltip_menu a img {
    position: relative;
    top: 5px;
    border: 0;
}
.menu_top {
    -webkit-border-radius: .5em .5em 0 0;
    -moz-border-radius: .5em .5em 0 0;
    border-radius: .5em .5em 0 0;
}
.menu_bottom {
    -webkit-border-radius: 0 0 .5em .5em;
    -moz-border-radius: 0 0 .5em .5em;
    border-radius: 0 0 .5em .5em;
}

#links {
	padding: 10px;
}
#links a {
	font-size: 11px;
	color: #0066cc;
}
#links a:hover {
	text-decoration: none;
}	

.tblB {
  border-bottom:1px solid #ECECEC;
}
</style>