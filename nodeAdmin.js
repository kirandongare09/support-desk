var fs=require('fs');

function getAllEquipment(req,res,con){
	var sql="select distinct(equipment) from master_data";
	con.query(sql,function(err,result){
		if(err){
			console.log(err);
			res.end("false");
		}
		res.end(JSON.stringify(result));
	})
}

function getAllHistory(req,res,con){
	var values=req.query;
	var sInfoRadio=values.sInfoRadio;
	var sInfoValue="";
	var engineer_id="";
	try{
		sInfoValue=values.sInfoValue.trim();
	}
	catch(err){
		sInfoValue=""
	}
	try{
		engineer_id=values.engineer_id.trim();
	}
	catch(err){
		engineer_id=""
	}
	//console.log(sInfoValue+" "+sInfoRadio);
	//?subject=any&catagory=any&time_slot=any&type=any&status=any&rating=any
	var subject=values.subject.trim();
	var catagory=values.catagory.trim();
	var time_slot=values.time_slot.trim();
	var type=values.type.trim();
	var status=values.status.trim();
	var rating=values.rating.trim();
	var sql="select * from service_call_info c,engineer_info h,user_info s where c.engineer_id=h.engineer_id and c.user_id=s.user_id ";
	if(engineer_id!=""){
		sql+="and c.engineer_id="+engineer_id+" ";
	}
	if(sInfoValue!=""){
		if(sInfoRadio=="name"){
			sql+="and s.name='"+sInfoValue+"' ";
		}
		if(sInfoRadio=="roll"){
			sql+="and emp_id='"+sInfoValue+"' ";
		}
		if(sInfoRadio=="room"){
			var r=sInfoValue.split(" ")[1];
			var g=sInfoValue.split(" ")[0];
			//console.log(r+" "+g);
			sql+="and lab_name="+r+" and gender='"+g+"' ";
		}
	}
	if(subject!="Any"){
		sql+="and subject='"+subject+"' ";
	}
	if(catagory!="Any"){
		sql+="and c.catagory='"+catagory+"' ";
	}
	if(time_slot!="Any"){
		sql+="and time_slot='"+time_slot+"' ";
	}
	if(type!="Any"){
		sql+="and type='"+type+"' ";
	}
	if(status!="Any"){
		if(status=="Lodged")
			status="(0)";
		if(status=="Unsolved")
			status="(0,1)";
		if(status=="Progress")
			status="(1)";
		if(status=="Solved")
			status="(2,3)";
		if(status=="Closed")
			status="(3)";
		sql+="and status in "+status+" ";
	}
	if(rating!="Any"){
		if(rating=="Poor")
			rating="(1,2)";
		if(rating=="Average")
			rating="(3)";
		if(rating=="Good")
			rating="(4,5)";
		sql+="and rating in "+rating+" ";
	}

	con.query({sql:sql,nestTables: true},function(err,result){
		if(err){
			console.log(err);
			res.end("false");
		}
		res.end(JSON.stringify(result));
	})
};

function assignWorkHelper(Data,slot,result,status,res,con){
	var id=null;
	var min=10;
	var sequence=-1;
	for(i in Data){
		if(min>Data[i][slot]){
			min=Data[i][slot];
			id=Data[i]['engineer_id'];
			sequence=i;
		}
	}
	if(min>=5)
		return -1;
	else{
		if(status==0)
			var sql="update service_call_info set engineer_id="+id+", status=1 ,assignDate=NOW() where service_call_id="+result.service_call_id;
		else
			var sql="update service_call_info set engineer_id="+id+", status=1 where service_call_id="+result.service_call_id;
		con.query(sql,function(err,result){
			if(err){
				console.log(err);
				res.end("false");
				return;
			}
			else{
				if(result.affectedRow==1){
					return sequence;
				
				}
				return sequence;
			}
		});
	}
	return sequence;
}

function assignWork(networkData,hardwareData,con,res){
	var sql="select service_call_id,time_slot,catagory,status from service_call_info where status<2";
	con.query(sql,function(err,result){
		if(err){
			console.log(err);
			res.end("false");
			return;
		}
		else{
			//console.log(result);
			var slot="slot1";
			var e=0;
			var c=0;
			for(i in result){
				if(result[i].time_slot=="10:00-12:00")
					slot="slot1";
				if(result[i].time_slot=="13:00-15:00")
					slot="slot2";
				if(result[i].time_slot=="16:00-18:00")
					slot="slot3";
				if(result[i].catagory=="Network" ){
					e=assignWorkHelper(networkData,slot,result[i],result[i].status,res,con);
					//console.log("e="+e)
					if(e>=0){
						networkData[e][slot]++;
						networkData[e]['issued']++;
					}
				}
				else if(result[i].catagory=="Hardware" ){
					c=assignWorkHelper(hardwareData,slot,result[i],result[i].status,res,con);
					if(c>=0){
						hardwareData[c][slot]++;
						hardwareData[c]['issued']++;
					}
				}
			}
			for(i in networkData){
				sql="update engineer_info set slot1="+networkData[i]['slot1']+",slot2="+networkData[i]['slot2']+",slot3="+networkData[i]['slot3']+",issued="+networkData[i]['issued']+" where engineer_id="+networkData[i]['engineer_id'];
			
				con.query(sql,function(err,result){
					if(err!=null){
						console.log(err);
						res.end("false");
						return;
					}
				});
			}
			for(i in hardwareData){
				//console.log(networkData[i]['engineer_id']);
				//console.log(networkData[i]['issued']);
				sql="update engineer_info set slot1="+hardwareData[i]['slot1']+",slot2="+hardwareData[i]['slot2']+",slot3="+hardwareData[i]['slot3']+",issued="+hardwareData[i]['issued']+" where engineer_id="+hardwareData[i]['engineer_id'];
				//sql="update engineer_info set slot1="+networkData[i]['slot1']+",slot2="+networkData[i]['slot2']+",slot3="+networkData[i]['slot3']+",issued=issued+"+networkData[i]['issued']+"where engineer_id="+networkData[i]['engineer_id'];
				con.query(sql,function(err,result){
					if(err!=null){
						console.log(err);
						res.end("false");
						return;
					}
				});
			}
		}
		
	});
}


function changeAdminPassword(req,res,con){
	var admin_id=req.query.admin_id;
	var old_pass=req.query.old_Pass;
	var new_pass=req.query.new_Pass;
	var sql="update admin_info set password=? where admin_id=? and password=?";
	con.query(sql,[new_pass,admin_id,old_pass],function(err,result){
		if(err!=null){
			console.log(err);
			res.end("false");
		}
		else if(result.affectedRows==1)
			res.end("true");
		else
			res.end("old");
	})
};

function changeAdminPhone(req,res,con){
	var admin_id=req.query.admin_id;
	var phone=req.query.new_phone;
	var sql="update admin_info set phone_no=? where admin_id=?";
	con.query(sql,[phone,admin_id],function(err,result){
		if(err!=null){
			console.log(err);
			res.end("false");
		}
		else if(result.affectedRows==1)
			res.end("true");
		//console.log(result);
		//console.log(req.query);
	})
};

function adminComplaintAnalysis(req,res,con){
	var sql="select count(*) as total from service_call_info union select count(*) as solved from service_call_info where status>=2";

	con.query(sql,function(err,result){
		if(err)
		{
			console.log(err);
			res.end("false");
			return;
		}
		else
		{
		 res.end(JSON.stringify(result));
	     return;
		}
	});
}

function adminGetIndexPageData(req,res){
	fs.readFile('Help_Details','utf8',function(err, data) {
    	Help_Details='{'+data+'}';
		res.end(Help_Details);
	});
}

module.exports={
	assign: function(req,res,con){
		//return "yes";
		var ids=req;
		var hardwareData=[];
		var networkData=[];
		var sendData={};
		var sql="update engineer_info set slot1=0,slot2=0,slot3=0,today=0;"
		con.query(sql,function(err,result){
			if(err!=null){
				console.log(err);
				res.end("fasle");
			}
			sql="select * from engineer_info where Catagory='Network' and engineer_id in "+ids;
			con.query(sql,function(err,result){
				if(err!=null){
					console.log(err);
					res.end("false");
					return;
				}
				else{
					for(i in result){
						networkData.push(result[i]);
					}
					sendData.network=networkData;
					sql="select * from engineer_info where Catagory='Hardware' and engineer_id in "+ids;
					con.query(sql,function(err,result){
						if(err){
							console.log(err);
							res.end("false");
							return;
						}
						else{
							for(i in result)
								hardwareData.push(result[i]);
							sendData.hardware=hardwareData;
							assignWork(networkData,hardwareData,con,res);
						}
					});
				}
				res.end("true");
				return;
			});
		});
	},

	getHandyManInfo: function(req,res,con){
		var sql="select * from engineer_info";
		con.query(sql,function(err,result){
			if(err!=null){
				console.log(err);
				res.end("false");
			}
			res.end(JSON.stringify(result));
			return;
		});
	},
	getHandyManRating:function(req,res,con){
		var engineer_id=req.query.engineer_id;
		//console.log(req.query);
		var sql="select round(avg(rating),2) as rating from service_call_info where engineer_id="+engineer_id+" and rating is not null and rating<>0"
		con.query(sql,function(err,result){
			if(err!=null){
				//console.log(err);
				res.end("false");
				return false;
			}
			res.end(JSON.stringify(result));
		});
	},
	getAllHistory:function(req,res,con){
		getAllHistory(req,res,con);
	},

	getAllEquipment:function(req,res,con){
		getAllEquipment(req,res,con);
	},

	changeAdminPassword:function(req,res,con){
		changeAdminPassword(req,res,con);
	},

	changeAdminPhone:function(req,res,con){
		changeAdminPhone(req,res,con);
	},

	adminComplaintAnalysis:function(req,res,con){
		adminComplaintAnalysis(req,res,con);
	},

	adminGetIndexPageData:function(req,res){
		adminGetIndexPageData(req,res);
	}
}
