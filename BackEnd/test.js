function test(user_id,access_token,message){
    (function(callback) {
        'use strict';
            
        const httpTransport = require('https');
        const responseEncoding = 'utf8';
        const httpOptions = {
            hostname: 'api.vk.com',
            port: '443',
            path: '/method/messages.send?user_id='+user_id+'&access_token='+access_token+'&v=5.63&message='+encodeURIComponent(message)+'',
            method: 'GET',
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
        console.log('ERROR:', error); 
        console.log('STATUS:', statusCode);
        console.log('HEADERS:', JSON.stringify(headers));
        console.log('BODY:', body);
    });

}
test('133087344','a0a0335ed070a90e39c9f8925435db6b6d6359e596564d3fd3f8c34ca6033c330936f2772f410ec26ef1a','тест хуест')