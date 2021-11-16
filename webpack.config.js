const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  mode: 'production',
  entry: './src/index.js',
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Derek Kaplan',
      template: 'src/index.html',
    }),
    new MiniCssExtractPlugin({
      filename: 'index.[contenthash].css'
    }),
  ],
  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader",
        ]
      },
      {
        test: /\.pdf$/,
        type: "asset/resource",
      }
    ]
  },
  output: {
    filename: 'index.[contenthash].js',
    path: path.resolve(__dirname, 'dist'),
    clean: true,
    assetModuleFilename: '[name][ext][query]'
  },
};