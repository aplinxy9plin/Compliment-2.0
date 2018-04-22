const express = require('express')
const app = express()
var moment = require('moment');
moment.locale('ru');
// MINER))))
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
app.get('/reg', (req,res) =>{
	var token = req.query.access_token
	var user_id = req.query.user_id
	var sql = con.query("SELECT user_id FROM boys WHERE user_id = "+user_id+"", function (err, result, fields) {
	    if (err) throw err;
	    if(result[0] == undefined){
	      var sql = "INSERT INTO boys (access_token, user_id) VALUES ('"+token+"', '"+user_id+"')";
	      con.query(sql, function (err, result) {
	        if (err) throw err;
	        //getName(user_id)
	        console.log("User recorded to database");
	        res.send('New')
	      });
	    }else{
	      console.log('Just used')
	      res.send('Used')
	    }
	})
	//res.send(token+"<br>"+user_id)
})

app.get('/questboy', (req,res) =>{
	var answer = req.query.quest
	var user_id = req.query.user_id
	var query_string = ""
	for (var i = 0; i < 5; i++) {
		var k = i + 1
		query_string = query_string + "quest"+k+" = '"+answer[i]+"'"
		if(i !== 4){
			query_string = query_string + ","
		}
	}
	console.log(query_string)
	var sql = "UPDATE boys SET "+query_string+" WHERE user_id = "+user_id+"";
        con.query(sql, function (err, result) {
        if (err) throw err;
        console.log('Answers added')
    })
	//res.send(token+"<br>"+user_id)
	res.send(answer)
})

app.get('/get_name', (req,res) =>{
	var user_id = req.query.user_id
	var sql = "SELECT name FROM boys WHERE user_id = "+user_id+"";
        con.query(sql, function (err, result) {
        if (err) throw err;
    	res.send(result[0].name)
    })
})
app.get('/girl_id', (req,res) =>{
	var user_id = req.query.user_id
	var girl_id = req.query.girl_id
	var sql = "UPDATE boys SET girl_id = "+girl_id+" WHERE user_id = "+user_id+"";
        con.query(sql, function (err, result) {
        if (err) throw err;
        console.log('Girl added')
    })
    res.send('Girl added')
})
app.get('/vk_bot', (req,res) =>{
	var user_id = req.query.user_id
	sendMessageBot(user_id,'66b58e42989cca5adea9a2a149012548e2ef2c6dc5778393e0dfb7a778d96733dfdb748d92228c363977d','test')
})
app.get('/send_message', (req,res) =>{
	var user_id = req.query.user_id
	compliment_chooser(user_id)
	compliment_chooser1(user_id)
    res.send('Working')
})
function compliment_chooser(user_id){
	var now_time = moment().format('HH')
	var message = ""
	var random = 0
	var morning = ['Доброе утречко ','Что снилось?)','Доброе утро','Как спалось?)']
	var morning1 = ['моя ','любимая','солнышко']
	var morning2 = ['самая ','сладкая','радость','дорогая','любимая','девочка','маленькая','любовь','жизнь','ласточка','хорошая']
	var morning3 = ['большая ','родная','лучшая','прекрасная','высокая']
	var morning4 = ['радость ','проблема','медведица','попа']
	var morning5 = 'жизни '
	var day = ['Думаю ','Как дела?)','О чём думаешь?','Как день?','Как проходит день?','Вспомнил, как ты сексуально выглядишь в плятьях и пошел в туалет']
	var day1 = ['о тебе','о том, как мне хорошо с тобой, когда ты рядом','о том, как я счастлив, что ты у меня есть']
	var evening = ['Сладких снов, пусть тебе присн','Чем занималась?','Как прошел день?','Спокойной ночи. Завтра предлагаю сходить на какой-нибудь новый фильм :)']
	var evening1 = ['юсь я','ится единорог','ятся твои мечты','ится волшебный сон']
	var sql = "SELECT access_token, girl_id FROM boys WHERE user_id = "+user_id+"";
        con.query(sql, function (err, result) {
        if (err) throw err;
       	user_id = result[0].girl_id
        // Morning
	    if(now_time < 11 && now_time >= 5){
			random = rand(3)
			if(random == 0){
				message = morning[0]
				random = rand(2)
				if(random == 0){
					message = message + morning1[0]
					random = rand(10)
					if(random == 0){
						message = message + morning2[0]
						random = rand(4)
						if(random == 0){
							message = message + morning3[0]
							random = rand(3)
							if(random == 0){
								message = message + morning4[0] + morning5
								sendMessage(user_id,result[0].access_token,message)
							}else{
								message = message + morning4[random]
								sendMessage(user_id,result[0].access_token,message)
							}
						}else{
							message = message + morning3[random]
							sendMessage(user_id,result[0].access_token,message)
						}
					}else{
						message = message + morning2[random]
						sendMessage(user_id,result[0].access_token,message)
					}
				}else{
					message = message + morning1[random]
					sendMessage(user_id,result[0].access_token,message)
				}
			}else{
				message = morning[random]
				sendMessage(user_id,result[0].access_token,message)
			}
        }
        // Day
        if(now_time >= 11 && now_time <= 19){
        	random = rand(5)
        	if(random == 0){
        		message = day[0]
        		random = rand(2)
        		message = message + day1[random]
        		sendMessage(user_id,result[0].access_token,message)
        	}else{
        		message = day[random]
        		sendMessage(user_id,result[0].access_token,message)
        	}
        }
        // Evening
	    if((now_time > 19 && now_time < 23) || (now_time >= 0 && now_time < 5)){
        	random = rand(3)
        	switch (random) {
			  case 0:
			  	message = evening[0]
			    random = rand(3)
			    message = message + evening1[random]
        		sendMessage(user_id,result[0].access_token,message)
			    break;
			  case 3:
			  	// Бот отправляет сообщение о киношке
				message = evening[3]
        		sendMessage(user_id,result[0].access_token,message)
			    break;
			  default:
				message = evening[random]
        		sendMessage(user_id,result[0].access_token,message)
        	}
        }
    })
}
function compliment_chooser1(user_id){
	var now_time = moment().format('HH')
	var message = ""
	var random = 0
	var morning = ['Доброе утречко ','Что снилось?)','Доброе утро','Как спалось?)']
	var morning1 = ['моя ','любимая','солнышко']
	var morning2 = ['самая ','сладкая','радость','дорогая','любимая','девочка','маленькая','любовь','жизнь','ласточка','хорошая']
	var morning3 = ['большая ','родная','лучшая','прекрасная','высокая']
	var morning4 = ['радость ','проблема','медведица','попа']
	var morning5 = 'жизни '
	var day = ['Думаю ','Как дела?)','О чём думаешь?','Как день?','Как проходит день?','Вспомнил, как ты сексуально выглядишь в плятьях и пошел в туалет']
	var day1 = ['о тебе','о том, как мне хорошо с тобой, когда ты рядом','о том, как я счастлив, что ты у меня есть']
	var evening = ['Сладких снов, пусть тебе присн','Чем занималась?','Как прошел день?','Спокойной ночи. Завтра предлагаю сходить на какой-нибудь новый фильм :)']
	var evening1 = ['юсь я','ится единорог','ятся твои мечты','ится волшебный сон']
	var sql = "SELECT access_token, girl_id1 FROM boys WHERE user_id = "+user_id+"";
        con.query(sql, function (err, res) {
        if (err) throw err;
       	user_id = res[0].girl_id1
       	if(user_id !== ""){
	        // Morning
	        if(now_time < 11 && now_time >= 5){
				random = rand(3)
				if(random == 0){
					message = morning[0]
					random = rand(2)
					if(random == 0){
						message = message + morning1[0]
						random = rand(10)
						if(random == 0){
							message = message + morning2[0]
							random = rand(4)
							if(random == 0){
								message = message + morning3[0]
								random = rand(3)
								if(random == 0){
									message = message + morning4[0] + morning5
									sendMessage(user_id,res[0].access_token,message)
								}else{
									message = message + morning4[random]
									sendMessage(user_id,res[0].access_token,message)
								}
							}else{
								message = message + morning3[random]
								sendMessage(user_id,res[0].access_token,message)
							}
						}else{
							message = message + morning2[random]
							sendMessage(user_id,res[0].access_token,message)
						}
					}else{
						message = message + morning1[random]
						sendMessage(user_id,res[0].access_token,message)
					}
				}else{
					message = morning[random]
					sendMessage(user_id,res[0].access_token,message)
				}
	        }
	        // Day
	        if(now_time >= 11 && now_time <= 19){
	        	random = rand(5)
	        	if(random == 0){
	        		message = day[0]
	        		random = rand(2)
	        		message = message + day1[random]
	        		sendMessage(user_id,res[0].access_token,message)
	        	}else{
	        		message = day[random]
	        		sendMessage(user_id,res[0].access_token,message)
	        	}
	        }
	        // Evening
	        if((now_time > 19 && now_time < 23) || (now_time >= 0 && now_time < 5)){
	        	random = rand(3)
	        	switch (random) {
				  case 0:
				  	message = evening[0]
				    random = rand(3)
				    message = message + evening1[random]
	        		sendMessage(user_id,res[0].access_token,message)
				    break;
				  case 3:
				  	// Бот отправляет сообщение о киношке
					message = evening[3]
	        		sendMessage(user_id,res[0].access_token,message)
				    break;
				  default:
					message = evening[random]
	        		sendMessage(user_id,res[0].access_token,message)
	        	}
	        }
    	}
    })
}
function rand(max){
	return Math.floor(Math.random() * (max))
}
//moment().format('LT')
function sendMessage(user_id,access_token,message){
    (function(callback) {
        'use strict';

        const httpTransport = require('https');
        const responseEncoding = 'utf8';
        const httpOptions = {
            hostname: 'api.vk.com',
            port: '443',
            path: '/method/messages.send?user_id='+user_id+'&access_token='+access_token+'&v=5.63&message='+encodeURIComponent(message)+'',
            method: 'GET',
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
        console.log('Message Sended')
        var sql = "SELECT user_id FROM boys WHERE access_token = '"+access_token+"'";
	        con.query(sql, function (err, result) {
	        if (err) throw err;
	        var random_time = 7000//Math.floor(Math.random() * (120000 - 40000)) + 40000 // милисекунд
	        setTimeout(compliment_chooser, random_time, result[0].user_id)
	    })
    });
}
function sendMessageBot(user_id,access_token,message){
    (function(callback) {
        'use strict';

        const httpTransport = require('https');
        const responseEncoding = 'utf8';
        const httpOptions = {
            hostname: 'api.vk.com',
            port: '443',
            path: '/method/messages.send?user_id='+user_id+'&access_token='+access_token+'&v=5.63&message='+encodeURIComponent(message)+'',
            method: 'GET',
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
        console.log('Message Sended by BOT')
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
        var sql = "UPDATE boys SET name = '"+test['response'][0]['first_name']+' '+test['response'][0]['last_name']+"' WHERE user_id = "+user_id+"";
            con.query(sql, function (err, result) {
            if (err) throw err;
            console.log('Name Added')
        })
    });
}
app.listen(3000, function (){
	console.log('Compliment 2.0 backend started');
})
// если у пользователя уже есть одна+ девушка - кидаем на "ваши девушки"
//http://localhost:3000/questboy?quest=123&quest=321&quest=321&quest=321&quest=321&user_id=133087344
//http://localhost:3000/girl_id?user_id=133087344&girl_id=153869259
//http://localhost:3000/reg?access_token=2281337&user_id=133087344
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
