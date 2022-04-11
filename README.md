# thenewproject
To run a local http server w/ Pythion:
```python3 -m http.server```
# Some notes from the pig project
IPFS configuration
1027  ipfs config
 1028  ipfs config edit
 1029  ipfs init --profile lowpower
 1030  ipfs config lowpower apply
 1031  ipfs

1045  ipfs
 1046  ipfs daemon
 1047  ipfs config Addresses
 1048  vim ~/.ipfs/config 
 1049  ipfs daemon
 1050  vim ~/.ipfs/config 
 1051  ipfs daemon
 1052  vim ~/.ipfs/config 
 1053  ipfs daemon
 1054  nohup ipfs daemon &

 1186  nohup ipfs daemon &
 1187  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://192.168.9.7:5001", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"]'
 1188  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'
 1189  kill -9 1985
 
 # requirements
<<<<<<< HEAD
Need npm
(Mac) port install npm8
(Linux) npm install instructions? apt-get? yum?

Need webpack
npm install --save-dev webpack

=======
>>>>>>> 8c4499f438ae372050120620ffbfbe1dae21deab
Need webpack loaders
npm install --save-dev html-webpack-plugin clean-webpack-plugin terser-webpack-plugin

Need screenshot plugin
npm install --save-dev puppeteer

 # To build
 1229  cd build/
 1230  ls
 1231  nohup ./randomv2.sh &
 1232  tail -f nohup.out

# To screenshot
 1345  node screenshotmaker.js

# To add to IPFS
1386  nohup ipfs add --recursive ./copies &

# To compress GLTF files
https://github.com/CesiumGS/gltf-pipeline
sudo npm install -g gltf-pipeline
