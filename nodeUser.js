
function changeStudentPassword(req,res,con){
	var user_id=req.query.user_id;
	var old_pass=req.query.old_Pass;
	var new_pass=req.query.new_Pass;
	var sql="update user_info set password=? where user_id=? and password=?";
	con.query(sql,[new_pass,user_id,old_pass],function(err,result){
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

function changeStudentPhone(req,res,con){
	var user_id=req.query.user_id;
	var phone=req.query.new_phone;
	var sql="update user_info set phone_no=? where user_id=?";
	con.query(sql,[phone,user_id],function(err,result){
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

module.exports={
	changeStudentPassword:function(req,res,con){
		changeStudentPassword(req,res,con);
	},
	changeStudentPhone:function(req,res,con){
		changeStudentPhone(req,res,con);
	}
}
