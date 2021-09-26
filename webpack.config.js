module.exports = {
    mode: "production",
    entry: "./src/index.js",
    output: {
        filename: "pigsample.js"
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
        }]
    }
}