var j$ = jQuery.noConflict();
j$(document).ready(function() {
	
	// Collapse System info div
	if(document.getElementById('partInvoice:partsInvoiceForm:headBlock:sysinfo')!=null) {
		twistSection(document.getElementById('partInvoice:partsInvoiceForm:headBlock:sysinfo').childNodes[0].childNodes[0]);
	}
	
	if(document.getElementById('partInvoice:partsInvoiceForm:headBlock:totalsSection')!=null) {
		twistSection(document.getElementById('partInvoice:partsInvoiceForm:headBlock:totalsSection').childNodes[0].childNodes[0]);
	}
	
	// Create mode input var assignment
	if(pageMode == "create") {
    	j$("#PartsCreateInvoicePage\\:CreateInvoiceForm\\:counterSalesPB\\:detailSection\\:CountermanInput").val(countermanName);  
    	j$("#PartsCreateInvoicePage\\:CreateInvoiceForm\\:counterSalesPB\\:detailSection\\:CountermanInput_lkold").val(countermanName);    
    	j$("#PartsCreateInvoicePage\\:CreateInvoiceForm\\:counterSalesPB\\:detailSection\\:CountermanInput_lkid").val(countermanId);
    }
    
    // If Mode is edit (existing invoice) load parts grid
    if(pageMode == "edit") {
    	loadPartsGrid();
    }
    
    // If Invoiced, remove ability to add or modify parts.
    if(invoiceDateTime!='') {
    	j$(esc(partName_element)).prop('disabled', true);
    	j$(esc(partQuantity_element)).prop('disabled', true);
    }
    
    // Price Override (Percent Field)
    j$("#netpricepercent").keydown(function(event) {
        if(event.keyCode == 13) {
            calcPriceDialog_Percent();
            j$("#baselist").focus();
        } else {
        
        if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9) {
            // Allow only backspace and delete
        }
        else {
            // Ensure that it is a number and stop the keypress
            if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 ) && event.keyCode != 190) {
                event.preventDefault(); 
            }   
        }
      }        
    });
    
    // Price Override (Adjusted Price Field)
    j$("#adjustedprice").keydown(function(event) {
    	cLog(event.keyCode);
        if(event.keyCode == 13) {
            calcPriceDialog_Dollar();
        } else {
        
        if ( event.keyCode == 46 || event.keyCode == 190 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 110) {
            // Allow only backspace and delete
        }
        else {
            // Ensure that it is a number and stop the keypress
            if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
                event.preventDefault(); 
            }   
        }
      }     
    });
    
    // Quantity Adjustment Fields
    j$('#zqPartSP').change(function() {
    	j$('#zqPartQTY').val((j$('#zqPartSP').val() / 1) + (j$('#zqPartOP').val() / 1) + (j$('#zqPartNP').val() / 1));
    	j$('#zqPartOP').prop('disabled', true);
    	j$('#zqPartNP').prop('disabled', true);
    });
    
    // Custom Shipping Address
    if(j$(esc('partInvoice:partsInvoiceForm:headBlock:headSection:customShipping:customShipToAddress'))) {
    	j$(esc('partInvoice:partsInvoiceForm:headBlock:headSection:customShipping:customShipToAddress')).click(function() {
    		showShippingAddressDialog();
    	});
    	j$(esc('partInvoice:partsInvoiceForm:headBlock:headSection:customShipping:customShipToAddress')).mouseover(function() {
    		j$(esc('partInvoice:partsInvoiceForm:headBlock:headSection:customShipping:customShipToAddress')).css('cursor', 'pointer');
    	}).mouseout(function() {
    		j$(esc('partInvoice:partsInvoiceForm:headBlock:headSection:customShipping:customShipToAddress')).css('cursor', 'default');
    	});
    	
    }
    
    // Set PL
	if(pageMode == 'create') {
		setPL();
	}

	// Derive PL from page
	if(j$('[id$="initPL_ID"]').val()!='' && activePriceLevelId=='') {
		activePriceLevelId=j$('[id$="initPL_ID"]').val();
	}

	if(j$('[id$="initPL_Method"]').val()!='' && activePriceLevelMethod=='') {
		activePriceLevelMethod=j$('[id$="initPL_Method"]').val();
	}	

	if(j$('[id$="initPLPercent"]').val()!='' && activePriceLevelPercent=='') {
		activePriceLevelPercent=parseInt(j$('[id$="initPLPercent"]').val());
	}

    // Build Menu Actions
    j$("#menuActions").hide();
        
});

var invObj      = new Object();
var pObj        = new Object();
    pObj.data   = new Array();
    
var saleamount  =   0;
var saleOtype   =   "In Stock";
var zqOrderType =   "";
var zq_Override =   false;
var kit_Override=	false;
var zq_PartNo   =   "";
var zq_Desc     =   "";
var zq_DropShip	=	false;

var zq_QTY      =   0;
var sold_NP		=	0;
var sold_OP		=	0;
var sold_Order  = 	0;
var sold_In_Stock	   = 0;

var activePriceLevelId   = '';
var activePriceLevelName = '';
var activePriceLevelMethod='';
var activePriceLevelPercent='';

function setZQ_Method() {
	zqOrderType   = '';
	
    if(j$("#zqPartOP").val() != "" && j$("#zqPartOP").val() != 0) {	
        zq_QTY    	= j$("#zqPartOP").val();
        saleOtype 	= "Outside Purchase";
        zqOrderType	= saleOtype;
        sold_OP	  	= j$("#zqPartOP").val();
        cLog('Outside Purchase Method');
    } else if(j$("#zqPartSP").val() != "" && j$("#zqPartSP").val() != 0) {
        zq_QTY     	= j$("#zqPartSP").val();
        saleOtype  	= "Special Order";
        sold_Order 	= j$("#zqPartSP").val();
        zqOrderType = j$("#OrderType option:selected").val();
        cLog('Special Order Method');
    } else if(j$("#zqPartNP").val() != "" && j$("#zqPartNP").val() != 0) {
        zq_QTY    = j$("#zqPartNP").val();
        saleOtype = "Negative On-Hand";
        sold_NP	  =	j$("#zqPartNP").val();
        zqOrderType	=	saleOtype;
        cLog('NP Method');
    }
	//Drop Ship
	var DS	  = false;
    if(j$('#zqDropShip').is(":checked")) {
    	cLog('Drop Ship Activated');
		DS 	=	true;
		zq_DropShip = true;
	}
    
    
}

function getPL() {
	if(j$("#PLselect")!=null) {
    	var plId =  j$("#PLselect option:selected").val();
    	if(plId == undefined) {
    		return "";
    	} else {
    		return plId;
    	}
   	} else {
   		return "";
   	}
}

function getPLName() {
	if(j$("#PLselect")!=null) {
		return j$("#PLselect option:selected").text();
	} else {
		return "";
	}
}

function setPL(invoiceid) {
    // Update all pricing to the specified PL
    cLog('Set PL()');
    dealer.PartsInvoice_EXT.setPL(getPL(), function(result, event) {
       if(event.status) {
           // Replace all parts lines and recalculate
           cLog(result);
           // Set Active PL variables
		 	activePriceLevelId   = result.Id;
			activePriceLevelName = result.Name;
			activePriceLevelMethod=result.dealer__Method__c;
			activePriceLevelPercent=result.dealer__Parts_Variable_Amount__c;
            j$('#partLineTable').empty();
            j$('#partLineTable').height(0);
            if(pageMode == 'create') {
	           	for(var i=0; i < pObj.data.length; i+=1) {
	           		if(result.dealer__Method__c == 'List') {
	           		cLog('List method'+100+result.dealer__Parts_Variable_Amount__c+' -->'+((100+result.dealer__Parts_Variable_Amount__c) / 100));
	           			pObj.data[i]['dealer__Price__c']=pObj.data[i]['dealer__List__c']*((100+result.dealer__Parts_Variable_Amount__c) / 100); 
	           			pObj.data[i]['dealer__Extended_Total']=pObj.data[i]['dealer__Price__c'] * pObj.data[i]['dealer__Quantity_Sold__c'];
	           			pObj.data[i]['dealer__Net__c']=pObj.data[i]['dealer__Price__c'];
	           			pObj.data[i]['dealer__PLName']=getPLName();
	           			pObj.data[i]['dealer__PL']=getPL();
	           		}
	           		if(result.dealer__Method__c == 'Cost') {
	           			pObj.data[i]['dealer__Price__c']=pObj.data[i]['dealer__Cost__c']*((100+result.dealer__Parts_Variable_Amount__c) / 100); 
	           			pObj.data[i]['dealer__Extended_Total']=pObj.data[i]['dealer__Price__c'] * pObj.data[i]['dealer__Quantity_Sold__c'];
	           			pObj.data[i]['dealer__Net__c']=pObj.data[i]['dealer__Price__c'];
	           			pObj.data[i]['dealer__PLName']=getPLName();
	           			pObj.data[i]['dealer__PL']=getPL();
	           		}
					createPartRowDiv(pObj.data[i]['Id'], pObj.data[i]);
				}
				totalDollars();
			} else {
				
				dealer.PartsInvoice_EXT.setPLonInvoice(invoiceid+'-'+getPL(), function(result, event) {	
					if(event.status) {
							j$("#partLineTable").empty();
							loadPartsGrid();
					   } else if (event.type === 'exception') {    
          
				       	logError(event.message);
				       } else {
				        
				       	logError(event.message);
				       }
				    }, {escape:true});
			}
       } else if (event.type === 'exception') {    
          
       	logError(event.message);
       } else {
        
       	logError(event.message);
       }
   }, {escape:true});    
}

function commandInputExec(k, id) {
	cLog('Command input execution');
	cLog(k);
	j$('#CommandInput-'+id).val("");
	// Delete Part Line
	if(k==100 || k==68) {
		confirmDeletePart(j$('#PartNumberRow-'+id).text(), id);
	}
	
	// Change Price
	if(k==80 || k==112) {
		showPriceDialog(id) 
	}
	
	// Change QTY
	if(k==81 || k==113) {
		if(invoiceId!='') {
			showOrderDialog(id);
		} else {
		var i = getObjectIndex(id);
		cLog('Calling Order Dialog with '+id);
		cLog(pObj);
		showOrderDialog(id,
						pObj.data[i].dealer__PartName,
						pObj.data[i].dealer__Part_No__c, 
						pObj.data[i].dealer__Description__c, 
						pObj.data[i].dealer__Quantity_Sold__c, 
						pObj.data[i].dealer__Cost__c, 
						pObj.data[i].dealer__List__c, 
						pObj.data[i].dealer__On_Hand__c,
						pObj.data[i].sold_OP,
						pObj.data[i].sold_Order,
						pObj.data[i].sold_NP,
						pObj.data[i].dealer__Sold_Via__c);
		}
	}
	
	// Mark as LS
	if(k==76 || k==108) {
		var i = getObjectIndex(id);
		pObj.data[i].dealer__Quantity_Sold__c=0;
		pObj.data[i].dealer__Net__c=0;
		pObj.data[i].dealer__Extended_Total=0;
		pObj.data[i].OrderType='Lost Sale';
		buildPartList();
	}

	j$('#CommandInput-'+id).val("");
}

function displayDialog(id){
    j$("#zqDialog").dialog({ 
        modal: true,
        width: 800,
        height: 450,
        resizable: false,
        draggable: false,
        buttons: [
            {
                text: "Complete / Order",
                click: function() {
                	cLog('Order details updated for ID:'+id);
                    setOrderDetails(id);
                    j$(this).dialog("close");
                }   
            }
        ]
    });
}

function showOrderDialog(id, partname, partno, description, qty, cost, list, onhand, op, so, np, soldvia) {
	j$('#zqPartOP').prop('disabled', false);
   	j$('#zqPartNP').prop('disabled', false);
    	
	if(invoiceId != '' && id != '') {
		cLog('Loading Invoice Line from database '+id);
		
		showLoader();

		dealer.PartsInvoice_EXT.invoiceLine(id, function(result, event){
			hideLoader();

	        if(event.status) {  
	        	
	        	cLog('Order Dialog '+result);
	        	console.log(result);
			    j$("#zqPartName").val(Encoder.htmlDecode(result.dealer__Part__r.Name));
			    j$("#zqPartNo").val(result.dealer__Part_Number__c);
			    j$("#zqPartDesc").val(Encoder.htmlDecode(result.dealer__Part_Description__c));
			    j$("#zqPartQTY").val(result.dealer__Quantity_Sold__c);
			    j$("#zqPartCost").val(result.dealer__Part__r.dealer__Cost__c);
			    j$("#zqPartList").val(result.dealer__Part__r.dealer__List__c);
			    j$("#zqPartOnHand").val(result.dealer__Currently_Available__c);
			    j$("#soldvia").text(Encoder.htmlDecode(result.dealer__Sold_Via__c));

			    // Save the QTY Sold to a hidden var for future retrieval
			    j$('#PartQTY-'+id).val(result.dealer__Quantity_Sold__c);
			    
			    if(result.dealer__Drop_Ship__c==true) {
			    	j$("#zqDropShip").attr('checked', true);
			    }
			    
			    j$("#zqPartSP").val(result.dealer__Quantity_Ordered__c);
			    
			    if(result.dealer__Sold_Via__c == 'Outside Purchase') {
			    	j$("#zqPartOP").val(result.dealer__Quantity_Sold__c);
			    }
			    if(result.dealer__Sold_Via__c == 'Negative On-Hand') {
			    	j$("#zqPartNP").val(result.dealer__Quantity_Sold__c);
			    }
			    
			    displayDialog(id);
	        } else if (event.type === 'exception') {    
	            logError(event.message);
	            return false;
	        } else {
	           logError(event.message);
	           return false;
	        }
	    }, {escape:true}); 
    
    } else {
	    cLog('Loading Invoice Line from Memory (id:'+id+')');
	    if(id=='') {
	 	j$("#zqPartName").val(partname);
	    j$("#zqPartNo").val(partno);
	    j$("#zqPartDesc").val(Encoder.htmlDecode(description));
	    j$("#zqPartQTY").val(qty);
	    j$("#zqPartCost").val(cost);
	    j$("#zqPartList").val(list);
	    j$("#zqPartOnHand").val(onhand);
	    j$("#soldvia").text(Encoder.htmlDecode(soldvia));
	    j$("#zqPartOP").val(op);
	    j$("#zqPartSP").val(so);
	    j$("#zqPartNP").val(np);
	    } else {
	    var objIndexId = getObjectIndex(id); 
	    j$("#zqPartName").val(pObj.data[objIndexId].dealer__PartName);
	    j$("#zqPartNo").val(pObj.data[objIndexId].dealer__Part_No__c);
	    j$("#zqPartDesc").val(Encoder.htmlDecode(pObj.data[objIndexId].dealer__Part_Description__c));
	    j$("#zqPartQTY").val(pObj.data[objIndexId].dealer__Quantity_Sold__c);
	    j$("#zqPartCost").val(pObj.data[objIndexId].dealer__Cost__c);
	    j$("#zqPartList").val(pObj.data[objIndexId].dealer__List__c);
	    j$("#zqPartOnHand").val(pObj.data[objIndexId].dealer__On_Hand__c);
	    j$("#soldvia").text(Encoder.htmlDecode(pObj.data[objIndexId].OrderType));
	    j$("#zqPartOP").val(pObj.data[objIndexId].sold_OP);
	    j$("#zqPartSP").val(pObj.data[objIndexId].sold_Order);
	    j$("#zqPartNP").val(pObj.data[objIndexId].sold_NP);
	    }

	    displayDialog(id);
	}

    // Append Stock to the Order Dialog
    dealer.PartsInvoice_EXT.matchedInventory(partname, function(result, event){

    	console.log(partno);
    	console.log(partname);

    	if(event.status) {
    		console.log(result);
 			for (var item in result) { 		
					// j$('#onHandTable').append('<tr><td style="tblB">'+result[item].dealer__Location__r.Name+'</td><td style="tblB">'+result[item].dealer__On_Hand__c+'</td></tr>');
			}
    	}
    });
}

function showShippingAddressDialog() {
	j$("#ShippingAddressOverride").dialog({
        modal: true,
        width: 400,
        height: 300,
        resizable: false,
        draggable: false,
        buttons: [
            {
                text: "Update",
                click: function() {              
                	addrObj = new Object();
                	addrObj.Id = invoiceId;
                	addrObj.Street 	= j$('#shippingStreet').val();
                	addrObj.City 	= j$('#shippingCity').val();
                	addrObj.State 	= j$('#shippingState').val();
                	addrObj.Zip 	= j$('#shippingZip').val();
                	addrObj.Country = j$('#shippingCountry').val();
                	
                	cLog(JSON.stringify(addrObj));
                	
                    dealer.PartsInvoice_EXT.updateShipToAddress(JSON.stringify(addrObj), function(result, event){
                    	cLog(JSON.stringify(addrObj));
        				if(event.status) { 
        					var newAddress = addrObj.Street+' <br>'+addrObj.City+' ,'+addrObj.State+' '+addrObj.Zip+' <br>'+addrObj.Country;
        					j$(esc('partInvoice:partsInvoiceForm:headBlock:headSection:customShipping:customShipToAddress')).html(newAddress);
        				   } else if (event.type == 'excetion') {
	                		logError(event.message);
				           } else {
				            logError(event.message);
				           }
				    }, { escape:true});
				    
                    j$(this).dialog("close");
                }
            }
        ]
    });	
}

function showPriceDialog(nid) {

	if(pageMode == "create") {
		// Get the ID of the part row to change price of
		var oIndex = getObjectIndex(nid);
		if(oIndex===undefined) { 
			cLog('Search NID not found');
			return false;
		}
		
	    j$("#priceOverRidePartDescription").text(pObj.data[oIndex].dealer__Part_No__c);
	    j$("#priceOverRidePartNumber").text(Encoder.htmlDecode(pObj.data[oIndex].dealer__Description__c));
	    j$("#adjustedprice").val(pObj.data[oIndex].dealer__Price__c);
	    j$("#netpricepercent").val("100");
	    j$("#partcost").text(pObj.data[oIndex].dealer__Cost__c);
	    j$("#partlist").text(pObj.data[oIndex].dealer__List__c);
	    j$("#currentGrossMargin").text(calcGrossMargin(pObj.data[oIndex].dealer__Cost__c, pObj.data[oIndex].dealer__List__c)).formatNumber({format:"#,###.0", local:"us"});
	    j$("#currentMarkup").text(calcGrossPercent(pObj.data[oIndex].dealer__Cost__c, pObj.data[oIndex].dealer__List__c)).formatNumber({format:"#,###.00", local:"us"});
	    j$("#partjobber").text(pObj.data[oIndex].dealer__Jobber__c);
	    j$("#baseList").val(pObj.data[oIndex].dealer__List__c);
	    j$("#baseCost").val(pObj.data[oIndex].dealer__Cost__c);
	    
	    
	    j$("#PriceOverRide").dialog({
	        modal: true,
	        width: 400,
	        height: 450,
	        resizable: false,
	        draggable: false,
	        buttons: [
	            {
	                text: "Update",
	                click: function() {
	                    j$("#net-"+nid).val(j$("#adjustedprice").val());
	                    setNetPrice(nid, j$("#adjustedprice").val());
	      
	                    var lineTotal = (j$("#net-"+nid).val() * j$("#qty-"+nid).val());
	                    j$("#total-"+nid).val(lineTotal.toFixed(2));                
	                    
	                    j$(this).dialog("close");
	                }
	            }
	        ]
	    });
    
    } else {
		showLoader();
	  	var qos = 0;
		var uprice = 0;
		 // Get Part Line Detail
	    dealer.PartsInvoice_EXT.invoiceLine(nid, function(result, event){
			hideLoader();

	        if(event.status) {  
	        	cLog(result);
			    j$("#priceOverRidePartDescription").text(result.dealer__Part_Number__c);
			    j$("#priceOverRidePartNumber").text(Encoder.htmlDecode(result.dealer__Part_Description__c));
			    j$("#adjustedprice").val(result.dealer__Price__c);
			    j$("#netpricepercent").val("100");
			    j$("#partcost").text(result.dealer__Part__r.dealer__Cost__c);
			    j$("#partlist").text(result.dealer__Part__r.dealer__List__c);
			    j$("#baseList").val(result.dealer__Part__r.dealer__List__c);
			    j$("#baseCost").val(result.dealer__Part__r.dealer__Cost__c);
			    qos = result.dealer__Quantity_Sold__c;
	        } else if (event.type === 'exception') {    
	            logError(event.message);
	            return false;
	        } else {
	           logError(event.message);
	           return false;
	        }

		    j$("#PriceOverRide").dialog({
		        modal: true,
		        width: 400,
		        height:300,
		        resizable: false,
		        draggable: false,
		        buttons: [
		            {
		                text: "Update",
		                click: function() {
		                	j$("CommandInput-"+nid).val("");
		                	j$(esc(partName_element)).focus();
		                    uprice = j$("#adjustedprice").val();
		                    if(uprice > 0 && qos > 0) {
		                    	j$("#PartNet-"+nid).text(uprice).formatNumber({format:"#,###.00", local:"us"});
		                    	j$("#PartExtTotal-"+nid).text(uprice * qos).formatNumber({format:"#,###.00", local:"us"});
		                    }
		                    setNetPrice(nid, j$("#adjustedprice").val());
							updatePricing(invoiceId);
		                    j$(this).dialog("close");
		                }
		            }
		        ]
		    });
	        
	    }, {escape:true}); 
	  
    }
}

function calcPriceDialog_Percent() {
	   cLog(j$("#baseSelect option:selected").val());
       var baseOn = j$("#baseList").val(); 
       if(j$("#baseSelect option:selected").val() == 'list') {
        baseOn = j$("#baseList").val();
       }
      
       if(j$("#baseSelect option:selected").val() == 'cost') {
        baseOn = j$("#baseCost").val();
       }
       
       if(j$("#baseSelect option:selected").val() == 'margin') {
         
         j$("#adjustedprice").val(calcGrossMarginbyPercent(j$('#baseCost').val(), j$("#netpricepercent").val())).formatNumber({format:"#,###.00", local:"us"});
         
       } else {
       
       cLog(baseOn);
       var adjustedPrice = (j$("#netpricepercent").val() / 100) * baseOn;
       cLog('Adjusted Price '+adjustedPrice);
       adjustedPrice = parseFloat(adjustedPrice);
       cLog('Adjusted Price Parsed '+adjustedPrice);
       var fmtAdjustedPrice = adjustedPrice.toFixed(2);
       cLog('Adjusted Price Formatted '+fmtAdjustedPrice);
       j$("#adjustedprice").val(fmtAdjustedPrice);
       
       }
       
       j$("#currentMarkup").text(calcGrossPercent(j$('#baseCost').val() , adjustedPrice)).formatNumber({format:"#,###.00", local:"us"});
       j$("#currentGrossMargin").text(calcGrossMargin(j$('#baseCost').val(),adjustedPrice)).formatNumber({format:"#,###.00", local:"us"});
}

function calcPriceDialog_Dollar() {
	   
	   var adjustedPrice	  = j$("#adjustedprice").val();
	   cLog(j$("#baseSelect option:selected").val());
       var baseOn = j$("#baseList").val(); 
       if(j$("#baseSelect option:selected").val() == 'list') {
        baseOn = j$("#baseList").val();
       }
       
       if(j$("#baseSelect option:selected").val() == 'cost') {
        baseOn = j$("#baseCost").val();
       }
       
       if(j$("#baseSelect option:selected").val() == 'margin') {
         
         j$("#netpricepercent").val(calcGrossMargin(j$('#baseCost').val(), j$("#adjustedprice").val())).formatNumber({format:"#,###.00", local:"us"});

       } else {
       
       
       var adjustedPercent    = ((j$("#adjustedprice").val() / baseOn) * 100);
       cLog('Adjusted Percent '+adjustedPercent);
       var fmtAdjustedPercent = adjustedPercent.toFixed(0);
       cLog('Format Adjusted '+fmtAdjustedPercent);
       j$("#netpricepercent").val(fmtAdjustedPercent); 
       
       }
       
       j$("#currentMarkup").text(calcGrossPercent(j$('#baseCost').val() , adjustedPrice)).formatNumber({format:"#,###.00", local:"us"});
       j$("#currentGrossMargin").text(calcGrossMargin(j$('#baseCost').val(),adjustedPrice)).formatNumber({format:"#,###.00", local:"us"});
}

function calcGrossMargin(cost, price) {

	var markup = (calcGrossPercent(cost, price) / 100);
	var gm = (markup / (1 + markup)) * 100;
	
	return gm;
}

function calcGrossPercent(cost, price) {
	return ((price - cost) / price) * 100;
}

function calcGrossMarginbyPercent(cost, percent) {
	return cost / (1 - (percent / 100));
}

function setOrderDetails(rid) {

		if(rid != '' && invoiceId == '') {
			// Delete line to be modified.
			pObj.data.splice(getObjectIndex(rid), 1);
	        j$('#partDiv-'+rid).remove();
	        totalDollars();
		} 
		
		// If Invoice created, update parts on invoice.
		if(invoiceId!='' && rid != '') {
			cLog('Updating existing invoice line on '+invoiceId+' '+rid);
				var qAdjust = (j$('#zqPartQTY').val() / 1);
				var qSoldBefore = (j$('#PartQTY-'+rid).val()/1);
				var qSold = (qAdjust - qSoldBefore);
				var qOrd  = (j$('#zqPartSP').val() / 1);
				var qNP   = j$('#zqPartNP').val();
				var qOP   = j$('#zqPartOP').val();

				// Alert for QTY Reduction until dialog allows for source reduction
				/*
				if(qAdjust < qSoldBefore) {
					alert('You can not reduce the QTY.  Please Remove the Parts and Re-Add to this Invoice');
					return false;
				}
				*/

				cLog('Adjust '+qAdjust);
				cLog('Before '+qSoldBefore);
				cLog('New QTY Sold '+qSold);
				
				if(j$('#zqDropShip').is(":checked")) {
					zq_DropShip = true;
				}
    
				var via   = '';
				cLog('qSold:'+qSold+', qOrd:'+qOrd+', qNP:'+qNP+', qOP:'+qOP);

				// Need to set qSold as a diff between the origional amount and the new amount

				if(qOrd > 0) { via = 'Order'; }
				if(qNP != '' && qNP != '0' ) { via = 'Negative On-Hand'; }
				if(qOP != '' && qOP != '0') { via = 'Outside Purchase'; }
				if(via=='') { via = 'Quantity Change'; }
				cLog('Net Price: '+j$('#PartNet-'+rid).text());
				var netTotal = Number(j$('#PartNet-'+rid).text().replace(/[^0-9\.]+/g,""));
				var extTotal = qSold * netTotal;
				dealer.PartsInvoice_EXT.updateLineQty( rid+"-"+qSold+"-"+qOrd+"-"+via+"-"+zq_DropShip.valueOf(), function(result, event) {
	            if(event.status) {

	            	//j$('#PartSoldDesc-'+rid).text(qSold+' / '+via);
	            	//j$('#PartExtTotal-'+rid).text(extTotal).formatNumber({format:"#,###.00", local:"us"});

					j$('#PartSoldDesc-'+rid).html(result.dealer__Quantity_Sold__c+' / '+result.dealer__Currently_Available__c+' In Stock');
					j$('#PartExtTotal-'+rid).html(result.dealer__Extended_Price__c);

					cLog(j$('#PartExtTotal-'+rid));
					cLog('Updating the PartQTY Sold '+result.dealer__Quantity_Sold__c);

					j$('#PartQTY-'+rid).val(result.dealer__Quantity_Sold__c);						

					cLog('DS on order dialog update:'+zq_DropShip);
					if(zq_DropShip==true) {
						j$('#PartDropShip-'+rid).empty();
						j$('<input type="checkbox">').attr('checked', 'checked').attr('disabled', 'disabled').appendTo('#PartDropShip-'+rid).addClass("dataCell");
					} else {
						j$('#PartDropShip-'+rid).empty();
						j$('<input type="checkbox">').attr('disabled', 'disabled').appendTo('#PartDropShip-'+rid).addClass("dataCell");					
					}
					            	
	            	if(j$('#orderRefreshNotice')) {
	            		j$('#orderRefreshNotice').empty();
	            	}

	            	if(j$('#orderRefreshNotice').html()=='') {
	            		j$('<span>', { id: 'orderRefreshNotice', text: '  New order lines may have been added, refresh invoice to view.'}).css('color', '#600000').appendTo('#partInvoice\\:OrderRelatedList_title');                    
	                }

	                updatePricing(invoiceId);
	            } else if (event.type == 'excetion') {
	                logError(event.message);
	            } else {
	                logError(event.message);
	            }
	        }, { escape:true});
	        
		} else {
		
        zq_Override = true;
        zq_PartNo   = j$("#zqPartNo").val();
        zq_Desc     = j$("#zqPartDesc").val();
		//Drop Ship
		var DS	  = false;
	    if(j$('#zqDropShip').is(":checked")) {
	    	cLog('Drop Ship Activated');
			zq_DropShip =	true;
		}
				
        setZQ_Method();
        getPartJS();
        
        }   
}


function buildPartList() {
	j$('#partLineTable').empty();
	for(var i=0; i < pObj.data.length; i+=1) {
		createPartRowDiv(pObj.data[i]['Id'], pObj.data[i]);
	}
	totalDollars();
}

function resetZQ() {
    saleOtype   =   "In Stock";
    zq_Override =   false;
    zq_PartNo   =   "";
    zq_Desc     =   "";
    zq_QTY      =   0;  
    zqOrderType	=	"";
    zq_DropShip  =   false;
    
   	sold_NP			=	0;
	sold_OP			=	0;
	sold_Order  	= 	0;
	sold_In_Stock	= 	0;
    
    j$("#zqPartName").val('');
    j$("#zqPartNo").val('');
    j$("#zqPartDesc").val('');
    j$("#zqPartOP").val(0);
    j$("#zqPartSP").val(0);
    j$("#zqPartNP").val(0);
    j$("#zqPartQTY").val(0);
    j$("#zqPartCost").val(0);
    j$("#zqPartList").val(0); 
    j$("#zqPartOnHand").val(0);
    j$("#zqDropShip").attr('checked', false);
}


function setNetPrice(nid, price) {
	if(pageMode == "create") {
	    j$.each(pObj.data, function(index, v) {
	        if(v.Id == nid) {
	            v.dealer__Net__c = parseFloat(price);
	            v.dealer__Extended_Total = v.dealer__Net__c * v.dealer__Quantity_Sold__c;
	        }
	    });
	    
		buildPartList();
	} else {
	    dealer.PartsInvoice_EXT.setLinePrice(nid+"-"+price, function(result, event) {
	        if(event.status) {
	            // 
	        } else if (event.type === 'exception') {    
	            logError(event.message);
	        } else {
	           logError(event.message);
	        }
	    }, {escape:true}); 
	}
}

function totalDollars() {
    var total = 0;
    j$.each(pObj.data, function(index, v) {
        total += v.dealer__Extended_Total;
    });
    
    j$("#totalsum").text(parseFloat(total).toFixed(2)); 
}

function loadPartsGrid() {
	cLog('Loading Parts Grid');
    j$("#partLineTable").empty();
    dealer.PartsInvoice_EXT.loadPartsInvoiceLines( invoiceId, function(result, event){
    if (event.status) {  
        // Prepare result for table display
        for (var item in result) {
            if(!isNaN(item)) {
            // Bogus data check
            if(result[item].dealer__Bin__c == undefined) {	result[item].dealer__Bin__c = '';	}
            if(result[item].dealer__On_Hand__c == undefined) {	result[item].dealer__On_Hand__c = '';	}
            if(result[item].dealer__Source__c == undefined) {	result[item].dealer__Source__c = '';	}
            if(result[item].dealer__Sold_Via__c == undefined) {	result[item].dealer__Sold_Via__c = '';	}
			 
			 createPartRowDiv(result[item].Id, result[item]);
			 updatePricing(invoiceId);
			 
           }            
        }
    } else if (event.type === 'exception') {    
           logError(event.message);
        } else {
           logError(event.message);
        }
    }, {escape:true});
} 

function addKitParts(kitId) {
	cLog('Adding individual items to kit ');
    dealer.PartsInvoice_EXT.getPartsKitItems( kitId, function(result, event){
    if (event.status) {  
        // Prepare result for table display
        kit_Override=true;
        for (var item in result) {
            if(!isNaN(item)) {
            // Bogus data check
            zq_Override=true;
            cLog('Setting ZQ Override to True '+zq_Override);
			placePartOnInvoice(result[item].dealer__Part_Name__c, result[item].dealer__Quantity__c, true); 
           }  
        kit_Override=false;             
        }
    } else if (event.type === 'exception') {    
           logError(event.message);
        } else {
           logError(event.message);
        }
    }, {escape:true});	
} 

function getJobLineId() {
	if(typeof selectedLineId === 'undefined') {
		return false;
	} else {
		if(selectedLineId!='') {
			return selectedLineId;
		} else {
			return '';
		}
	}
}

function getServiceRO() {
	if(typeof serviceRepairOrder == 'undefined') {
		return '';
	} else {
		if(serviceRepairOrder!='') {
			return serviceRepairOrder;
		} else {
			return '';
		}
	}
}

function getPartJS() {
	cLog('getPart : '+pageMode);
	var partNameJS = "";
    var partQTYOveride = "";
    
    // Determin if part name element exists.
    if(j$(esc(partName_element))==null) {
        logError('Element not found');
        return false;
    }
    
    // Zero Quantity on Hand OverRide?
    if(zq_Override == false) {
        cLog('ZQ Override');
        partNameJS = 	 j$(esc(partName_element)).val();
        partQTYOveride = j$(esc(partQuantity_element)).val();
        
        if(!partQTYOveride) { partQTYOveride= 1; }
        // Sanity check
        if(!partNameJS) { return false; }           
        
    } else {
        
        partQTYOveride  =   zq_QTY;
        partNameJS      =   zq_PartNo;
        partNameJS		=	j$(esc(partName_element)).val();
        if(partNameJS=='' || partNameJS == undefined) {
        	partNameJS	=	j$("#zqPartName").val();
        } 
        
        console.log(partNameJS);

        if(partNameJS=='' || partNameJS == undefined) {
        	logError('Error: no part name for query');
        	return false;
        }
    } 
	
    // User dealer__Part_No__c for lookup - DR 10-28-2015
    if(typeof recordResults != 'undefined' && typeof recordResults.dealer__Part_No__c != 'undefined' ) {
    	partNameJS = recordResults.dealer__Part_No__c;
    }

    console.log('getPartJS');
    console.log(partNameJS);
    console.log(partQTYOveride);
	
	placePartOnInvoice(partNameJS, partQTYOveride, false);
	
}

function placePartOnInvoice_UpdateQTY(pLid, qty, available) {
	showLoader();
	cLog('placePartOnInvoice_UpdateQTY called with('+qty+')');
	cLog(pLid+'-'+(qty)+'-0-Quantity Change-false');
	dealer.PartsInvoice_EXT.updateLineQty(pLid+'-'+qty+'-0-Quantity Change-false', function(result, event){
		if(event.status) {
			// Reflect Changes on Invoice
			if(result==null) {
				alert('Error adding part to invoice line');
			}
			j$('#PartSoldDesc-'+pLid).html(result.dealer__Quantity_Sold__c+' / '+result.dealer__Currently_Available__c+' In Stock');
			j$('#PartExtTotal-'+pLid).html(result.dealer__Extended_Price__c);
			clearInputs();	
			updatePricing(result.dealer__Parts_Invoice__c);

		} else {
			alert('Error: Unable to update the QTY of the parts sold');
		}
		hideLoader();
	});
}

function placePartOnInvoice(partName, qty, dialogOverride) {
    cLog('placePartonInvoice called with PartName'+partName+' QTY:'+qty+' OverRide:'+dialogOverride+' ');
    // Retrieve part from database
    dealer.PartsInvoice_EXT.getInventory( partName, function(result, event){
        if (event.status) {  
            // Sanity check, both null part and already on invoice
            if(result == null) { alert('Error: Part Not Found'); return false; }
            cLog('Adding '+result.Id+' to invoice: '+j$("#PartInventoryId-"+result.Id).length);
            cLog(result);
            if(j$("#PartInventoryId-"+result.Id).length != 0) {
                // logError(result.dealer__Part_No__c+" already on this invoice");
                // Get closest item and update QTY - Winter 15 - JK
                cLog('Part exists on invoice, update QTY with item');
                var closestTD = j$("#PartInventoryId-"+result.Id).closest("td").attr("id");
                var partLineParent = closestTD.split("-");
                if(typeof partLineParent[1] == undefined) {
                	logError("Unable to update part QTY of "+result.Name);
                } else {
                	placePartOnInvoice_UpdateQTY(partLineParent[1], qty, result.dealer__On_Hand__c);
                	clearInputs();
                }
                
                clearInputs();
                return false;
            } else {
            	cLog("Part not on invoice yet, adding to the invoice");
            }   
            result.dealer__Core__c == undefined ? result.dealer__Core__c = 0 : false;
            result.dealer__Net__c == undefined ? result.dealer__Net__c = result.dealer__List__c : false;
			result.dealer__MFG__c == undefined ? result.dealer__MFG__c = 'OT' : false;
			result.dealer__Bin__c == undefined ? result.dealer__Bin__c = '' : false;
			result.dealer__Source__c == undefined ? result.dealer__Source__c = '' : false;
			result.dealer__Drop_Ship__c == undefined ? result.dealer__Drop_Ship__c = 'false' : false;
    
			var sold_In_Stock 	= 	result.dealer__On_Hand__c;
			var totalSold		=	(parseInt(sold_In_Stock) + parseInt(sold_NP) + parseInt(sold_OP) + parseInt(sold_Order)); 
			cLog('Kit '+result.dealer__Kit__c+' ZQ Override '+zq_Override+' Kit '+kit_Override);
			if(dialogOverride==true || result.dealer__MFG__c == 'KIT') { 
				zq_Override = true;
				if(result.dealer__On_Hand__c < qty) {
					zqOrderType = 'Special Order';
				} else {
					zqOrderType = 'In Stock';
				}
				saleOtype   = 'Special Order';
				totalSold   =  qty;
				sold_Order  =  qty - result.dealer__On_Hand__c; 
			} else {
				totalSold 	= qty;
			}
			// Determin if there are zero on hand and require an order dialog
            if(result.dealer__On_Hand__c < qty && zq_Override == false && result.dealer__Kit__c == undefined && dialogOverride!=true) {
            	cLog('Show order dialog, part not on hand');

                showOrderDialog('',
                				partName,
                				result.dealer__Part_No__c, 
                				result.dealer__Description__c, 
                				qty, 
                				result.dealer__Cost__c, 
                				result.dealer__List__c, 
                				result.dealer__On_Hand__c,
                				'',
                				'',
                				'');
                return false;
            }
            
            var salePrice 		=	0;
            var extendedPrice 	=	0;
            var netPrice  		=	0;

            // If Active PL is Set
            if(activePriceLevelId !== '' && activePriceLevelMethod !== '' && activePriceLevelPercent !== '') {
            	cLog('PL Set on page, set price to appropriate level');
       			if(activePriceLevelMethod == 'List') {
       				cLog('PL Method: List ');
	             	salePrice	=	result.dealer__List__c * ((100+activePriceLevelPercent) /100);
	            	extendedPrice=	(salePrice * totalSold);
	            	netPrice	=	salePrice;     
            	} else if(activePriceLevelMethod == 'Cost') {
            		cLog('PL Method: Cost ');
	             	salePrice	=	result.dealer__Cost__c * ((100+activePriceLevelPercent) /100);
	            	extendedPrice=	(salePrice * totalSold);
	            	netPrice	=	salePrice;               		
            	} else {
	            	salePrice	=	result.dealer__List__c;
	            	extendedPrice=	(result.dealer__List__c * totalSold);
	            	netPrice	=	result.dealer__Net__c;
            	}			
       			
            } else {
            	cLog('No PL Set, using Default');
            	salePrice	=	result.dealer__List__c;
            	extendedPrice=	(result.dealer__List__c * totalSold);
            	netPrice	=	result.dealer__Net__c;
            }
            
            // Check Drop Ship
            if(zq_DropShip == true || zq_DropShip == 'true') {
            	result.dealer__Drop_Ship__c = true;
            }
                
	        pObj.Id = result.Id;
	        pObj.data.push({
	                        "Id":result.Id,
	                        "InvoiceName" : invoiceName,
							"counterman" : countermanId,
							"InvoiceId" : invoiceId,	                        
	                        "dealer__PartName":partName,
	                        "dealer__Part_No__c":result.Name, 
	                        "dealer__Part_Number__c":result.Name,
	                        "dealer__Description__c":result.dealer__Description__c,
	                        "dealer__Part_Description__c":result.dealer__Description__c,
	                        "dealer__List__c":result.dealer__List__c,
	                        "dealer__Price__c":salePrice,
	                        "dealer__Part_No__c":result.dealer__Part_No__c,
	                        "dealer__Quantity_Sold__c":parseInt(totalSold),
	                        "dealer__On_Hand__c":result.dealer__On_Hand__c,
	                        "dealer__Bin__c":result.dealer__Bin__c,
	                        "dealer__Source__c":result.dealer__Source__c,
	                        "dealer__Cost__c":result.dealer__Cost__c,
	                        "dealer__Core__c":result.dealer__Core__c,
	                        "dealer__Net__c":netPrice,
	                        "dealer__Extended_Total":extendedPrice,
	                        "dealer__Sold_Via__c":saleOtype,
	                        "dealer__MFG__c":result.dealer__MFG__c,
	                        "dealer__Drop_Ship__c":result.dealer__Drop_Ship__c,
	                        "sold_In_Stock":parseInt(sold_In_Stock),
	                        "sold_Order":parseInt(sold_Order),
	                        "OrderType":zqOrderType,
	                        "sold_OP":parseInt(sold_OP),
	                        "sold_NP":parseInt(sold_NP),
	                        "dealer__PL":getPL(),
	                        "dealer__PLName":getPLName(),
	                        "dealer__Job_Line__c":getJobLineId(),
	                        "dealer__Service_Repair_Order__c":getServiceRO()
	                     	});
	       
	       // objectify item to be added to create mode page
	       var pObjString = JSON.stringify(pObj);
	       var objID	   = (pObj.data.length - 1);
	                          
		   // instantiate XML for remoting call
		   var actionString = '<invoice>'+json2xml(pObj.data[objID], "")+'</invoice>'; 	     

		   if(pageMode == "create") {
		        resetZQ();
            	createPartRowDiv(result.Id, pObj.data[objID]);
            	totalDollars();
            	clearInputs();
           }
            
           if(pageMode == "edit") {
           		cLog('Adding part line '+actionString);
	            dealer.PartsInvoice_EXT.InvoiceAddPartLine( actionString, function(result, event){
	                if(event.status) {
						resetZQ();
						cLog('Adding Part to Invoice');
						result.dealer__PL=getPL();
						result.dealer__PLName=getPLName();
						createPartRowDiv(result.Id, result);
	                    updatePricing(invoiceId);


	                    if(j$('#orderLinesAddedNotice').html()=='') {
	                    	j$('<span>', { id: 'orderLinesAddedNotice', text: '  New order lines may have been added, refresh invoice to view.'}).css('color', '#600000').appendTo('#partInvoice\\:OrderRelatedList_title');                    
	                    }

	                } else if (event.type === 'exception') {    
	                 	logError(event.message);
	                } else {
	                   logError(event.message);
	                }
	            }, {escape:true});            	
           		clearInputs();
           } 
           
           // If Kit Parts exist add kits to invoice
           if(result.dealer__Kit__c != undefined) {
           		addKitParts(result.dealer__Kit__c);
           }
		           
          } else if (event.type === 'exception') {    
        	logError(event.message);
          } else {
		   logError(event.message);	        
          }
    }, {escape:true});
}

function createPartRowDiv(id, obj) {
		cLog('Creating row display');
		cLog(obj);
		// Fix missing BIN / Source
		if(obj.dealer__Bin__c == undefined) { obj.dealer__Bin__c=''; }
		if(obj.dealer__Source__c == undefined) { obj.dealer__Source__c=''; }
		
		// Normalize Fields
		if(obj.dealer__Description__c == undefined) { obj.dealer__Description__c = obj.dealer__Part_Description__c; }
		if(obj.dealer__Part_No__c == undefined) { obj.dealer__Part_No__c = obj.dealer__Part_Number__c; }
		if(obj.dealer__Net__c == undefined) { obj.dealer__Net__c = obj.dealer__Price__c; }
		if(obj.dealer__Extended_Total == undefined) { obj.dealer__Extended_Total = obj.dealer__Extended_Price__c; }
		if(obj.dealer__Currently_Available__c == undefined || obj.dealer__Currently_Available__c == '') { obj.dealer__Currently_Available__c = 0; }
		if(obj.dealer__On_Hand__c == undefined) { obj.dealer__On_Hand__c = obj.dealer__Currently_Available__c; }
		if(obj.OrderType == undefined) { obj.OrderType = obj.dealer__Sold_Via__c; }
		if(obj.dealer__PLName == undefined || obj.dealer__PLName == '') { obj.dealer__PLName = obj.dealer__Price_Level__c; }
		if(obj.dealer__Service_Job_Line_Number__c == undefined) { obj.dealer__Service_Job_Line_Number__c = ''; }
		if(obj.dealer__Job_Line__c == undefined) { obj.dealer__Job_Line__c = ''; }
		
		// Remove existing element
		j$('#partDiv-'+id).empty();
		
		// Build Element for row
		j$('<tr>', {
				id: 'partDiv-'+id,
				jid: obj.dealer__Job_Line__c
			}).appendTo('#partList').addClass("dataRow");
		

		//	Action Cell
		j$('<td>', {
				text: ''
			})
			.attr('id', 'CommandDiv-'+id)
			.appendTo('#partDiv-'+id).addClass("actionColumn");	
		
		
		
		// If Service Repair Sales add Job# Data
		if(j$('#jobLineHeader').length>0) {
			j$('<td>', { text: obj.dealer__Service_Job_Line_Number__c}).attr('id', 'JobLineNumber-'+id).css('text-align', 'center').appendTo('#partDiv-'+id);
		}
	
		// Action Menu
		if(invoiceDateTime=='') {
			j$('<a>', { id:'actionMenu-'+id, href:'#', text:'Action', 'class':'bt btleft btmiddle btright'}).append(
				j$('<span>', { html:'&#9660;' })
			).click(function(event) { event.preventDefault(); 

				// Need to unbind click events on the menu options to prevent previously bound click events from being fired multiple times.
				j$('#menuActionPricing,#menuActionQuantity,#menuActionRemove').unbind('click');

				if(j$('#actionMenu-'+id).hasClass('bt')) {
					j$('#actionMenu-'+id).removeClass('bt');
					j$('#actionMenu-'+id).addClass("clicked");
					var currentOffset = j$('#actionMenu-'+id).offset();
					j$('#menuActions').css('position', 'absolute').css('top', (currentOffset.top - 90)).css('z-index', '4000');
					j$('#menuActions').show(); 
					j$('#menuActionPricing').click(function(event) { 
						event.preventDefault(); 
						showPriceDialog(id); 
						j$('#menuActions').hide(); 
						j$('#actionMenu-'+id).addClass('bt'); 
						j$('#actionMenu-'+id).removeClass("clicked");
					});
					j$('#menuActionQuantity').click( function(event) { 
						event.preventDefault(); 
						console.log('*** THE ID ***');
						console.log(id);
						showOrderDialog(id); 
						j$('#menuActions').hide(); 
						j$('#actionMenu-'+id).addClass('bt'); 
						j$('#actionMenu-'+id).removeClass("clicked");						
					});
					j$('#menuActionRemove').click(function(event) { 
						event.preventDefault(); 
						confirmDeletePart(j$('#PartNumberRow-'+id).text(), id);
						j$('#menuActions').hide(); 
						j$('#actionMenu-'+id).addClass('bt'); 
						j$('#actionMenu-'+id).removeClass("clicked"); 
					});
				} else {
					j$('#menuActions').hide();
					j$('#actionMenu-'+id).addClass('bt'); 
					j$('#actionMenu-'+id).removeClass("clicked");
					
				}
			}).appendTo('#CommandDiv-'+id);
		}			
		
		// Parts Inventory ID
		j$('<span>', { id: 'PartInventoryId-'+obj.dealer__Part__c }).appendTo('#CommandDiv-'+id);
		
		// Check to see if this is a kit part.
		if(obj.dealer__MFG__c == 'KIT') {
			j$('#CommandInput-'+id).attr('disabled', 'disabled');
		}
		//
		
		// Check to see if invoice date is present
		if(invoiceDateTime!='') {
		  j$('#CommandInput-'+id).attr('disabled', 'disabled');	
		}	
		
		j$('<td>', {
				id: 'PartNumberRow-'+id
				}).appendTo('#partDiv-'+id).addClass("dataCell");	
			j$('<a>', { text: obj.dealer__Part_No__c, href: '/'+obj.Id }).appendTo('#PartNumberRow-'+id);
			j$('<span>', { text: ': '+Encoder.htmlDecode(obj.dealer__Description__c) }).appendTo('#PartNumberRow-'+id);
			
			
		if(obj.Notes) {
			j$.each(obj.Notes, function(index, val) {
				j$('<div>', {id:'PartComments-'+id, text: Encoder.htmlDecode(val.Title) }).appendTo('#PartNumberRow-'+id);	
			});
		}			
		
		j$('<td>', {
				id: 'PartSource-'+id,
				text: obj.dealer__Bin__c + " / " + obj.dealer__Source__c
			}).appendTo('#partDiv-'+id).addClass("dataCell");	
			
		if(obj.dealer__MFG__c == 'KIT') {
			j$('#PartSource-'+id).text('KIT');
		}
		
		cLog('DS:'+obj.dealer__Drop_Ship__c);
		if(obj.dealer__Drop_Ship__c==true) {
		j$('<td>', {id: 'PartDropShip-'+id }).append(
			j$('<input type="checkbox">').attr('checked', 'checked').attr('disabled', 'disabled'))
			.appendTo('#partDiv-'+id).addClass("dataCell");
		} else {
		j$('<td>', {id: 'PartDropShip-'+id }).append(
			j$('<input type="checkbox">').attr('disabled', 'disabled'))
			.appendTo('#partDiv-'+id).addClass("dataCell");		
		}
			
		if(obj.dealer__On_Hand__c=='') {	obj.dealer__On_Hand__c = obj.dealer__Currently_Available__c; }	
		j$('<td>', {
				id: 'PartSoldDesc-'+id,
				text: obj.dealer__Quantity_Sold__c + " / " + obj.dealer__On_Hand__c + " " + obj.OrderType
			}).appendTo('#partDiv-'+id).addClass("dataCell");	
			
		j$('<td>', {
			id: 'PartPL-'+id,
			text: obj.dealer__PLName
		}).appendTo('#partDiv-'+id).addClass("dataCell");		
			
		j$('<td>', {
				id: 'PartList-'+id,
				text: obj.dealer__List__c
			}).
			formatNumber({format:"#,###.00", local:"us"})
			.appendTo('#partDiv-'+id)
			.addClass("dataCell")
			.addClass("CurrencyElement");
				
		j$('<td>', {
				id: 'PartNet-'+id,
				text: obj.dealer__Net__c
			})
			.formatNumber({format:"#,###.00", local:"us"})
			.appendTo('#partDiv-'+id)
			.addClass("dataCell")
			.addClass("CurrencyElement");
				
		j$('<td>', {
				id: 'PartExtTotal-'+id,
				text: obj.dealer__Extended_Total
			})
			.formatNumber({format:"#,###.00", local:"us"})
			.appendTo('#partDiv-'+id)
			.addClass("dataCell")
			.addClass("CurrencyElement");	

		j$('<input>', {
			id: 'PartQTY-'+id,
			type: 'hidden',
			value: obj.dealer__Quantity_Sold__c
		}).appendTo('#partDiv-'+id);	

		cLog('Adding PartQTY Input '+id+' ->'+obj.dealer__Quantity_Sold__c);					
		
		// j$('#partLineTable').height('+=30px');						
		// j$(esc(partId_element)).height('auto');
		
		if(j$(esc(partName_element)).attr('disabled') != 'disabled') {
			j$(esc(partName_element)).focus();
		}	
}

function confirmDeletePart(partno, elementId) {
	showLoader();
    var answer = true;	//confirm("Remove Part# "+partno+"?");
    var indexIDC = 0;
    var indexID  = 0;
    if (answer){
    	cLog('Delete confirmed');
    	if(pageMode == "create") {
    		cLog('Soft delete part from Page');
	        pObj.data.splice(getObjectIndex(elementId), 1);
	        j$('#partDiv-'+elementId).remove();
	        totalDollars(); 
        } else if(pageMode == "edit") {
        	cLog('Hard Delete of Part from Invoice');
		    j$(esc(partName_element)).focus();
		    dealer.PartsInvoice_EXT.DeleteInvoiceLine( elementId, function(result, event){
				hideLoader();

		        if (event.status) {  
		            j$('#partDiv-'+elementId).remove();
		            updatePricing(invoiceId);
		            if(j$('#orderLinesRemovedNotice').html()=='') {
		            	j$('<span>', { id: 'orderLinesRemovedNotice', text: '  Order lines may have been removed, refresh invoice to view.'}).css('color', '#600000').appendTo('#partInvoice\\:OrderRelatedList_title');
		            }                    
	                
		        } else if (event.type === 'exception') {    
		            	logError(event.message);
	            } else {
	               logError(event.message);
	            }

	            hideLoader();
		    }, 
		    {escape:true}); 
        }
        j$('#partLineTable').height('-=30px');	
    } else{
    	cLog('Delete cancelled');
        return false;
    }
}

function updatePricing(invoiceID) {
    dealer.PartsInvoice_EXT.invoicePricing( invoiceID, function(result, event){
        if(event.status) {  
            j$("#totalprice").text(result.dealer__Parts_Price__c).formatNumber({format:"#,###.00", local:"us"});
            j$("#totaltax").text(result.dealer__Total_Tax__c).formatNumber({format:"#,###.00", local:"us"});
            j$("#totalinvoice").text(result.dealer__Total_Invoice__c).formatNumber({format:"#,###.00", local:"us"});
        } else if (event.type === 'exception') {    
            logError(event.message);
        } else {
           logError(event.message);
        }
    }, {escape:true}); 
}

function clearInputs() {
	j$(esc(partName_element)).val("");
    j$(esc(partQuantity_element)).val("");
}

function getObjectIndex(searchId) {
	cLog('Searching for '+searchId);
	if(pObj) {
		for(var i=0; i < pObj.data.length; i+=1) {
			if(pObj.data[i]['Id']==searchId) {
				return i;
			}
		}
	}
}

	
function markLinesBlur() {
	j$('#partList tr').each(function() {
		j$(this).css('background-color', '#EEE');
	});
}

function noenter(ev)
 {
     if (window.event && window.event.keyCode == 13 || ev.which == 13)
     {
         getPartJS();
         return false;
     }
     else
     {
         return true;
     }
 }

function setQTY(evt, rid) {
	/*
		Deprecated function, not in use.
		12/10/2012
	*/
     var charCode = (evt.which) ? evt.which : (window.event && window.event.keyCode)
     if ((charCode > 31 && (charCode < 48 || charCode > 57)) || charCode == 13)
     {  
          if(charCode == 13) {
          
	          // Mode Check
	          if(pageMode == "create") {
	            var newTotal = (document.getElementById("total-"+rid).value * document.getElementById("qty-"+rid).value);
	            var oldTotal = 0;
	            var akey     = "";
	            j$.each(pObj.data, function(index, value) {
	                j$.each(value, function(nid, nval) {
	                    if(nval == rid) {
	                        akey = index;
	                    }   
	                });
	            });
	            
	            pObj.data[akey].dealer__Quantity_Sold__c = parseInt(document.getElementById("qty-"+rid).value);
	            pObj.data[akey].dealer__Extended_Total   = pObj.data[akey].dealer__Net__c * pObj.data[akey].dealer__Quantity_Sold__c;
	                        
	            document.getElementById("total-"+rid).value =(pObj.data[akey].dealer__Quantity_Sold__c * pObj.data[akey].dealer__Net__c).toFixed(2);
	            
	            totalDollars();
	                
			  } else {
				var q    =  j$("#qty-"+lineID).val();
		        dealer.PartsInvoice_EXT.updateLineQty( lineID+"-"+q, function(result, event) {
		            if(event.status) {
		                // Good
		            } else if (event.type == 'excetion') {
		                logError(event.message);
		            } else {
		                logError(event.message);
		            }
		        }, { escape:true});
		        // Update Total Price and Line specific price
		        updatePricing(invoiceId);
		        j$("#total-"+lineID).val((j$("#qty-"+lineID).val() * j$("#net-"+lineID).val()).toFixed(2));
		        // Prevent Enter
		        return false;
			  
			  }
          }
          return false;
     }
     else
     {
         return true;
     }  
}    
    
function createItem(type) {
    
    // Serialize Parts Data Submit String
    var actionString=   "";
    
    var customer    =   j$(esc(customerLKID_element)).val();
    var contact 	=	j$("[id$='customer_select_list']").val();
    var counterman  =   j$(esc(countermanLKID_element)).val();
    var comments    =   j$(esc(comments_element)).val();

    var taxexempt	=	'false';
    if(j$(esc('PartsCreateInvoicePage:CreateInvoiceForm:counterSalesPB:detailSection:TaxExempt')).is(":checked")) {
    	taxexempt 	=	'true';
    }

    // Build Invoice Object
    invObj.customer     =   customer;
    invObj.contact 		=	contact;
    invObj.counterman   =   counterman;
    invObj.comments     =   escape(comments);
    invObj.taxexempt	=	taxexempt;
    invObj.pricelevel   =   getPL();
    invObj.lines        =   pObj.data;

    // Adding location to XML Payload - DR 10/11/2015
    invObj.location        =   j$('[id$="invoiceLocation_lkid"]').val();
    
    actionString = '<invoice>'+json2xml(invObj, "")+'</invoice>';
	cLog(actionString);
	// Create Invoice
	// return false;
	
    if(j$(esc(customer_element)).val() == '') {
        
            alert('Customer account must be entered to create invoice.');
            j$(esc(customer_element)).focus();
            
        return false;
    } else {
    
     // Quote or Invoice
        if(type == 'quote') {
            dealer.PartsInvoice_EXT.CreatePartsQuote(actionString, function(result, event) {
                if(event.status) {
                    window.location.href=result;
                } else if (event.type === 'exception') {    
                   
                	logError(event.message);
                } else {
                 
                	logError(event.message);
                }
            }, {escape:true}); 
        } else {
            dealer.PartsInvoice_EXT.CreateInvoice(actionString, function(result, event) {
                if(event.status) {
                    window.location.href=result;
                } else if (event.type === 'exception') {    
                  
               	  logError(event.message);
                } else {
                   
                   logError(event.message);
                }
            }, {escape:true});
        }
    }       
}   

function resetInlineEdit() {
}

function esc(myid) {
       return '#' + myid.replace(/(:|\.)/g,'\\\\$1');
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

function logError(msg) {

    if(typeof window.console == 'object') {
        console.log(msg);                  
    }
            
	j$('#errors-js').text(msg);
}

function cLog(msg) {
    if(typeof window.console == 'object') {
        console.log(msg);                  
    }
}

function MenuButtonCustom(a,c,d){
		this.id=a;
		this.hasDefaultAction=c;
		
		this.parentDiv=document.getElementById(a+'-'+d);
		if(!this.parentDiv) { cLog('Parent Div Element not Found'+a+'-'+d); return false; }
		this.buttonDiv=document.getElementById(a+MenuButtonElement.BUTTON+'-'+d);
		cLog('Button Div Element not Found: '+a+MenuButtonElement.BUTTON+'-'+d);
		if(!this.buttonDiv) { cLog('Button Div Element not Found: '+a+MenuButtonElement.BUTTON+'-'+d); return false; }
		this.buttonLabel=document.getElementById(a+MenuButtonElement.LABEL+'-'+d);
		this.menuDiv=document.getElementById(a+MenuButtonElement.MENU+'-'+d);
		this.buttonWidth=MenuButton.DEFAULT_ARROW;
		this.shim=new iframeShim(this.menuDiv);
		
		var b=this;
		addEvent(document,"click", function(a){b.hideOthers(a)},!1);
		addEvent(document,"keydown",function(a){b.handleKeyPress(a)},!1);
		addEvent(this.parentDiv,"click",function(a){b.handleDivClick(a)},!1);
		addEvent(this.parentDiv,"mouseover",function(){addStyleClass(b.parentDiv,"menuButtonOver")});
		addEvent(this.parentDiv,"mouseout",function(){delStyleClass(b.parentDiv,"menuButtonOver")});
		addEvent(this.buttonLabel,"mousedown",function(a){b.removeDottedLinkOutline(a)},!1);
		addEvent(this.buttonLabel,"mouseout",function(a){b.removeDottedLinkOutline(a)},!1);
		addEvent(this.buttonLabel,"keydown",function(a){a.keyCode==KEY_ENTER&&b.handleDivClick(a)},!1);
		addEvent(this.menuDiv,"click",function(a){return b.handleMenuClick(a)},!1);
}

function showLoader(){
	j$('<div>', {id:'loader',html:'<i class="fa fa-spinner fa-pulse"></i>'}).appendTo(j$('[id$="partid"]'))
}

function hideLoader(){
    j$('#loader').fadeOut(500, function(){
	    j$('#loader').remove();
    });
}