// var mongoose = require('mongoose');
// var Plant = mongoose.model('Plant');
var fs = require('fs');
var all = require("./../../allPlants.json");

function get_all(callback){
	var somePlants = [];
	for(var plant in all){
		if(!all[plant].archived){
			somePlants.push(all[plant]);
		}
	}
	return callback(somePlants);

}

function get_archived(callback){
	var archivedPlants = [];
	for(var plant in all){
		if(all[plant].archived){
			archivedPlants.push(all[plant]);
		}
	}
	return callback(archivedPlants);
}

function create(new_plant, callback){
	all.push(new_plant);
	fs.writeFile('allPlants.json', JSON.stringify(all, null, 4), function(err){
		return callback(all);
	})
}

function create_unique(new_plant, callback){
	for(var plant in all){
		if(all[plant].name == new_plant.name){
			return callback(null);
		}
	}
	all.push(new_plant);
	fs.writeFile('allPlants.json', JSON.stringify(all, null, 4), function(err){
		return callback(all);
	})
}

function get_by_id(name, callback){
	for(var plant in all){
		if(all[plant].name == name){
			return callback(all[plant])
		}
	}
	return callback(null);
}

function delete_by_id(name, callback){
	for(var plant in all){
		if(all[plant].name == name){
			all.splice(plant, 1);
			fs.writeFile('allPlants.json', JSON.stringify(all, null, 4), function(err){
				return callback(all);
			})
		}
	}

}

function edit_by_id(name, edit, callback){
	for(var plant in all){
		if(all[plant].name == name){
			all[plant] = edit;
			fs.writeFile('allPlants.json', JSON.stringify(all, null, 4), function(err){
				return callback(all)
			})
		}
	}
}

function add_img_by_id(name, data, callback){
	for(var plant in all){
		if(all[plant].name == name){
			var edit_plant = all[plant];
			for(var e in data){
				edit_plant[e] = data[e];
			}
			fs.writeFile('allPlants.json', JSON.stringify(all, null, 4), function(err){
				return callback(all)
			})
		}
	}
	return callback(null);
}

function better_update_by_id(name, data, callback){
	for(var plant in all){
		if(all[plant].name == name){
			var edit_plant = all[plant];
			for(var e in data){
				edit_plant[e] = data[e];
			}
			fs.writeFile('allPlants.json', JSON.stringify(all, null, 4), function(err){
				return callback(all)
			})
		}
	}
	return callback(null);
}

module.exports = (function(){
	return{
		index:function(req,res){
			get_all(function(data){
				res.render('results', {results: data});
			})
		},
		getArchived:function(req,res){
			get_archived(function(data){
				res.render('arc_results', {results: data});
			})
		},
		add:function(req,res){
			var newPlant = {
				name:(req.body.name !="")?req.body.name:"untitled",
				description:req.body.description,
				location:req.body.location,
				origin:req.body.origin,
				whenToPlant:req.body.whenToPlant,
				coolFact:req.body.coolFact,
				imgStr1:req.body.imgStr1,
				imgStr2:req.body.imgStr2,
				imgStr3:req.body.imgStr3,
				imgStr4:req.body.imgStr4,
				created_at:Date(),
				updated_at:Date(),
				archived:false,
				imgname1:(req.body.imgname1!="")?req.body.imgname1:"img1",
				imgname2:(req.body.imgname2!="")?req.body.imgname2:"img2",
				imgname3:(req.body.imgname3!="")?req.body.imgname3:"img3",
				imgname4:(req.body.imgname4!="")?req.body.imgname4:"img4",
			};
			res.redirect('/all')

			// var plant = new Plant(newPlant);
	// 		plant.save(function(err){
	// 	if(err){
	// 		console.log('something went wrong');
	// 	}else{
	// 		console.log('successfully added a plant');
	// 		console.log(plant)
	//
	// 		// res.json(plant);
	// 		res.redirect('/all')
	// 	}
	// })

			create_unique(newPlant, function(data){
				if(data == null){
					console.log('problem');
					res.render('new', {error: 'You must add a unique plant name!'})
				}else{
					res.redirect('/new');
				}
			})

		},

		remove:function(req,res){
			delete_by_id(req.params.name, function(data){
				res.redirect("/all");
			})

		},
		update:function(req,res){
			// console.log('1')
			var updated_plant = {
				name: req.body.name,
				description: req.body.description,
				location: req.body.location,
				origin: req.body.origin,
				whenToPlant: req.body.whenToPlant,
				coolFact: req.body.coolFact,
				created_at:req.body.created_at,
				updated_at: Date(),
				archived: false,
				imgStr1 : (req.body.imgStr1 !== '')?req.body.imgStr1:req.body.original_imgStr1,
				imgStr2 : (req.body.imgStr2 !== '')?req.body.imgStr2:req.body.original_imgStr2,
				imgStr3 : (req.body.imgStr3 !== '')?req.body.imgStr3:req.body.original_imgStr3,
				imgStr4 : (req.body.imgStr4 !== '')?req.body.imgStr4:req.body.original_imgStr4,
				imgname1:req.body.imgname1,
				imgname2:req.body.imgname2,
				imgname3:req.body.imgname3,
				imgname4:req.body.imgname4,

			}

			edit_by_id(req.body.name, updated_plant, function(data){
				res.redirect('/all');
			})

		},
		edit:function(req,res){
			get_by_id(req.params.name, function(data){
				res.render('edit', {plant: data});
			})

		},
		upload:function(info,res){
			Plant.findOne({_id:info.id },function (err, doc){
			  doc.filename = info.filename;
			  doc.mimetype = info.mimetype;
			  doc.originalname = info.originalname;
			  doc.updated_at = Date();
			  doc.save();
			});
		},
		printToFile:function(req,res){
			Plant.find({},function(err,output){
				if(err){
					console.log(err);
				}else{
					var outputFilename = 'allPlants.json';
					fs.writeFile(outputFilename, JSON.stringify(output, null, 4), function(err) {
					    if(err) {
					      console.log(err);
					    } else {
					      console.log("JSON saved to " + outputFilename);
					      res.redirect("/all");
					    }
					});
				}
			})
		},
		//get all unarchived plants
		getAllPlants:function(req,res){
			console.log('success!!');
			get_all(function(data){
				res.json(data);
			})
		},
		show:function(req,res){
			get_by_id(req.params.name, function(data){
				res.render("show",{plant:data});
			})
		},
		toPrintPage:function(req,res){
			get_by_id(req.params.name, function(data){
				res.render('print', {plant: data});
			})
		},

		archive:function(req,res){
			get_by_id(req.params.name, function(data){
				var updated_plant = {
					name: data.name,
					description: data.description,
					location: data.location,
					origin: data.origin,
					whenToPlant: data.whenToPlant,
					coolFact: data.coolFact,
					created_at:data.created_at,
					updated_at: Date(),
					archived: true,
					imgStr1 : data.imgStr1,
					imgStr2 : data.imgStr2,
					imgStr3 : data.imgStr3,
					imgStr4 : data.imgStr4,
					imgname1: data.imgname1,
					imgname2: data.imgname2,
					imgname3: data.imgname3,
					imgname4: data.imgname4,

				}

				edit_by_id(req.params.name, updated_plant, function(data){
					res.redirect('/all');
				})
			})


		},
		restore:function(req,res){
			get_by_id(req.params.name, function(data){
				var updated_plant = {
					name: data.name,
					description: data.description,
					location: data.location,
					origin: data.origin,
					whenToPlant: data.whenToPlant,
					coolFact: data.coolFact,
					created_at:data.created_at,
					updated_at: Date(),
					archived: false,
					imgStr1 : data.imgStr1,
					imgStr2 : data.imgStr2,
					imgStr3 : data.imgStr3,
					imgStr4 : data.imgStr4,
					imgname1: data.imgname1,
					imgname2: data.imgname2,
					imgname3: data.imgname3,
					imgname4: data.imgname4,

				}

				edit_by_id(req.params.name, updated_plant, function(data){
					res.redirect('/getArchived');
				})
			})
		},

		createSnapshot:function(req,res){
			var filename = "snapshot_"+Date()+".json";
			var filename_mod = filename.split(' ').join('');
			fs.writeFile(filename_mod, JSON.stringify(all, null, 4), function(err){
				res.redirect('/showSnapshot');
			})
		},

		getSnapshot:function(req,res){
			var models_path = __dirname + '/../../';
			var files = [];
			fs.readdirSync(models_path).forEach(function(file) {
			  if(file.match('snapshot')) {
			    files.push(file);
			  }
			})
			res.render('snapshot',{results:files});
		},

		restoreFromSnapshot:function(req,res){
			var filename = req.params.name;
			var data = require("./../../"+filename);
			fs.writeFile('allPlants.json', JSON.stringify(data, null, 4), function(err){
				console.log("restored from "+filename);
				res.redirect('/showSnapshot');
			})

		},
		removeSnapshot:function(req,res){
			var filename = req.params.name;
			var filePath = filename ;
			fs.unlinkSync(filePath);
			console.log(filePath+" removed");
			res.redirect('/showSnapshot');
		},

	}//return
})()
