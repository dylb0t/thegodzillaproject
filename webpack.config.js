var HtmlWebpackPlugin = require("html-webpack-plugin")
const { CleanWebpackPlugin } = require("clean-webpack-plugin")
const TerserPlugin = require('terser-webpack-plugin');
module.exports = (env) => {
    console.log('zillaNumber: ', env.zillaNumber);

    return{
        mode: "production",
        entry: "./build/output/"+env.zillaNumber+"/index.js",
        plugins: [
            new HtmlWebpackPlugin({
                favicon: "./src/assets/favicon.jpg",
                title: 'New Project Number '+env.zillaNumber
            }),
            new CleanWebpackPlugin()
        ],
	optimization: {
		minimizer: [
			new TerserPlugin({
				parallel: true
			})
		]
	},
        output: {
            filename: '[fullhash].js',
            path: __dirname + '/dist/' + env.zillaNumber
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
