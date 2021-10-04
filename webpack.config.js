var HtmlWebpackPlugin = require("html-webpack-plugin")
const { CleanWebpackPlugin } = require("clean-webpack-plugin")
module.exports = (env) => {
    console.log('pigNumber: ', env.pigNumber);

    return{
        mode: "production",
        entry: "./build/output/"+env.pigNumber+"/index.js",
        plugins: [
            new HtmlWebpackPlugin({
                favicon: "./src/assets/favicon.jpg",
                title: 'Cute Pig Club 3D Pig Number '+env.pigNumber
            }),
            new CleanWebpackPlugin()
        ],
        output: {
            filename: '[fullhash].js',
            path: __dirname + '/dist/' + env.pigNumber
        },
        module: {
            rules: [{ 
                test: /\.(gltf)$/i,
                loader: 'file-loader',
                options: {
                    publicPath: './',
                    name: '[hash]',
                    outputPath: "./"
                }
            },
            { 
                test: /\.(jpg)$/i,
                loader: 'file-loader',
                options: {
                    publicPath: './',
                    name: '[name].[ext]',
                    outputPath: "./"
            }
            },
            {
                test: /\.html$/,        
                use: ["html-loader"]
            },
            {
                test: /\.css$/,
                use: ["style-loader", "css-loader"]
            }
        ]
        }
    };
};