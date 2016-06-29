function noenter(ev)
{
    if (window.event && window.event.keyCode == 13 || ev.which == 13)
    {  
        return false;
    }
    else
    {
        return true;
    }
}

function json2xml(o, tab) {
   var toXml = function(v, name, ind) {
      var xml = "";
      if (v instanceof Array) {
         for (var i=0, n=v.length; i<n; i++)
            xml += ind + toXml(v[i], name, ind+"\t") + "\n";
      }
      else if (typeof(v) == "object") {
         var hasChild = false;
         xml += ind + "<" + name;
         for (var m in v) {
            if (m.charAt(0) == "@")
               xml += " " + m.substr(1) + "=\"" + v[m].toString() + "\"";
            else
               hasChild = true;
         }
         xml += hasChild ? ">" : "/>";
         if (hasChild) {
            for (var m in v) {
               if (m == "#text")
                  xml += v[m];
               else if (m == "#cdata")
                  xml += "<![CDATA[" + v[m] + "]]>";
               else if (m.charAt(0) != "@")
                  xml += toXml(v[m], m, ind+"\t");
            }
            xml += (xml.charAt(xml.length-1)=="\n"?ind:"") + "</" + name + ">";
         }
      }
      else {
         xml += ind + "<" + name + ">" + v.toString() +  "</" + name + ">";
      }
      return xml;
   }, xml="";
   for (var m in o)
      xml += toXml(o[m], m, "");
   return tab ? xml.replace(/\t/g, tab) : xml.replace(/\t|\n/g, "");
}

function createPartDiv(id, n)
{
    var divTag = document.createElement("div");
    divTag.id = "partDiv-"+id;            
    //divTag.setAttribute("align","center");
    divTag.style.display = "block";
    divTag.style.margin = "0px auto";
    divTag.style.padding = "4px";
    divTag.style.border = "1px solid #ECECEC";
    divTag.className ="dynamicDiv";
    divTag.innerHTML = n;
   
   if(document.getElementById('partDiv-'+id)) {
   	alert('Element Exists');
   } else {
   	document.getElementById("partLineTable").appendChild(divTag);
   }
}