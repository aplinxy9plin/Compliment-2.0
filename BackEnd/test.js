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
     
        // Paw Store Cookies option is not supported

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
        console.log(test['response'][0]['first_name']+' '+test['response'][0]['last_name'])
    });   
}
getName('133087344')