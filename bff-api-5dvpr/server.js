const express = require('express');
const server = express();
const logger = require('./logger');

server.get('/healthcheck/ready', (req, res) => {
    return res.status(200).json({ 
        appName: "App-Sample",
        appRelease: "1.0.0",
        status: "Running" 
    });
})

logger.info('App Init')   
logger.info('App start dependences')  
logger.info('App Preparing')  
logger.info('App Running in port 80 !!')  

server.listen(80);