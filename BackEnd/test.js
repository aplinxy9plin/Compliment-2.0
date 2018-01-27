var moment = require('moment');
moment.locale('ru');
console.log(moment().format('HH'))
if(moment().format('HH') < 4){
    console.log("<")
}else{
    console.log(">")
}