// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

let channel = socket.channel('retrieve_flags:lobby', {});
let list = $('#message-list');
let user_id = $('#user_id');
let project_id = $('#project_id');

user_id.on('keypress', event => {
    if (event.keyCode == 13) {
        channel.push('shout', {
            project_id: project_id.val(),
            user_id: user_id.val()
        });
        user_id.val('');
    }
});

channel.on('shout', payload => {
    list.append(`<b>${payload.project_id || 'new_user'}:</b> ${payload.user_id}<br>`);
    list.prop({
        scrollTop: list.prop('scrollHeight')
    });
});

channel
    .join()
    .receive('ok', resp => { 
        console.log('Joined successfully', resp);
    })
    .receive('error', resp => {
        console.log('Unable to join', resp);
    });