const AV = require('leanengine')
const fs = require('fs')
const path = require('path')

/**
 * Loads all cloud functions under the `functions` directory.
 */
fs.readdirSync(path.join(__dirname, 'functions')).forEach( file => {
  require(path.join(__dirname, 'functions', file))
})

/**
 * A simple cloud function.
 */
// AV.Cloud.define('hello', function(request) {
//   return 'Hello world!'
// })
// AV.Cloud.define('queryUsers', async function (request) {
//   if (request.currentUser) {
//     const userQuery = new AV.Query('_User');
//     userQuery.addDescending('createdAt');
//     userQuery.notEqualTo('status', 'inactive');
//     return await userQuery.find();
//   } else {
//     throw new AV.Cloud.Error('用户未登录');
//   }
// });
