const puppeteer = require('puppeteer');
const directorypath = "./copies/1";
var fs = require('fs');
var path = require('path');

//joining path of directory 
const directoryPath = path.join(__dirname, 'copies/1');
//passsing directoryPath and callback function
//fs.readdir(directoryPath, function (err, files) {
    //handling error
//    if (err) {
//        return console.log('Unable to scan directory: ' + err);
//    } 
    //listing all files using forEach
//    files.forEach(function (file) {
        // Do whatever you want to do with the file
//        console.log(file + '/preview.png'); 
//	var previewpath = file + '/preview.png';
(async () => {
	//const browser = await puppeteer.launch();
 	//const page = await browser.newPage();
	        const browser = await puppeteer.launch();
        const page = await browser.newPage();
//  await page.goto('file:///home/kzin/git_projects/theproject/dist/0/index.html');
//	await page.goto('https://cutepigclub.mypinata.cloud/ipfs/QmfWK1GazJ4truyBbaDVxExcBiJteu7Ar53GQUcUfncwcx/101/index.html');
	await page.goto('http://www.pigs.com/theproject/build/copies/1/101/index.html');
//  await page.waitForNavigation({
//  	waitUntil: 'load',
//	timeout: 0
//  });
	var previewpath = './copies/1/101/101.jpg';
	await page.waitForTimeout(60000);
	await page.screenshot({ path: previewpath, type: 'jpeg' });

	await browser.close();
})();
//    });
//});
