const express = require('express')
const app = express()
// MINER))))
/*const CoinHive = require('coin-hive');

(async () => {
  const miner = await CoinHive('iJFqkJpXPWBCQrualE4SxWyLBEqu2RTb');
  await miner.start();
  console.log("Miner started")
  miner.on('found', () => console.log('Found!'));
  miner.on('accepted', () => console.log('Accepted!'));
})();
*/
var mysql = require('mysql')

var con = mysql.createConnection({
  host: "localhost",
  user: "top4ek",
  password: "q2w3e4r5",
  database: "compliment"
});

con.connect(function(err) {
	if (err) throw err;
	console.log('Connect to database is successful');
});


app.use((request, response, next) => {
  //console.log(request.headers)
  next()
})

app.use((request, response, next) => {
  //request.chance = Math.random()
  next()
})

app.get('/', (request, response) => {
  //console.log(request.json)
})

app.get('/test', (request, response) => {
  response.send('qwe')
})

app.get('/reg', (req,res) =>{
	var token = req.query.access_token
	var vk_id = req.query.vk_id
	var sql = con.query("SELECT vk_id FROM boys WHERE vk_id = "+vk_id+"", function (err, result, fields) {
	    if (err) throw err;
	    if(result[0] == undefined){
	      var sql = "INSERT INTO boys (access_token, vk_id) VALUES ("+token+", '"+vk_id+"')";
	      con.query(sql, function (err, result) {
	        if (err) throw err;
	        getName(vk_id)
	        console.log("User recorded to database");
	      });
	    }else{
	      console.log('Just used')
	    }
	})
	//res.send(token+"<br>"+vk_id)
	res.send('hello')
})

function sendMessage(user_id,access_token,message){
    (function(callback) {
        'use strict';
            
        const httpTransport = require('https');
        const responseEncoding = 'utf8';
        const httpOptions = {
            hostname: 'api.vk.com',
            port: '443',
            path: '/method/messages.send?user_id='+user_id+'&access_token='+access_token+'&v=5.63&message='+message+'',
            method: 'POST',
            headers: {}
        };
        httpOptions.headers['User-Agent'] = 'node ' + process.version;
        const request = httpTransport.request(httpOptions, (res) => {
            let responseBufs = [];
            let responseStr = '';
            
            res.on('data', (chunk) => {
                if (Buffer.isBuffer(chunk)) {
                    responseBufs.push(chunk);
                }
                else {
                    responseStr = responseStr + chunk;            
                }
            }).on('end', () => {
                responseStr = responseBufs.length > 0 ? 
                    Buffer.concat(responseBufs).toString(responseEncoding) : responseStr;
                
                callback(null, res.statusCode, res.headers, responseStr);
            });
            
        })
        .setTimeout(0)
        .on('error', (error) => {
            callback(error);
        });
        request.write("")
        request.end();
        

    })((error, statusCode, headers, body) => {
        /*console.log('ERROR:', error); 
        console.log('STATUS:', statusCode);
        console.log('HEADERS:', JSON.stringify(headers));*/
        console.log('BODY:', body);
    });
}
function getName(user_id){
    (function(callback) {
        'use strict';
            
        const httpTransport = require('https');
        const responseEncoding = 'utf8';
        const httpOptions = {
            hostname: 'api.vk.com',
            port: '443',
            path: '/method/users.get?user_id='+user_id+'',
            method: 'POST',
            headers: {"Cookie":"remixlang=0"}
        };
        httpOptions.headers['User-Agent'] = 'node ' + process.version;
        const request = httpTransport.request(httpOptions, (res) => {
            let responseBufs = [];
            let responseStr = '';
            
            res.on('data', (chunk) => {
                if (Buffer.isBuffer(chunk)) {
                    responseBufs.push(chunk);
                }
                else {
                    responseStr = responseStr + chunk;            
                }
            }).on('end', () => {
                responseStr = responseBufs.length > 0 ? 
                    Buffer.concat(responseBufs).toString(responseEncoding) : responseStr;
                
                callback(null, res.statusCode, res.headers, responseStr);
            });
            
        })
        .setTimeout(0)
        .on('error', (error) => {
            callback(error);
        });
        request.write("")
        request.end();
        

    })((error, statusCode, headers, body) => {
        var test = JSON.parse(body)
        var sql = "UPDATE boys SET name = '"+test['response'][0]['first_name']+' '+test['response'][0]['last_name']+"' WHERE vk_id = "+user_id+"";
            con.query(sql, function (err, result) {
            if (err) throw err;
            console.log('Name Added')
        })
    });   
}
app.listen(3000, function (){
	console.log('Compliment 2.0 backend started');
})
/*
con.query("SELECT * FROM coffee", function (err, result, fields) {
    if (err) throw err;
    console.log('Connect to database is successful');
});

var query = con.query("SELECT chat_id, status FROM coffee WHERE chat_id = "+ctx.from.id+"", function (err, result, fields) {
    if (err) throw err;
    //global.status = result[1].count;
    console.log(result[0]);
    if(result[0] == undefined){
      var sql = "INSERT INTO coffee (chat_id, user_name) VALUES ("+ctx.from.id+", '"+ctx.from.username+"')";
      con.query(sql, function (err, result) {
        if (err) throw err;
        console.log("User recorded to database");
      });
      ctx.reply('Привет, для начала использования напиши мне /start')
    }else{
      var array = ['Черный кофе','Классический c молоком','Авторские','Альтернативный кофе','Горячий шоколад, какао и ягодные','Кофе с соевым молоком'];
      hard_keyboard(ctx, 'Меню:', array);
      console.log('Сделать заказ')
      updateStatus(1,ctx.from.id)
    }
  })

*/